1.0版本

-- 1. 建立市場主表
CREATE TABLE markets (
    market_id SERIAL PRIMARY KEY,
    country_code VARCHAR(10) UNIQUE NOT NULL,
    market_name_tw VARCHAR(50) NOT NULL,
    market_name_jp VARCHAR(50) NOT NULL
);

-- 2. 建立月銷售額明細表
CREATE TABLE monthly_sales (
    sales_id SERIAL PRIMARY KEY,
    market_id INT REFERENCES markets(market_id) ON DELETE CASCADE,
    sale_year INT NOT NULL,
    sale_month INT NOT NULL,
    sale_amount NUMERIC(12,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. 寫入市場基本資料
INSERT INTO markets (country_code, market_name_tw, market_name_jp) VALUES
('TW', '台灣市場', '台湾市場'),
('JP', '日本市場', '日本市場');

-- 4. 寫入 2026 年 Q2 (4~6月) 實體銷售數據
INSERT INTO monthly_sales (market_id, sale_year, sale_month, sale_amount) VALUES
((SELECT market_id FROM markets WHERE country_code = 'TW'), 2026, 4, 125000.00),
((SELECT market_id FROM markets WHERE country_code = 'JP'), 2026, 4, 158000.00),
((SELECT market_id FROM markets WHERE country_code = 'TW'), 2026, 5, 210000.00),
((SELECT market_id FROM markets WHERE country_code = 'JP'), 2026, 5, 245000.00),
((SELECT market_id FROM markets WHERE country_code = 'TW'), 2026, 6, 142000.00),
((SELECT market_id FROM markets WHERE country_code = 'JP'), 2026, 6, 100273.00);

-- 5. 跨表彙總查詢 (格式化財務金額)
SELECT 
    ms.sale_month || '月' AS 月份,
    m.market_name_tw AS 市場,
    TO_CHAR(ms.sale_amount, 'FM$999,999,999.00') AS 銷售金額
FROM monthly_sales ms
JOIN markets m ON ms.market_id = m.market_id
WHERE ms.sale_year = 2026 AND ms.sale_month BETWEEN 4 AND 6
ORDER BY ms.sale_month, m.market_id;

2.0版本新增歷史匯率
    
-- STREAMING_CHUNK:Dropping existing tables safely...
-- 1. 刪除舊有表格（如存在，注意依賴關係順序）
DROP TABLE IF EXISTS exchange_rates CASCADE;
DROP TABLE IF EXISTS monthly_sales CASCADE;
DROP TABLE IF EXISTS markets CASCADE;

-- STREAMING_CHUNK:Creating markets table...
-- 2. 建立市場主表 (Markets)
CREATE TABLE markets (
    market_id SERIAL PRIMARY KEY,
    country_code VARCHAR(5) NOT NULL UNIQUE,
    market_name_tw VARCHAR(50) NOT NULL,
    market_name_jp VARCHAR(50) NOT NULL
);

-- STREAMING_CHUNK:Creating monthly sales table...
-- 3. 建立月度銷售數據表 (Monthly Sales)
CREATE TABLE monthly_sales (
    sales_id SERIAL PRIMARY KEY,
    market_id INT REFERENCES markets(market_id),
    sale_year INT NOT NULL DEFAULT 2026,
    sale_month INT NOT NULL CHECK (sale_month BETWEEN 1 AND 12),
    sale_amount NUMERIC(12, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- STREAMING_CHUNK:Creating exchange rates table...
-- 4. 建立歷史匯率表 (Exchange Rates) —— 【新增】
-- 用於管理跨國交易在不同月份的歷史匯率，定義將 TWD 換算為當地貨幣（如 JPY）的係數
CREATE TABLE exchange_rates (
    rate_id SERIAL PRIMARY KEY,
    market_id INT REFERENCES markets(market_id),
    rate_year INT NOT NULL,
    rate_month INT NOT NULL CHECK (rate_month BETWEEN 1 AND 12),
    twd_to_local_rate NUMERIC(10, 4) NOT NULL, -- 從 TWD 換算為當地貨幣的匯率係數
    currency_symbol VARCHAR(10) NOT NULL,  -- 當地貨幣符號 (如 TWD, JPY)
    CONSTRAINT unique_market_month_rate UNIQUE (market_id, rate_year, rate_month)
);

-- STREAMING_CHUNK:Inserting market data...
-- 5. 寫入市場基本資料
INSERT INTO markets (country_code, market_name_tw, market_name_jp) VALUES
('TW', '台灣市場', '台湾市場'),
('JP', '日本市場', '日本市場');

-- STREAMING_CHUNK:Inserting monthly sales records...
-- 6. 寫入 2026 年 Q2 (4~6月) 實體銷售數據（全數為新台幣 TWD 金額）
INSERT INTO monthly_sales (market_id, sale_year, sale_month, sale_amount) VALUES
((SELECT market_id FROM markets WHERE country_code = 'TW'), 2026, 4, 125000.00),
((SELECT market_id FROM markets WHERE country_code = 'JP'), 2026, 4, 158000.00),
((SELECT market_id FROM markets WHERE country_code = 'TW'), 2026, 5, 210000.00),
((SELECT market_id FROM markets WHERE country_code = 'JP'), 2026, 5, 245000.00),
((SELECT market_id FROM markets WHERE country_code = 'TW'), 2026, 6, 142000.00),
((SELECT market_id FROM markets WHERE country_code = 'JP'), 2026, 6, 100273.00);

-- STREAMING_CHUNK:Inserting historical exchange rates...
-- 7. 寫入 2026 年 Q2 各月歷史為替（匯率）數據 —— 用於將 TWD 統一換算為日幣 JPY
INSERT INTO exchange_rates (market_id, rate_year, rate_month, twd_to_local_rate, currency_symbol) VALUES
-- 台灣市場也需要對應的換算匯率（例如 1 TWD = 4.8 JPY，以便集團財報統一以日幣呈現）
((SELECT market_id FROM markets WHERE country_code = 'TW'), 2026, 4, 4.8200, 'JPY'),
((SELECT market_id FROM markets WHERE country_code = 'TW'), 2026, 5, 4.8500, 'JPY'),
((SELECT market_id FROM markets WHERE country_code = 'TW'), 2026, 6, 4.8000, 'JPY'),
-- 日本市場：將新台幣換算為日幣的歷史匯率
((SELECT market_id FROM markets WHERE country_code = 'JP'), 2026, 4, 4.8200, 'JPY'),
((SELECT market_id FROM markets WHERE country_code = 'JP'), 2026, 5, 4.8500, 'JPY'),
((SELECT market_id FROM markets WHERE country_code = 'JP'), 2026, 6, 4.8000, 'JPY');

-- STREAMING_CHUNK:Executing unified JPY financial join query...
-- 8. 綜合查詢（全集團統一轉換為日幣 JPY）：將各市場原始 TWD 銷售額，全面透過當月匯率換算為集團統一幣種 (JPY)
SELECT 
    ms.sale_year || '年 ' || ms.sale_month || '月' AS 月份,
    m.market_name_tw AS 市場,
    TO_CHAR(ms.sale_amount, 'FM$999,999,999.00') AS 原始銷售額_TWD,
    er.twd_to_local_rate AS 統一換算匯率_TWD_to_JPY,
    er.currency_symbol AS 集團財報幣種,
    TO_CHAR(ms.sale_amount * er.twd_to_local_rate, 'FM999,999,999.00') || ' ' || er.currency_symbol AS 統一換算後營收
FROM monthly_sales ms
JOIN markets m ON ms.market_id = m.market_id
JOIN exchange_rates er 
  ON ms.market_id = er.market_id 
 AND ms.sale_year = er.rate_year 
 AND ms.sale_month = er.rate_month
WHERE ms.sale_year = 2026 AND ms.sale_month BETWEEN 4 AND 6
ORDER BY ms.sale_month, m.market_id;

3.0版本新增匯率手續費

-- 1. 刪除舊有表格（如存在）
DROP TABLE IF EXISTS exchange_rates CASCADE;
DROP TABLE IF EXISTS monthly_sales CASCADE;
DROP TABLE IF EXISTS markets CASCADE;

-- 2. 建立市場主表 (Markets)
CREATE TABLE markets (
    market_id SERIAL PRIMARY KEY,
    country_code VARCHAR(5) NOT NULL UNIQUE,
    market_name_tw VARCHAR(50) NOT NULL,
    market_name_jp VARCHAR(50) NOT NULL
);

-- 3. 建立月度銷售數據表 (Monthly Sales)
CREATE TABLE monthly_sales (
    sales_id SERIAL PRIMARY KEY,
    market_id INT REFERENCES markets(market_id),
    sale_year INT NOT NULL DEFAULT 2026,
    sale_month INT NOT NULL CHECK (sale_month BETWEEN 1 AND 12),
    sales_amount NUMERIC(12, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. 建立歷史匯率表 (Exchange Rates) —— 【含手續費率優化】
CREATE TABLE exchange_rates (
    rate_id SERIAL PRIMARY KEY,
    market_id INT REFERENCES markets(market_id),
    rate_year INT NOT NULL,
    rate_month INT NOT NULL CHECK (rate_month BETWEEN 1 AND 12),
    twd_to_local_rate NUMERIC(10, 4) NOT NULL, 
    handling_fee_rate NUMERIC(5, 4) DEFAULT 0.0050, 
    effective_rate NUMERIC(10, 4) GENERATED ALWAYS AS (twd_to_local_rate * (1 - handling_fee_rate)) STORED,
    currency_symbol VARCHAR(10) NOT NULL,  
    CONSTRAINT unique_market_month_rate UNIQUE (market_id, rate_year, rate_month)
);

-- 5. 寫入市場基本資料
INSERT INTO markets (country_code, market_name_tw, market_name_jp) VALUES
('TW', '台灣市場', '台湾市場'),
('JP', '日本市場', '日本市場');

-- 6. 寫入 2026 年 Q2 實體銷售數據
INSERT INTO monthly_sales (market_id, sale_year, sale_month, sales_amount) VALUES
((SELECT market_id FROM markets WHERE country_code = 'TW'), 2026, 4, 125000.00),
((SELECT market_id FROM markets WHERE country_code = 'JP'), 2026, 4, 158000.00),
((SELECT market_id FROM markets WHERE country_code = 'TW'), 2026, 5, 210000.00),
((SELECT market_id FROM markets WHERE country_code = 'JP'), 2026, 5, 245000.00),
((SELECT market_id FROM markets WHERE country_code = 'TW'), 2026, 6, 142000.00),
((SELECT market_id FROM markets WHERE country_code = 'JP'), 2026, 6, 100273.00);

-- 7. 寫入 2026 年 Q2 各月歷史匯率與手續費率
INSERT INTO exchange_rates (market_id, rate_year, rate_month, twd_to_local_rate, handling_fee_rate, currency_symbol) VALUES
((SELECT market_id FROM markets WHERE country_code = 'TW'), 2026, 4, 4.8200, 0.0050, 'JPY'),
((SELECT market_id FROM markets WHERE country_code = 'TW'), 2026, 5, 4.8500, 0.0050, 'JPY'),
((SELECT market_id FROM markets WHERE country_code = 'TW'), 2026, 6, 4.8000, 0.0050, 'JPY'),
((SELECT market_id FROM markets WHERE country_code = 'JP'), 2026, 4, 4.8200, 0.0050, 'JPY'),
((SELECT market_id FROM markets WHERE country_code = 'JP'), 2026, 5, 4.8500, 0.0050, 'JPY'),
((SELECT market_id FROM markets WHERE country_code = 'JP'), 2026, 6, 4.8000, 0.0050, 'JPY');


-- ========================================================
-- 【底下直接添加】8. 建立檢視表 (View)，讓以後不用重打查詢
-- ========================================================
CREATE OR REPLACE VIEW v_cross_border_financial_summary AS
SELECT 
    ms.sale_year || '年 ' || ms.sale_month || '月' AS 月份,
    ms.sale_year,
    ms.sale_month,
    m.market_name_tw AS 市場,
    ms.sales_amount AS 原始銷售額_TWD,
    er.twd_to_local_rate AS 原始歷史匯率,
    (er.handling_fee_rate * 100) AS 銀行手續費率_百分比,
    er.effective_rate AS 實質有效匯率_扣除手續費,
    ROUND(ms.sales_amount * er.effective_rate, 2) AS 實質入帳營收淨額,
    ROUND(ms.sales_amount * (er.twd_to_local_rate - er.effective_rate), 2) AS 手續費成本損益,
    er.currency_symbol AS 幣種
FROM monthly_sales ms
JOIN markets m ON ms.market_id = m.market_id
JOIN exchange_rates er 
  ON ms.market_id = er.market_id 
 AND ms.sale_year = er.rate_year 
 AND ms.sale_month = er.rate_month;

SELECT * FROM v_cross_border_financial_summary;
