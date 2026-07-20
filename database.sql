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
