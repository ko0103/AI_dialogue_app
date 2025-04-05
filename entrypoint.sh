#!/bin/bash
# デモデータの挿入
bundle exec rails db:seed
# bundle exec rails db:migrate
# PATH環境変数の確認
echo $PATH

# Railsサーバーをバックグラウンドで起動
bundle exec rails server &

# Node.jsサーバーを起動
node gemini.mjs