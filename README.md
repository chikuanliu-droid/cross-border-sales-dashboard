🌐 **Language Documents**: 
* [繁體中文 README.md](https://github.com/chikuanliu-droid/cross-border-sales-dashboard/blob/main/README.md)
* [日本語技術仕様書 README.JP.md](https://github.com/chikuanliu-droid/cross-border-sales-dashboard/blob/main/README.JP.md)

---

📊 跨境金流與匯兌損耗 Dashboard (Cross-Border Sales & FX Fee Dashboard)

🚀 【V3.0 升級亮點】
本專案迎來重大架構與視覺突破！在 V3.0 中，全面整合了「PostgreSQL 資料庫架構（含手續費與 View 檢視表）」、「Draw.io 系統關聯架構（ERD）」以及「Figma 堆疊長條圖，前端視覺化」三大核心模組。完美模擬跨國集團在真實金流扣款與換匯環境下，如何透過嚴謹的資料流轉與雙軌對照，精準掌控「總營收」與「實質入帳淨額」的動態損益閉環！

---

🆕 最新功能：跨境金流手續費與實質淨額損益模組 (V3.0 Feature)

為了解決跨國交易中不可忽視的銀行換匯手續費與價差損益，本專案在完整保留既有架構的前提下，正式導入了 0.5% 手續費損耗扣除與 Figma 堆疊長條圖視覺化模組。

---


實作亮點：PostgreSQL-資料庫與檢視表模組 

<img width="1470" height="956" alt="3 0 - SQL" src="https://github.com/user-attachments/assets/49eab6d0-457f-431e-9ecc-0e98a42533b9" />

資料表與欄位優化：於 exchange_rates 表中新增 handling_fee_rate（預設 0.5%）與透過 GENERATED ALWAYS AS 自動計算的 effective_rate（實質有效匯率）。

檢視表 (View)：建立 v_cross_border_financial_summary，將各市場的原始銷售額、歷史匯率、實質入帳營收淨額與手續費成本損益完整封裝，查詢時不需重複計算。

---

實作亮點：Draw.io 系統架構與關聯圖

<img width="849" height="409" alt="3 0 - ER圖" src="https://github.com/user-attachments/assets/7b8a22eb-8cd1-415f-852e-48aa52dcd83c" />


三表關聯對齊：明確定義 MARKETS（市場主表）、MONTHLY_SALES（月度銷售表）與 EXCHANGE_RATES（歷史匯率表）之間的 1 : N 主外鍵關聯。

資料流轉視覺化：繪製自資料表延伸至 V_CROSS_BORDER_SUMMARY (VIEW) 的運算邏輯路徑（包含 amount_twd * effective_rate 與損益計算），確保系統架構清晰易懂。

---

實作亮點：Figma 堆疊長條圖與雙軌幣別視覺化

<img width="723" height="433" alt="3 0 - FIGMA" src="https://github.com/user-attachments/assets/ac8fc7f6-549b-4500-a93d-168fc963c9e8" />

堆疊長條圖：前端介面將長條圖優化為上下堆疊結構，底部主體呈現實質淨額與在地原始金額（TWD），頂端以高識別度色彩疊加呈現「手續費成本損益帽子」。

雙幣別與「總營收」與「實質入帳淨額」雙軌對照：上方統一採用結算幣別（JPY）標示總額與手續費差價，下方同步保留在地交易幣別（TWD）原始總額，兼具財務嚴謹度與極致的視覺易讀性。

---

📊 跨境銷售與歷史匯率 Dashboard (Cross-Border Sales Dashboard)

🚀 【V2.0 升級亮點】
本專案已全面導入 PostgreSQL 固定歷史匯率表 (exchange_rates) 與 Figma 雙軌數值標籤（JPY 統一財報幣種 + TWD 原始金額），完美模擬跨國集團採用「固定歷史匯率」基準的財報級數據流轉與營收結算邏輯！

---

最新新增：固定歷史匯率擴充模組 (V2.0 Feature)

為解決跨國銷售的多幣種財報整合問題，本專案在**完全不破壞既有資料架構**的前提下，擴充了固定歷史匯率計算模組。

---

實作亮點：PostgreSQL-獨立匯率表建置及固定歷史匯率結算

<img width="1470" height="956" alt="截圖 2026-07-22 中午12 05 11" src="https://github.com/user-attachments/assets/b8b65dad-2010-41e1-9741-d596f4189623" />

獨立匯率表建置 (exchange_rates)：建立獨立的固定歷史匯率資料表，保存特定歷史期間的基準匯率（如 TWD/JPY 換算率），確保原本的 `monthly_sales` 原始數據不受影響。

固定歷史匯率結算：透過 JOIN 匯率表進行金額折算，採用固定歷史匯率作為財報統計基準，有效排除短線匯率波動噪訊，真實反映市場銷售力道。

---

實作亮點：Draw.io ERD 圖擴充

<img width="788" height="488" alt="截圖 2026-07-22 上午10 52 17" src="https://github.com/user-attachments/assets/3ce14732-9d29-4a6f-90e6-cb61053bb430" />

於系統架構圖中更新三表關聯（markets、monthly_sales 與 exchange_rates），明確標示匯率表與銷售表之間的 PK/FK 傳遞與 1:N 關聯邏輯。

---

實作亮點：Figma 雙軌幣種標籤

<img width="637" height="390" alt="截圖 2026-07-22 上午11 25 18" src="https://github.com/user-attachments/assets/071bdc40-0b56-46b9-a82d-39804bc743c8" />

前端視覺化介面升級支援「原始金額 (TWD)」與「統一財報金額 (JPY)」雙軌數值標籤，提供跨國決策者更直覺的財務全貌。

---

📊 專案作品：跨境電商台日市場銷售分析系統 (Cross-Border Sales Dashboard)

本專案是一個完整全端（End-to-End）的數據分析系統設計。從後端實體資料庫的建置、關聯式架構的設計，到前端符合商業決策的高保真（High-Fidelity）視覺化圖表還原，全面對齊 2026 年 Q2 的實際銷售數據。

---

第一階段：後端資料庫開發 (PostgreSQL / DBeaver)

<img width="1470" height="956" alt="截圖 2026-07-20 中午12 37 27" src="https://github.com/user-attachments/assets/4a6d6854-57cc-4bc7-8aad-548cb00e8e35" />

實作亮點：
高度擴充性關聯設計：使用 PostgreSQL 建立關聯式資料表（markets 與 monthly_sales），並利用 Foreign Key (FK) 建立防呆關聯。
財務級數據精確度：撰寫標準 SQL 連接查詢（JOIN），並採用 `TO_CHAR(..., 'FM$999,999,999.00')` 進行財務級金額格式化，解決資料庫長度溢位（###）問題，輸出 Q2 總額 $980,273.00 的乾淨數據集。

---

第二階段：系統架構與關係圖設計 (Draw.io)

<img width="612" height="369" alt="截圖 2026-07-22 上午10 07 26" src="https://github.com/user-attachments/assets/d4f2d5a4-b35d-40ef-95fc-c7cb8e676445" />

實作亮點：
業界標準 ERD 繪製：依據資料庫實體表，繪製符合業界標準的 ERD (Entity Relationship Diagram)。
邏輯傳遞與基數標註：清楚標示 Primary Key (PK) 與 Foreign Key (FK) 的傳遞關係，並準確標註 1 : N (一對多) 關聯基數（Cardinality），展現清晰的系統資料流思維。

---

第三階段：高保真數據視覺化介面 (Figma)

<img width="646" height="411" alt="截圖 2026-07-20 中午12 36 45" src="https://github.com/user-attachments/assets/a2023d3c-7d11-40b7-88af-938d2dc46a2c" />

實作亮點：
100% 數據真實還原：圖表中的長條高度比例、顏色對應（紅色：台灣 / 藍色：日本）及頂端數值標籤（Data Labels），完全與後端 PostgreSQL 的查詢結果精確對齊。
關鍵商業洞察 (Business Insights)：
  4月與5月由日本市場領先，5月份達到雙市場全季最高峰（日本 $245K、台灣 $210K）。
  6月份雖然整體下滑，但台灣市場（$142K）成功反超日本市場（$100K），在視覺上給予決策者強烈的對比暗示。
UI 元件規範 (Auto Layout)：採用 Auto Layout 進行雙色長條圖與文字標籤的垂直、水平打包，確保界面在未來數據變動時能夠自動適應、防抖、不跑版。

---

🏆 專業技能展現 (Key Skills Demonstrated)

資料庫工程 (Database Engineering): DDL 建表、DML 資料寫入、DQL 關聯彙總與固定歷史匯率模組擴充查詢。
財務與系統分析 (Financial & System Analysis): 實體關係圖 (ERD) 設計、固定歷史匯率結算邏輯、系統資料流規劃。
UI/UX 設計 (UI/UX Design): Figma Auto Layout 應用、數據視覺化原則、雙軌數值標籤呈現與商業簡報美學。
