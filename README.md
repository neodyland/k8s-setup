# k8s-setup
Kubernetes setup ansible script for neodyland.

## フォーク元との比較

## 環境のセットアップ
```sh
uv venv
uv sync
```

基本的にUbuntuでしかテストしていません。

## メインのセットアップ
利用する前に
```
source .venv/bin/activate
```
を実行すること。

### 1. inventory/hostsを編集
ここには設定対象のワーカー、マスターそしてロードバランサーが設置されています。
適時設定してください。

### 2. inventory/group_vars/all/network.ymlを編集
マスターIP、要するにk8sのapiを受信するIPを書いてください。

### 3. inventory/group_vars/all/version.ymlを編集
k8sのバージョンをここで指定してください。

### 4. 実行
```
ansible-playbook -i inventory full.yml
```
これで自動的にセットアップしてくれます。
