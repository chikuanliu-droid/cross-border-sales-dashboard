📊 クロスボーダー販売データ分析システム (Cross-Border Sales Dashboard)

本プロジェクトは、バックエンドのデータベース設計からシステムアーキテクチャ、そしてビジネス意思決定を可視化する高精度（High-Fidelity）なUI/UXダッシュボードの構築まで、一貫して実装したフルスタックデータ分析プロジェクトです。

🛠️ フェーズ1：バックエンドデータベース開発 (PostgreSQL / DBeaver)

<img width="1470" height="956" alt="截圖 2026-07-20 中午12 37 27" src="https://github.com/user-attachments/assets/9c5112fe-c122-42f1-a21c-b93acf221ec9" />

実装のポイント：

拡張性の高いリレーショナル設計：PostgreSQL を使用してリレーショナルテーブル（markets と monthly_sales）を構築し、Foreign Key (FK) による整合性を担保。

財務レベルのデータ精度：標準的な SQL 結合クエリ（JOIN）を記述し、TO_CHAR(..., 'FM$999,999,999.00') を用いて財務レベルの金額フォーマットを適用。Q2（4〜6月）の総売上 $980,273.00 を正確に集計。

📐 フェーズ2：システムアーキテクチャとER図設計 (Draw.io)

<img width="612" height="369" alt="截圖 2026-07-22 上午10 07 26" src="https://github.com/user-attachments/assets/0c050cbd-25fb-4a1f-88d7-bd2236de53f7" />

実装のポイント：

業界標準のER図：データベースのエンティティに基づき、業界標準に準拠した ERD (Entity Relationship Diagram) を作成。

論理関係とカーディナリティ：Primary Key (PK) と Foreign Key (FK) の紐付けを明確にし、1 : N（1対多） のリレーションシップを正確に図式化。

🎨 フェーズ3：高精度データビジュアルUI (Figma)

<img width="646" height="411" alt="截圖 2026-07-20 中午12 36 45" src="https://github.com/user-attachments/assets/d33cf99a-d92f-4884-bbb7-db0cf892ff0e" />

実装のポイント：

100%のデータ忠実度：グラフの棒の高さ比率、カラーリング（赤：台湾 / 青：日本）、および上部の数値ラベル（Data Labels）を、PostgreSQL のクエリ結果と完全に一致させています。

主要なビジネスインサイト (Business Insights)：

4月と5月は日本市場がリードし、5月は全四半期の最高ピークを記録（日本 $245K、台湾 $210K）。

6月は全体的に売上が減少したものの、台湾市場（$142K）が日本市場（$100K）を逆転し、視覚的に強いコントラストを演出。

UIコンポーネント規範 (Auto Layout)：Auto Layout を活用して二色棒グラフとテキストラベルを垂直・水平にネストし、データ変動時にもレイアウトが崩れない柔軟性を実現。

🏆 実装された専門スキル (Key Skills Demonstrated)

データベースエンジニアリング (Database Engineering): DDL テーブル作成、DML データ挿入、DQL リレーション集計クエリ。

システム分析 (System Analysis): ERD（実体関連図）設計、システムデータフローの論理構築。

UI/UXデザイン (UI/UX Design): Figma Auto Layout の活用、データビジュアル化原則、ビジネスプレゼンテーション美学。
