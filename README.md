📊 專案作品：跨境電商台日市場銷售分析系統 (Cross-Border Sales Dashboard)

本專案是一個完整全端（End-to-End）的數據分析系統設計。從後端實體資料庫的建置、關聯式架構的設計，到前端符合商業決策的高保真（High-Fidelity）視覺化圖表還原，全面對齊 2026 年 Q2 的實際銷售數據。

🛠️ 第一階段：後端資料庫開發 (PostgreSQL / DBeaver)


<img width="1470" height="956" alt="截圖 2026-07-20 中午12 37 27" src="https://github.com/user-attachments/assets/4a6d6854-57cc-4bc7-8aad-548cb00e8e35" />

實作亮點：

高度擴充性關聯設計：使用 PostgreSQL 建立關聯式資料表（markets 與 monthly_sales），並利用 Foreign Key (FK) 建立防呆關聯。

財務級數據精確度：撰寫標準 SQL 連接查詢（JOIN），並採用 TO_CHAR(..., 'FM$999,999,999.00') 進行財務級金額格式化，解決資料庫長度溢位（###）問題，輸出 Q2 總額 $980,273.00 的乾淨數據集。

📐 第二階段：系統架構與關係圖設計 (Draw.io)


![Uploading 截圖 2026-07-22 上午10.07.26.png…]()
實作亮點：

業界標準 ERD 繪製：依據資料庫實體表，繪製符合業界標準的 ERD (Entity Relationship Diagram)。

邏輯傳遞與基數標註：清楚標示 Primary Key (PK) 與 Foreign Key (FK) 的傳遞關係，並準確標註 1 : N (一對多) 關聯基數（Cardinality），展現清晰的系統資料流思維。

🎨 第三階段：高保真數據視覺化介面 (Figma)


<img width="646" height="411" alt="截圖 2026-07-20 中午12 36 45" src="https://github.com/user-attachments/assets/a2023d3c-7d11-40b7-88af-938d2dc46a2c" />

實作亮點：

100% 數據真實還原：圖表中的長條高度比例、顏色對應（紅色：台灣 / 藍色：日本）及頂端數值標籤（Data Labels），完全與後端 PostgreSQL 的查詢結果精確對齊。

關鍵商業洞察 (Business Insights)：

4月與5月由日本市場領先，5月份達到雙市場全季最高峰（日本 $245K、台灣 $210K）。

6月份雖然整體下滑，但台灣市場（$142K）成功反超日本市場（$100K），在視覺上給予決策者強烈的對比暗示。

UI 元件規範 (Auto Layout)：採用 Auto Layout 進行雙色長條圖與文字標籤的垂直、水平打包，確保界面在未來數據變動時能夠自動適應、防抖、不跑版。

🏆 專業技能展現 (Key Skills Demonstrated)

資料庫工程 (Database Engineering): DDL 建表、DML 資料寫入、DQL 關聯彙總查詢。

系統分析 (System Analysis): 實體關係圖 (ERD) 設計、系統資料流邏輯。

UI/UX 設計 (UI/UX Design): Figma Auto Layout 應用、數據視覺化原則、商業簡報美學。
