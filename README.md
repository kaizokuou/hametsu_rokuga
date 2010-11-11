# What's That?
教えてあげない

# どうやって使うの
Rails3 とかをインストール。 rvm とかで環境わけよう。
MySQL にデータベース作って以下のような感じでテーブルを作る

    CREATE TABLE `entities` (
      `entity_group_entity_id` VARCHAR(250) NOT NULL PRIMARY KEY,
      `body` MEDIUMBLOB,
      `created_at` datetime NOT NULL,
      `updated_at` datetime NOT NULL
    ) ENGINE=InnoDB;

    CREATE TABLE `indices` (
      `index_id` INT NOT NULL,
      `entity_id` VARCHAR(200) NOT NULL,
      `sort` INT NOT NULL,
      PRIMARY KEY  (`index_id`,`entity_id`),
      INDEX (`index_id`, `sort`)
    ) ENGINE=InnoDB;

そして database.yml を編集

Toshokan.runner がいろいろ拾ってくる例のアレなので、定期的に実行 ./script/rails runner とかで。

Torrent.runner が落すやつなのでデーモン化するか screen の中で起動。

Web サーバーを unicorn とかで起動しておく。 

ソースを読んで気合でユーザーを作成する。(この辺り後で直す)

[http://hogehoge/settings](http://hogehoge/settings) の中身を埋める。

[http://hogehoge/home/force_all](http://hogehoge/home/force_all) がダウンロードを開始する為の URL なので、これを wget とかで定期的に叩く。

一覧を手動でクリックするなり定期購読するなりすると落ちてくる。定期購読は正規表現で入れてね。

transmissioncli はたまに腐るので

    #!/usr/bin/env ruby
    dir = "download ディレクトリ"
    config = "~/.config/transmissioncli/torrents"
    flag = false
    Dir.entries(dir).each do |f|
      next if File.ftype("#{dir}#{f}") != "file"#f == "." or f == ".." or f == "windows"
      Dir.entries(config).each do |t|
        flag = true if t =~ /#{f.gsub(/\ /, "\\ ").gsub(/\[/, "\\[").gsub(/\]/, "\\]").gsub(/\(/, "\\(").gsub(/\)/, "\\)")}/
      end
    end
    `killall transmissioncli` if flag

みたいの cron で回して潰す。

使えるようになるまで非常にダルいので、使いたい人は僕に直接聞きにくるといいです。
