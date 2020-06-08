## What is this?

- flashair SDカードから写真画像をGoogle Driveにコピーします
- Google Driveには撮影日ごとディレクトリを作成します

## 準備

### flashair

- flashairはステーションモードにする必要があります
  https://flashair-developers.github.io/website/docs/tutorials/advanced/1.html


### Google Drive API

- GCPのコンソールからGoogle DriveのAPIを有効化
- 「APIとサービス」から「OAuth クライアントID」を作成
  - 「アプリケーションの種類」は「テレビと入力が限られたデバイス」を選択
- 認証ファイルをダウンロード
- 環境変数「CREDENTIAL_DIR」に設定したディレクトリに保存

### 環境変数の設定

- CREDENTIAL_DIR
  - Google APIの認証ファイルを設置するディレクトリ
- CREDENTIAL_SECRET_FILENAME
  - Google APIの認証ファイル名
- GOOGLE_DRIVE_UPLOAD_FOLDER_ID
  - Google Driveのアップロード先フォルダーID
  - フォルダーのURLの末尾がIDとなる
    - https://drive.google.com/drive/u/0/folders/STUVWXY1234-stuvwxy7890 であれば「STUVWXY1234-stuvwxy7890」がフォルダーID
- FLASH_AIR_HOSTNAME
  - flashairのホスト名。デフォルトでは「myflashair.local」

### bundle

```ruby
bundle install
```

## 起動

```bash
bin/flashair_daily_copy start
```

初回起動時、APIの認証を求められる


### Todo

- 並列処理
- READMEの英訳

