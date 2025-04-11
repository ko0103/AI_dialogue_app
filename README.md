# プロジェクト名: AI_dialogue
[![Image from Gyazo](https://i.gyazo.com/fd8cb1f5174fed0c8b55d2407eab2c1b.png)](https://gyazo.com/fd8cb1f5174fed0c8b55d2407eab2c1b)
<br>
サービスURL: https://ai-dialogue.jp/
<br>

# 目次
- [サービス概要](#サービス概要)
- [サービス開発背景](#サービス開発背景)
- [機能紹介](#機能紹介)
- [使用技術](#使用技術)
- [画面遷移図](#画面遷移図)
- [ER図](#er図)
<br>

# サービス概要
AIとのチャットコミュニケーションアプリ。  
難易度「初級」「中級」「上級」「フリーテーマ」の4つのレベルに分けてランダムなテーマについてAIと議論し、10回のチャットの応酬で終了。
最終的にそのやり取りがどれだけテーマに沿った議論だったかをAIにスコアとして表示してもらい点数化しランキングとして掲載していきます。
<br>

# サービス開発背景
発想のきっかけとしては、  
- 元々自身がAIに興味があってエンジニアを目指していたこと  
- RUNTEQの学習でロボらんてくん（ChatGPT）にお世話になり大変感謝していること  
以上の２点よりAIを用いたアプリを製作したいという思いがあったことが原点として挙げられます。 <br>
また自分が拝読させていただいているとあるマンガにて主人公とヒロインが「哲学対話」というディベート形式で自身の思考を対話の中で明確化させ相手に発信する、というシーンを拝見しこのコミュニケーションが日常生活はもちろん今後のエンジニアとしての職場などでも活かせる良い経験になるのでは？という考えに至り、哲学対話のようなルールに則ったサービスを製作してみようと思いました。<br>
自分自身はコミュニケーション下手だという自覚もありますので、同じようにコミュニケーションで悩んでいる方々に向けて、対話における練習となればいいなという思いもあります。
<br>

# 機能紹介
| ユーザー登録 |
| :---: |
| [![Image from Gyazo](https://i.gyazo.com/895accd0e3b9b9fdd711f117f0d0503c.png)](https://gyazo.com/895accd0e3b9b9fdd711f117f0d0503c) |
| <p align="left"> 「名前」「メールアドレス」 「パスワード」を入力してユーザー登録。<br>Googleアカウントでの登録も可能です。<br> シンプルなデザインで分かりやすくしています。</p> |
<br>

| サービス説明とテーマ選択 |
| :---: |
| [![Image from Gyazo](https://i.gyazo.com/b901af1d77b36a310d4341f8278589a3.gif)](https://gyazo.com/b901af1d77b36a310d4341f8278589a3) |
| <p align="left"> 新規登録またはログイン後、この画面にてサービスのルールについての説明書きの表示とテーマの選択をしていただきます。<br>テーマは難易度ごとにランダムで表示されるものから選ぶか、『フリーテーマ』としてユーザーが独自に入力した話題についてお話しいただけます。</p> |
<br>

| チャット画面 |
| :---: |
| [![Image from Gyazo](https://i.gyazo.com/7043aaafef36220c1c270031160602b3.png)](https://gyazo.com/7043aaafef36220c1c270031160602b3) |
| <p align="left"> AIとのチャットでは選択したテーマについて話し合います。<br>ユーザーの考えを導くようにカスタマイズしたAIはユーザーのメッセージに対して質問やAIからの意見を述べてくるので、ユーザーは自身の考えをそのまま述べたり、わざと関係ないことを言って反応を楽しんでください！ </p> |
<br>

| 採点機能 |
| :---: |
| [![Image from Gyazo](https://i.gyazo.com/b955bbf27e6310532da7491fcd8559e2.png)](https://gyazo.com/b955bbf27e6310532da7491fcd8559e2) |
| [![Image from Gyazo](https://i.gyazo.com/b90b697955a931073307d277314bb5e9.gif)](https://gyazo.com/b90b697955a931073307d277314bb5e9) |
| <p align="left">チャット1回につきメッセージは10回までで、そのメッセージの履歴を元に論理的に採点してもらえます！<br>また、各難易度ごとに上位10名までを表示するランキング機能もついています。</p> |
<br>

| SNSで結果を共有 |
| :---: |
| [![Image from Gyazo](https://i.gyazo.com/e609c0546c6d3136c873f051abd78575.png)](https://gyazo.com/e609c0546c6d3136c873f051abd78575) |
| <p align="left">スコア結果はX(旧Twitter)に共有できます！</p> |

# 使用技術
| カテゴリ | 技術内容 |
| --- | --- |
| サーバサイド | Ruby on Rails 7.2.2 / Ruby 3.3.6|
| フロントエンド | Ruby on Rails / JavaScript |
| CSSフレームワーク | Tailwindcss + daisyUI |
| Web API | Express / GeminiAPI |
| データベースサーバ | Render.com(PostgreSQL) |
| アプリケーションサーバ | Render.com |
| バージョン管理ツール | GitHub |
<br>

# 画面遷移図
[Figma](https://www.figma.com/design/vyfELEbCh4mGzufeNAEG8P/%E7%94%BB%E9%9D%A2%E9%81%B7%E7%A7%BB%E5%9B%B3?node-id=0-1&t=feQaIUnSu9qImhG0-1)
<br>

# ER図
[![Image from Gyazo](https://i.gyazo.com/0060c7548d92a7fdf168868807496885.png)](https://gyazo.com/0060c7548d92a7fdf168868807496885)