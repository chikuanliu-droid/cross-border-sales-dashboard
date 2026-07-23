🌐 **Language Documents**: 
* [繁體中文 README.md](https://github.com/chikuanliu-droid/cross-border-sales-dashboard/blob/main/README.md)
* [日本語技術仕様書 README.JP.md](https://github.com/chikuanliu-droid/cross-border-sales-dashboard/blob/main/README.JP.md)

---

📊 クロスボーダー決済・為替損益ダッシュボード (Cross-Border Sales & FX Fee Dashboard)

🚀 【V3.0 アップグレードのハイライト】

本プロジェクトは、アーキテクチャおよびビジュアル面で大幅なアップデートを実現しました！V3.0 では、「PostgreSQL データベース構造（手数料および View ビューを含む）」、「Draw.io システム連携図（ERD）」、そして「Figma 積み上げ棒グラフ、フロントエンド視覚化」という3つのコアモジュールを完全に統合しました。多国籍グループが実際の決済引き落としや為替換算環境において、厳格なデータフローとデュアルトラック照合を通じて「総売上」と「実質入金純額」の動的損益ループを厳格なデータフローとデュアルトラック照合を活用し、「総売上」と「実質入金純額」の動的な損益サイクルを正確に管理する仕組みを実現しました。！

---

🆕 最新機能：クロスボーダー決済手数料および実質純額損益モジュール (V3.0 Feature)

クロス取引において無視できない銀行の両替手数料やスプレッド損益を解決するため、本プロジェクトでは既存のアーキテクチャを一切損なうことなく、0.5%の手数料損耗控除とFigma積み上げ棒グラフの視覚化モジュールを正式に導入しました。

---

実装のポイント：PostgreSQL データベースおよびビューモジュール

<img width="1470" height="956" alt="PostgreSQL 実行画面 2026-07-23" src="https://github.com/user-attachments/assets/85826117-891c-40a1-94ad-d2d872c21940" />

データテーブルとカラムの最適化: exchange_rates テーブルに handling_fee_rate（デフォルト 0.5%）を追加し、GENERATED ALWAYS AS を通じて自動計算される effective_rate（実質有効為替レート）を実装。

ビュー (View): v_cross_border_financial_summary を作成し、各市場の元売上高、履歴レート、実質入金売上純額、および手数料コスト損益を完全にカプセル化。クエリ実行時の重複計算を不要化。

---

実装のポイント：Draw.io システムアーキテクチャおよび関連図

<img width="849" height="409" alt="Draw.io ER図 2026-07-23" src="https://github.com/user-attachments/assets/92c2da88-9c48-4c82-8659-be8a1a2b8fbe" />

3テーブルの関連付けの整合: MARKETS（市場マスタ）、MONTHLY_SALES（月別売上テーブル）、EXCHANGE_RATES（履歴レートテーブル）間の 1 : N 主・外部キーリレーションを明確に定義。

データフローの視覚化: データテーブルから V_CROSS_BORDER_SUMMARY (VIEW) に至るまでの演算ロジック経路（amount_twd * effective_rate および損益計算を含む）を描画し、システム構造を明快かつわかりやすく表現。

---

実装のポイント：Figma 積み上げ棒グラフとデュアル通貨の視覚化

<img width="723" height="433" alt="Figma UI ダッシュボード 2026-07-22" src="https://github.com/user-attachments/assets/fb71fb05-e5c9-4795-8a32-fb260795ed45" />

積み上げ棒グラフ: フロントエンドインターフェースの棒グラフを上下の積み上げ構造に最適化。下部主体に実質純額と現地元通貨（TWD）を表現し、頂部には高い識別性を持つカラーブロックで「手数料コスト損益ハット」を重ねて表示。

デュアル通貨および「総売上」対「実質入金純額」のデュアルトラック照合: 上部は決済通貨（JPY）に統一して総額と手数料差額を表示し、下部は現地取引通貨（TWD）の元総額を同時に保持することで、財務の厳密性と極限の視覚的読みやすさを両立。

---

📊 クロスボーダー売上＆固定歴史為替ダッシュボード (Cross-Border Sales Dashboard)

🚀 【V2.0 アップデートのポイント】
本プロジェクトでは、PostgreSQL 固定歴史為替テーブル (exchange_rates) および Figma 2系統数値ラベル（JPY 統一財務会計通貨 ＋ TWD 原通貨金額）を全面導入しました。グローバル企業における「固定歴史為替レート」基準の財務級データフローと売上決算ロジックを忠実に再現しています！

---

🆕 最新機能：固定歴史為替拡張モジュール (V2.0 Feature)

多国間売上における多通貨財務レポートの統合課題を解決するため、本プロジェクトでは既存のデータ構造を一切破綻させることなく、固定歴史為替計算モジュールを拡張しました：

---

実装のポイント：PostgreSQL-独立為替テーブルの構築および固定歴史為替による決算処理

<img width="1470" height="956" alt="PostgreSQL 実行画面 2026-07-22" src="https://github.com/user-attachments/assets/e2e23c3a-78f8-4ab5-9fff-9327258b7fda" />

独立為替テーブルの構築 (exchange_rates)：

独立した固定歴史為替データテーブルを構築し、特定の対象期間における基準レート（TWD/JPY 換算レートなど）を保持することで、元の monthly_sales テーブルの生データに影響を与えない設計を実現。

固定歴史為替による決算処理：

為替テーブルとの JOIN 結合により金額を換算。固定歴史為替を財務統計基準として採用することで、短期的な為替変動ノイズを効果的に排除し、各市場の純粋な販売力を正しく評価することを可能にしました。。

---

実装のポイント：Draw.io ER図の拡張

<img width="788" height="488" alt="Draw.io ER図 2026-07-22" src="https://github.com/user-attachments/assets/77d7eaa7-c435-4da7-888c-b6a8f2019420" />

システムアーキテクチャ図において3つのテーブル間（markets、monthly_sales、exchange_rates）のリレーションシップを更新し、為替テーブルと売上テーブル間の主キー (PK) / 外部キー (FK) の継承関係および 1:N の関連性ロジックを明確化。

---

実装のポイント：Figma 2系統通貨ラベル

<img width="637" height="390" alt="Figma UI ダッシュボード 2026-07-22" src="https://github.com/user-attachments/assets/2367130f-3455-4f8d-9831-eb43ed2ad690" />

フロントエンドの可視化インターフェースをアップグレードし、「原通貨金額 (TWD)」と「統一財務金額 (JPY)」のダブル数値ラベルに対応。グローバル意思決定者へより直感的な財務全体像を提供。

---

📊 クロスボーダー販売データ分析システム (Cross-Border Sales Dashboard)

本プロジェクトは、バックエンドのデータベース設計からシステムアーキテクチャ、そしてビジネス意思決定を可視化する高精度（High-Fidelity）なUI/UXダッシュボードの構築まで、一貫して実装したフルスタックデータ分析プロジェクトです。

---

バックエンドデータベース開発 (PostgreSQL / DBeaver)

<img width="1470" height="956" alt="PostgreSQL 実行画面 2026-07-20" src="https://github.com/user-attachments/assets/9c5112fe-c122-42f1-a21c-b93acf221ec9" />

実装のポイント：

拡張性の高いリレーショナル設計：

PostgreSQL を使用してリレーショナルテーブル（markets と monthly_sales）を構築し、Foreign Key (FK) による整合性を担保。

財務レベルのデータ精度：

標準的な SQL 結合クエリ（JOIN）を記述し、TO_CHAR(..., 'FM$999,999,999.00') を用いて財務レベルの金額フォーマットを適用。Q2（4〜6月）の総売上 $980,273.00 を正確に集計。

---

システムアーキテクチャとER図設計 (Draw.io)

<img width="612" height="369" alt="Draw.io ER図 2026-07-20" src="https://github.com/user-attachments/assets/0c050cbd-25fb-4a1f-88d7-bd2236de53f7" />

実装のポイント：

業界標準のER図：

データベースのエンティティに基づき、業界標準に準拠した ERD (Entity Relationship Diagram) を作成。

論理関係とカーディナリティ：

Primary Key (PK) と Foreign Key (FK) の紐付けを明確にし、1 : N（1対多） のリレーションシップを正確に図式化。

---

高精度データビジュアルUI (Figma)

<img width="646" height="411" alt="Figma UI ダッシュボード 2026-07-20" src="https://github.com/user-attachments/assets/d33cf99a-d92f-4884-bbb7-db0cf892ff0e" />

実装のポイント：

100%のデータ忠実度：

グラフの棒の高さ比率、カラーリング（赤：台湾 / 青：日本）、および上部の数値ラベル（Data Labels）を、PostgreSQL のクエリ結果と完全に一致させています。

主要なビジネスインサイト (Business Insights)：

4月と5月は日本市場がリードし、5月は全四半期の最高ピークを記録（日本 $245K、台湾 $210K）。

6月は全体的に売上が減少したものの、台湾市場（$142K）が日本市場（$100K）を逆転し、視覚的に強いコントラストを演出。

UIコンポーネント規範 (Auto Layout)：Auto Layout を活用して二色棒グラフとテキストラベルを垂直・水平にネストし、データ変動時にもレイアウトが崩れない柔軟性を実現。

---

実装された専門スキル (Key Skills Demonstrated)

データベースエンジニアリング (Database Engineering): DDL テーブル作成、DML データ挿入、DQL リレーション集計クエリ。

システム分析 (System Analysis): ERD（実体関連図）設計、システムデータフローの論理構築。

UI/UXデザイン (UI/UX Design): Figma Auto Layout の活用、データビジュアル化原則、ビジネスプレゼンテーション美学。
