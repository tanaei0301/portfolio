# portfolio

概要

音声認識アプリです。プログラミングの練習で作りました。
授業等の録音、文字起こしができ、後から見返すことができます。また耳が不自由な人は、リアルタイムで認識結果を表示できるようにしているので、先生の話している内容を理解しやすくなります。


使用しているAPIはApple Speech-To-Textです。
認識に関しては、日本語を始め、英語や中国語など、主要な言語に対応しています。
認識は、デフォルトではリアルタイム認識を行います。
設定でURLリクエストをオンにすることでリアルタイム音声認識時に録音したデータを使って、音声認識ができます。（リアルタイムの認識よりも精度が向上しますが、結果が返ってくるまで時間がかかります。）
設定項目はJSON形式で保持されます。
データの保存はDocumetディレクトリに一つの収録ごとにユーザーが決めた名前のディレクトリを作り、そのディレクトリに、認識結果はtxtファイルで、音声はm4a形式で保存します。
データの一覧表示では、Documentディレクトリに保存されているデータをリスト形式で取得し、不要なファイルを取り除いた上で、保存された順に並び替えて表示しています。

工夫点

収録ボタンを見慣れたものにする等、直感的な操作感が得られるように工夫している。
保存時や閲覧時に、認識結果を改変できるようにし、誤った認識結果や、句読点などの修正をユーザーが行えるようにしている。
各収録ごとにサムネイルを設定できるようにすることで、一覧表示したときに、どの収録か理解しやすくしている。（サムネイルはいつでも変更することが可能。）
一覧表示時に、ファイルの保存時間を表示することで、どの収録か理解しやすくしている。
認識結果の保存に万が一失敗した際は、作成したディレクトリごと消去し、中途半端にデータが保存さることのないようにしている。
ファイル名が被って勝手に上書きされないよう、ファイル名をチェックする仕組みを作っている。

修正点

一覧表示時にもデータの消去が可能なようにする
認識結果の保存方法を、容量をなるべく圧迫しないJSONや、バイナリーなどで保存するように変更する
ユーザー辞書の設定を追加する
viewController内に音声認識のコードを書いているのでclassを分ける
UIのデザインを綺麗にする
