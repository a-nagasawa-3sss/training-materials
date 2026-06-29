## 【Step 1：JavaScriptのみで簡単なToDoリスト実装】
### **1. プロジェクト初期セットアップ**

- **問題:**  
    基本的な開発環境とファイル構成を実装してください
    
- **詳細:**
    
    1. **プロジェクトフォルダの作成:**
        
        - 新規フォルダ（例：`todo-app`）を作成する。
            
    2. **基本ファイルの作成:**
        
        - フォルダ内に以下の3ファイルを作成する。
            
            - `index.html`
                
            - `styles.css`
                
            - `app.js`

    3. **index.htmlの基本構造記述:**
        - index.htmlに以下のサンプルコードを記載する。
        **サンプルコード**:
        
        ```html
        <!DOCTYPE html>
        <html lang="ja">
          <head>
            <meta charset="UTF-8">
            <title>ToDoリストアプリ</title>
            <link rel="stylesheet" href="styles.css">
          </head>
          <body>
            <!-- ヘッダー -->
            <header>
              <h1>ToDoリストアプリ</h1>
            </header>
        
            <!-- タスク追加セクション -->
            <section class="task-add">
            </section>
        
            <!-- タスクリスト表示セクション -->
            
            <!-- タスク情報表示セクション -->
            
		  </body>
        </html>
        ```
        
    4. **JavaScriptファイルのリンク:**
        
        -  `<body>` タグの末尾に `app.js` を読み込むスクリプトタグを配置します（`<script src="app.js"></script>`）。
                        
- **目的:**
    
    - 開発環境の基盤を整え、今後の各ステップの拡張のための土台を作る。
        
    - HTML、CSS、JavaScriptの基本ファイル構成、ファイル間のリンク設定、セマンティックなマークアップの重要性を理解する。
        
- **注意点:**
    
    - **ファイルパス:** CSSとJavaScriptの読み込みパスが正しく設定され、404エラーが発生しないこと。
        
    - **セマンティックな記述:** `<header>`, `<section>`, `<ul>` など適切なタグを使用すること。
                
- **ヒント:**
    
    - 作成後、ブラウザで `index.html` を直接開き、各セクションが正しく表示されるかチェックする。
        
    - StackBlitzで演習を開始する場合は、Vanilla JavaScriptでプロジェクトを開始する。


---


### **2. HTML/CSSによる基本UIの構築**

- **問題:** 基本的なUIレイアウト（ヘッダー、タスク追加セクション、タスクリスト表示セクション、タスク情報表示セクション）を実装してください。
    
- **詳細:** 以下の4つのセクションをHTML内に明確に区切り、それぞれ実装します。

1. **ヘッダーの実装:**
    
    - `<header>`タグを使用し、アプリのタイトル「ToDoリストアプリ」を表示。
        
    - 背景色、フォントサイズ、パディングなどをCSSで設定し、視覚的に分かりやすくする。
        
2. **タスク追加セクションの構築:**
    
    - `<section class="task-add">`を作成し、その中に以下を配置する。
        
        - タスク入力欄（例：`<input type="text" id="task-input" placeholder="タスクを入力してください" maxlength="50">`）
            
        - タスク追加用ボタン（例：`<button id="add-btn">追加</button>`）
            
        - エラーメッセージ表示用の要素（例：`<p id="error-msg" class="error-msg"></p>`）
            
3. **タスクリスト表示セクションの構築:**
    
    - `<section class="task-list">`を作成し、その中にタスク表示用のリストを配置する。
        
        - タスク表示用の空リスト（例：`<ul id="task-list"></ul>`）
            
4. **タスク情報表示セクションの構築:**
    
    - `<section class="task-info">`を作成し、タスク数の情報を表示するエリアを作る。
        
        - 例：`<p id="task-info">未完了のタスク：0 / 総タスク：0</p>`
            
5. **基本スタイルの設定:**
    
    - 各セクションの背景色、フォント、パディング、マージンなど基本スタイルを`styles.css`に記述する。
        
    - ページ全体の中央寄せや最大幅、背景色やフォントの統一を行う。
        
6. **コメントの記載:**
    
    - HTMLの各セクションに適切なコメントを追加し、後の機能拡張の際に修正箇所が明確になるようにする。
        

- **目的:**
    
    - 直感的に操作できるシンプルなUIを構築する。
        
    - HTMLとCSSの基本的な記述方法およびセマンティックなタグの使用法を理解する。
        
    - React移行時に各セクションをコンポーネントとして再利用しやすい構造を整える。
        
- **注意点:**
    
    - 各セクションを明確に分割し、適切なセマンティックタグと一貫性のある命名規則を使用する。
        
- **ヒント:**
    以下は、**ヘッダーのCSS**に関する記載例です。最終的なデザインはお好みで調整してみてください。
#### CSS記載例
```css
/* 全体の基本スタイル */
body {
  font-family: Arial, sans-serif;
  background-color: #f8f9fa;
  color: #333;
  max-width: 600px;
  margin: 0 auto;
  padding: 20px;
}

/* ヘッダーのスタイル */
header {
  background-color: #007bff;
  color: #fff;
  padding: 20px;
  text-align: center;
  border-radius: 4px;
  margin-bottom: 20px;
}

/* タスク追加セクション */
.task-add {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 20px;
}

.task-add input[type='text'] {
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 4px;
  flex: 1;
  transition: border-color 0.3s ease, box-shadow 0.3s ease;
}

.task-add input[type='text']:focus {
  border-color: #80bdff;
  box-shadow: 0 0 8px rgba(0, 123, 255, 0.3);
  outline: none;
}

.task-add button {
  padding: 8px 16px;
  background-color: #28a745;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.task-add button:hover {
  background-color: #218838;
}

.error-msg {
  color: red;
  font-size: 14px;
  margin-top: 4px;
  display: block;
  visibility: visible;
  opacity: 1;
}

.error-msg.active {
  visibility: visible;
  opacity: 1;
}

/* タスクリスト表示セクション */
.task-list ul {
  list-style: none;
  padding: 0;
  margin-top: 10px;
}

.task-list li {
  padding: 10px;
  background-color: #fff;
  border-radius: 4px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

/* タスク情報表示セクション */
.task-info {
  text-align: center;
  font-size: 14px;
  color: #666;
  margin-top: 12px;
}

```
![2.png](https://image.docbase.io/uploads/d111f197-407f-4b07-8a61-225d65a671a3.png =WxH)

---


### **3. JavaScriptでのタスク追加機能の実装**

- **問題:**  
    タスク追加処理を `app.js` に実装してください。
    
- **詳細:**  
    以下の手順に従って実装を進めてください。各ステップの**空欄（コメントアウト部分）を埋めて**動作を完成させてください。
    

---

1. DOM要素の取得**

以下の要素をJavaScriptで取得し、それぞれの変数に代入します。

- タスク入力欄 (`id="task-input"`)
    
- 追加ボタン (`id="add-btn"`)
    
- タスクリスト (`id="task-list"`)
    

```javascript
const taskInput = document.getElementById('task-input');
// const addBtn = （追加ボタンを取得して代入）;
// const taskList = （タスクリストを取得して代入）;
```

---

2. タスク追加関数の作成**

以下のようなタスク追加関数を作成してください。

- 関数名は `addTask` とします。
    
- 引数として、タスクのテキストを受け取ります。
    
- 新しく `<li>` 要素を生成し、さらにタスクテキスト用の `<span>` を生成します。
    
- 最後に作成した要素をタスクリストに追加します。
    
```javascript
function addTask(text) {
    // 新しい li 要素を作成
    // const li = （li要素を生成）;

    // 新しい span 要素を作成し、タスクのテキストを設定
    // const taskSpan = （span要素を生成）;
    // taskSpanのtextContentに引数textを設定

    // 作成した span 要素を li 要素に追加
    // （span要素をli要素の子として追加）

    // 作成した li 要素をタスクリストに追加
    // （li要素をタスクリストに追加）
}
```

---

3. クリックイベントの設定**

以下の仕様で、追加ボタンがクリックされたときの処理を実装してください。

- タスク入力欄から入力値を取得し、前後の空白を取り除く。
    
- 入力値を引数に、上記で作成した `addTask` 関数を呼び出す。
    
- タスク入力欄の値を空にし、再度フォーカスを設定する。
    

```javascript
// addBtn にクリックイベントを設定
addBtn.addEventListener('click', function() {
//     入力欄の値を取得し、前後の空白を取り除く処理trimを記載
//     addTask関数を呼び出し（引数に入力欄の値を渡す）
//     入力欄をクリアする処理を記載
//     フォーカスを入力欄に再設定
});
```

---

- **目的:**  
    DOM操作とイベントハンドリングの基本を学び、動的なUI更新の実装方法を習得する。
    
- **注意点:**  
    本問題では入力検証（空白の入力チェックなど）は行いません。後の問題で改善します。
    
- **ヒント:**
    
    - MDN Web Docsで`getElementById`、`addEventListener`、`createElement`、`appendChild`を確認しましょう。
        
    - 各ステップごとに動作確認をしながら実装を進めると良いでしょう。
        
![3.png](https://image.docbase.io/uploads/b06229f7-4ad3-435a-a3c9-d6d6550496cf.png =WxH)

---

### **4. タスクの削除機能の実装**

- **問題:**  
    タスク追加関数（`addTask`）内で、各タスクに削除ボタンを追加し、そのボタンをクリックすると該当するタスクが削除される処理を実装してください。
    
- **詳細:**  
    以下の`addTask`関数内のコメント部分を参考に、実際のコードを記述してください。
    

```javascript
function addTask(text) {
  const li = document.createElement('li');

  //問題3の記述

  // ▼ 削除ボタンの作成（ここに記載）
  // - createElementでボタン要素(deleteBtn)を作成
  // - ボタンに表示するテキストを設定（例：「削除」）
  // - ボタンにクラス名（delete-btn）を設定 (classNameを使用)
  // - 作成したボタンをliに追加

  // ▼ 削除ボタンにクリックイベント設定（ここに記載）
  // - 上記で作成した削除ボタンにaddEventListenerを使い、
  // - クリック時に<li>を削除する処理を記載

  taskList.appendChild(li);
}
```

- **スタイル設定（styles.css）:**  
    以下のスタイルをCSSファイルに実装してください。
    
```css
    /* 削除ボタンの基本スタイル */
    .delete-btn {
        background-color: #dc3545;
        color: #fff;
        border: none;
        padding: 4px 8px;
        border-radius: 4px;
        cursor: pointer;
    }
    
    /* 削除ボタンのホバー時のスタイル */
    .delete-btn:hover {
        background-color: #c82333;
    }
```

- **目的:**
    
    - 動的要素の生成と削除方法を実践的に学ぶ
        
    - イベントリスナーの設定とイベントオブジェクトの扱いを理解する
        
- **注意点:**
    
    - 削除ボタンをクリックしたら、該当するタスクの表示（li要素）が消えることを確認してください。
        
    - 動作確認を行い、コンソールにエラーがないか必ず確認してください。
        
- **ヒント:**
    
    - MDN Web Docsで`remove()`を調べてみましょう。

![4.png](https://image.docbase.io/uploads/45d18caf-2d89-4183-9531-914ec57818f6.png =WxH)

---

### **5. タスクの完了/未完了切替機能の実装**

- **問題:**  
    タスクの「完了」「未完了」を切り替える機能を実装してください。
    
- **詳細:**  
    タスクを追加するとき（`addTask`関数内）に、以下のコメントを参考にコードを完成させてください。
    

```javascript
function addTask(text) {
  const li = document.createElement('li');

  // タスク追加処理

  // - createElementでボタン要素(toggleBtn)を作成
  // - ボタンに表示するテキストを設定（例：「完了」）
  // - ボタンにクラス名（toggle-btn）を設定 (classNameを使用)
  // - 作成したボタンをliに追加

  // ▼ 完了ボタンのクリックイベントを設定（ここを記載）
  /*
    toggleBtnのクリックイベント内で以下の処理を実装：
      1. taskSpanに対し、「completed」というクラスの追加・削除を切り替える
         （ヒント：classList.toggleを使用）
      2. 現在の状態（「completed」クラスが付いているか）を確認し、
         ボタンのテキストを「完了」または「未完了に戻す」に切り替える
         （ヒント：classList.containsを使用）
  */


  // 削除ボタン処理

  taskList.appendChild(li);
}
```

- **スタイル設定（styles.css）:**  
    以下のスタイルをCSSファイルに実装してください。
    

```css
/* 完了ボタンを左側に寄せる場合は、task-listも修正 */
.task-list li {
  padding: 10px;
  background-color: #fff;
  border-radius: 4px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  display: flex;
  align-items: center;
  margin-bottom: 8px;
}

/* タスク名を左に固定、最大幅を占める */
.task-list li span {
  flex-grow: 1;
}

/* 完了ボタンを右側（削除ボタンの左隣）に配置 */
.task-list li .toggle-btn {
  order: 1;
  margin: 4px;
}

/* 削除ボタンを一番右に配置 */
.task-list li .delete-btn {
  order: 2;
  margin: 4px;
}


/* タスクが完了状態になったときのスタイル */
.completed {
  text-decoration: line-through;
  color: #999;
}

/* 完了切替ボタンの基本スタイル（ティール系） */
.toggle-btn {
  background-color: #17a2b8; /* 明るい青緑色（ティール） */
  color: #fff;
  border: none;
  padding: 4px 8px;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

/* 完了切替ボタンのホバー時のスタイル */
.toggle-btn:hover {
  background-color: #138496; /* ホバー時に濃くなる青緑 */
}
```

- **目的:**
    
    - UIの状態変化とそれに伴うスタイルの動的変更を理解する
        
    - イベントによるクラスの切替 (`classList.toggle`) の実践的な使用方法を学ぶ
        
- **注意点:**
    
    - タスク完了状態が切り替わった際、ボタンのテキスト（完了/未完了）やタスク名のスタイルが正しく変化することを確認してください。
        
    - エラーがコンソールに出ていないか必ず確認しましょう。
        
- **ヒント:**
    
    - MDN Web Docsで `classList.toggle()` と `classList.contains()` の使用例を調べてみましょう。

![5.png](https://image.docbase.io/uploads/bc69e572-d312-49b0-8125-486c2329a4d4.png =WxH)

---

### **6. 入力値のバリデーション（空白チェック）の実装**

- **問題:**  
    タスクの入力値の検証処理（空白チェック）を実装してください。ユーザーが空白のみを入力した場合にタスクの追加を防ぎ、エラーメッセージを表示してください。
    
- **詳細:**
         
1. **検証関数の作成:**
    
    - 入力値が空白または空文字の場合にエラーを表示する関数を作成します。
        
    - この関数は検証結果を `true` / `false` で返すようにします。
        
    
    **記載箇所と例:**
    
    ```javascript
    function validateInput(inputValue) {
        // 入力値が空文字かどうかをチェック
        // 空文字の場合はエラーメッセージを表示し、falseを返す
        // 正常な値の場合はエラーメッセージをクリアし、trueを返す
    }
    ```
    
2. **タスク追加時の検証処理:**
    
    - タスク追加イベント内で、`validateInput` 関数を呼び出して検証します。
        
    - 検証が失敗した場合は、タスク追加処理を中止します。
        
    
    **記載箇所と例:**
    
    ```javascript
    addBtn.addEventListener('click', function() {
        const taskText = taskInput.value.trim();
    
        // ▼ここに入力値の検証処理を記載
        // validateInput関数を呼び出し、falseなら処理を中止
        // trueならタスク追加処理を実行
    });
    ```
    
3. **エラーメッセージ表示のスタイル設定（CSS）:**
    
    - エラーメッセージ表示用要素のスタイル（色、余白、表示位置など）を定義します。
        
    
    **例:**
    
    ```css
    #error-msg {
        color: red;
        margin-top: 4px;
        font-size: 14px;
    }
    ```
    

- **目的:**
    
    - ユーザー入力の検証方法と、ユーザーへのエラーフィードバック表示方法を学ぶ。
        
- **注意点:**
    
    - 入力値の前後の空白除去が正しく行われ、エラーメッセージの表示と解除が適切に動作することを確認してください。
        
- **ヒント:**
    
    - MDNの `String.prototype.trim()` を確認してください。

![6.png](https://image.docbase.io/uploads/3f2c6268-789b-4b88-accd-00dafd8c67db.png =WxH)

---

### **7. 重複タスクの検知機能の実装**

- **問題:**  
    重複タスク検知の処理を実装してください。  
    すでに存在するタスクと同じ内容が入力された場合、それを追加しないように制御し、エラーメッセージを表示してください。
    
- **詳細:**
    

1. **重複チェック関数の作成:**  
    重複タスクを検知する独立した関数を作成します。  
    この関数は、既存のタスクを取得して新規タスクと比較し、重複がある場合に`true`を返します。
    
    **記載箇所とヒント:**
    
    ```javascript
    function isDuplicate(newTask) {
      const tasks = Array.from(taskList.getElementsByTagName('li'));
    
      // 以下のような内容を実装してください：
      // 1. 各<li>内のタスク名を取得（例：<span class="task-name">）
      // 2. タスク名が存在しない場合はfalseを返す
      // 3. 新規タスクと既存タスクを大文字・小文字を区別せずに比較
      // 4. 比較の結果、一致するものがあればtrueを返す
    }
    ```
    
2. **validateInput関数でエラー表示を統一:**  
    現在ある`validateInput`関数を修正して、空白入力時のエラーに加えて、  
    重複時のエラーもここで処理して表示するようにします。  
    これによりエラー処理を一か所で集中管理できます。
    
    **記載箇所とヒント:**
    
    ```javascript
    function validateInput(inputValue) {
      const errorMsg = document.getElementById('error-msg');
    
      // 空白チェック（問題6で作成済み）
    
      // 重複チェック（isDuplicate関数をここで呼び出す）
      // 重複している場合は、「同じタスクが既に存在します」などのエラーメッセージを表示し、falseを返却
    
      // 問題がない場合はエラーメッセージを空にし、trueを返却
    }
    ``` 

- **目的:**  
    重複を防ぐことでデータの整合性を保ち、  
    ユーザーが正しくタスクを管理できるようにする方法を学ぶ。  
    また、エラー表示処理を一か所に集約することでコードの保守性を高める。
    
- **注意点:**
    
    - 入力値を比較する際、大文字・小文字を無視するように処理を統一してください。
        
    - 重複時には明確にユーザーに通知を行い、不要な処理が進まないようにしてください。
        
- **ヒント:**
    
    - MDNの`Array.prototype.some()`の使用例を確認してください。
        
    - エラー処理を`validateInput`にまとめると、今後の拡張性やコードのメンテナンス性が向上します。

![7.png](https://image.docbase.io/uploads/e1b6d8eb-cfb3-49aa-93cc-3329c7031216.png =WxH)

---

### **8. タスク情報フィードバック表示機能の実装**

- **問題:**  
    タスク情報（総タスク数、未完了タスク数）のフィードバック処理を実装してください。
    
- **詳細:**
    

1. **タスク数計算の実装:**
    
    - タスクリスト内の全`<li>`要素の数を総タスク数として計算します。
        
    - タスクリスト内で`completed`クラスが付与されていないタスクの数を未完了タスク数として計算します。
        
    
    **記載箇所とヒント:**
    
    ```javascript
    function updateTaskInfo() {
      const tasks = taskList.getElementsByTagName('li');
    
      // 総タスク数を計算（tasksの配列の長さを利用）
      const total = tasks.length;
    
      // 未完了タスクの数を計算
      // 未完了タスクはcompletedクラスが付いていないli要素の数です。
      const incomplete = Array.from(tasks).filter((li) => {
        // li要素内のタスク名部分のspan要素を取得
        const taskNameSpan = li.querySelector('.task-name');
        // taskNameSpanにcompletedクラスが付いているか確認
        // completedクラスが付いていなければtrueを返す
      }).length;
    
      // 計算した数値を情報表示エリアに反映
      taskInfo.textContent = `未完了のタスク：${incomplete} / 総タスク：${total}`;
    }
    ```
    
2. **動的なUI更新処理の実装:**
    
    - 各タスク操作（追加、削除、完了/未完了切替）後に、統計情報を更新する関数`updateTaskInfo()`を呼び出す処理を追加してください。
        

- **目的:**
    
    - 状態の集計とリアルタイム更新を実装し、動的なユーザーインターフェースの構築方法を学ぶ。
        
- **注意点:**
    
    - タスク情報の更新が各操作後（追加、削除、完了/未完了切替）に必ず実行されるようにしてください。
        
- **ヒント:**
    
    - MDNの`Array.prototype.filter()`および配列の`length`プロパティの使い方を確認してください。

![8.png](https://image.docbase.io/uploads/853e8471-0763-4a17-8dcb-72f015dc8a6b.png =WxH)

---

### **9. レスポンシブデザインの適用**

- **問題:**  
    異なる画面サイズに対応するレスポンシブデザインを実装してください。
    
- **詳細:**
    

1. **メディアクエリの追加:**
    
    - `styles.css`にメディアクエリを記述し、画面サイズ別（例：スマートフォン、タブレット、PC）のスタイルを定義してください。
        
    
    **記載例:**
    
    ```css
    /* スマートフォン向け（画面幅 600px 以下） */
    @media (max-width: 600px) {
      /* ここにスマートフォン向けのスタイルを記述 */
    }
    
    /* タブレット向け（画面幅 601px ～ 1024px） */
    @media (min-width: 601px) and (max-width: 1024px) {
      /* ここにタブレット向けのスタイルを記述 */
    }
    
    /* PC向け（画面幅 1025px 以上） */
    @media (min-width: 1025px) {
      /* ここにPC向けのスタイルを記述 */
    }
    ```
    
2. **具体的なレイアウト調整:**
    
    - 各デバイスの画面サイズに応じて、ヘッダー・タスク追加セクション・タスクリストの幅、フォントサイズ、パディング、マージンなどを調整します。
        
    - 特にスマートフォンでは表示が崩れやすいため、縦並びに変更するなど工夫をしてください。
        
    
    **調整のヒント:**
    
    ```css
    /* 例：スマートフォンでタスク追加セクションを縦並びにする場合 */
    @media (max-width: 600px) {
      .task-add {
        flex-direction: column;
        align-items: stretch;
      }
      .task-add button, .task-add input {
        width: 100%;
        margin-bottom: 8px;
      }
    }
    ```
    
3. **動作確認と微調整:**
    
    - 実際のデバイスやブラウザのレスポンシブモード（開発者ツール）を使用して、表示確認と調整を繰り返し行いましょう。
        

- **目的:**
    
    - レスポンシブデザインの基本を理解し、異なる画面サイズでも使いやすく見やすいUIを提供できるようにする。
        
- **注意点:**
    
    - 特に小さな画面（スマートフォン）でレイアウトが崩れやすいので、十分な確認を行い、読みやすさと使いやすさを意識して調整してください。
        
- **ヒント:**
    
    - ブラウザの開発者ツールにあるレスポンシブモードを活用すると効率的に確認が行えます。

![9.png](https://image.docbase.io/uploads/49b3ee50-ddd8-4490-b717-76486cad0917.png =WxH)

---

<div style="page-break-before:always"></div>

## 【Step 2：JavaScriptをReactに書き換え】
### **10. Reactプロジェクトの最小環境セットアップ**

- **問題:**  
    Reactアプリを最小限の構成で起動できる環境を作成し、Appコンポーネントを実装してください
    
- **詳細:**
    
    1. **パッケージの導入:**
        
        - npm（またはyarn）を利用して `react`, `react-dom` をインストールする。
            
        - 例: `npm install react react-dom`
            
    2. **実装内容:**
        
        - `index.html`: HTMLテンプレートに `<div id="root"></div>` を用意。index.jsxを参照するように記載。
            
        - `src/index.jsx`: `ReactDOM.createRoot(...)` で `<App />` をマウント。`<React.StrictMode>`でAppをラップする。
            
        - `src/App.jsx`: 親コンポーネントを作成（この段階では最小限でOK）。
            
            
    3. **index.jsx でのマウント（StrictMode使用）:**
        
        - Reactの推奨設定に従い、StrictModeを使用してAppコンポーネントをマウントする。
            
        - 例:
            
            ```jsx
            // src/index.jsx
            import React from 'react';
            import ReactDOM from 'react-dom/client';
            import App from './App';
            
            const rootElement = document.getElementById('root');
            const root = ReactDOM.createRoot(rootElement);
            root.render(
              <React.StrictMode>
                <App />
              </React.StrictMode>
            );
            ```
    4. **App.jsx の実装:**
        
        - JSXで「ToDoリストアプリ」というタイトルのみを表示する。まだタスク機能の本体は不要。
            
        - 例:
            
            ```jsx
            // src/App.jsx
			import React from 'react';
			
			function App() {
			  return (
			    <div>
			      <header>
			        <h1>ToDoリストアプリ</h1>
			      </header>      
			      {/* 後の課題でコンポーネント等を追加 */}
			    </div>
			  );
			}
			
			export default App;
            ```

		
- **目的:**
    
    - Reactの基本的な構成を理解し、**最小限のToDoアプリの土台**（Appコンポーネント）を表示する。
        
- **注意点:**
        
    - `react` と `react-dom` を忘れずにインストールしないと「Failed to resolve import 'react'」などのエラーが出る。
        
- **ヒント:**
    
    - この時点ではタスク追加ロジックは入れず、起動と画面表示のみ確認。

![10.png](https://image.docbase.io/uploads/09816db2-eb3c-4192-b04f-b071095ef34c.png =WxH)

--- 
### **11. TaskAddコンポーネントの作成**

- **問題:**  
    ToDoリストアプリでタスクを追加できるよう、TaskAddコンポーネントを実装してください
    
- **詳細:**
    
    1. **TaskAdd.jsx の作成:**
        
        - `src/components/TaskAdd.jsx` に、入力欄＋追加ボタンを持つ関数コンポーネントを作る。
            
        - `useState` で入力値を管理し、ボタンを押したら親コンポーネントから受け取る `onAddTask` コールバックを呼び出す。
            
    2. **App.jsx での連携:**
        
        - Appに `useState([])` を追加し、タスク一覧を管理。
            
        - `<TaskAdd onAddTask={handleAddTask} />` のように呼び出し、`handleAddTask` 内で `setTasks([...tasks, newTask])`。
            
            
- **目的:**
    
    - Reactのフォーム操作（`useState`）と**親子間のデータ連携**を使い、実際にタスクを追加できる流れを実装する。
        
- **注意点:**
    
    - **ファイルパス**: `TaskAdd` は `./components/TaskAdd.jsx` からimport。
        
    - **依存**: この問題を解く前にReact環境 + App.jsx が動いているのが前提。
        
- **ヒント:**
    
    - フロー: `TaskAdd`のinput → ボタン押下 → `onAddTask(inputValue)` → 親が`tasks`に追加 → 自動再描画
	```jsx
	// src/components/TaskAdd.jsx
	import React, { useState } from 'react';
	
	const TaskAdd = ({ onAddTask }) => {
	  // inputValueなどの状態変数で、useStateを定義
	
	  const handleSubmit = (e) => {
		// preventDefault()を使って、ページリロード防止
		// 空のタスク入力防止（任意）
	    // onAddTaskを呼び出す記載など
	    // 入力欄のリセット（任意）
	  };
	
	  return (
	    <section className="task-add">
	      <form onSubmit={handleSubmit}>
	      {/* 入力欄＋追加ボタンの記述 */}
	      </form>
	    </section>
	  );
	};
	
	export default TaskAdd;
	
	```
        
    - 公式ドキュメント「[Lifting State Up](https://react.dev/learn/sharing-state-between-components)」を参照すると、親がステートを管理し、子がイベントを通知する構造がさらに理解できる。
	    
    - この時点ではバリデーションチェックなどの追加機能は実装しなくてよい。
    
![11.png](https://image.docbase.io/uploads/8cb7cc72-db03-4c28-a370-92f98026b3aa.png =WxH)

--- 
### **12. TaskListコンポーネントの作成**

- **問題:**  
    タスク一覧表示用コンポーネント（TaskList）を実装し、各タスクに削除ボタンと完了/未完了切替ボタンを追加してください。
    
- **詳細:**
    

1. **コンポーネントの設計:**
    
    - `src/components/TaskList.jsx` にTaskListコンポーネントを作成する。
        
    - 親から渡されたタスクデータの配列を `props.tasks` として受け取り、リスト表示を行う。
        
    - タスクを削除するための関数 `props.onDeleteTask` と、タスクの完了状態を切り替える関数 `props.onToggleTask` を親コンポーネントから受け取る。
        
2. **リスト表示の実装:**
    
    - `map`関数を用いて各タスクを`<li>`として動的に生成し、一意の`key`属性を設定する（例: `task.id`）。
        
    - タスクが完了状態の場合、タスクのテキストに取り消し線や「(完了)」の表記を付与するなどの工夫をする。
        
    - 各タスク項目の横に、削除ボタンと完了/未完了切替ボタンを追加する。
            
3. **UIの連携と更新:**
    
    - 親コンポーネントの状態（`tasks`）が更新されると、自動的に再レンダリングされ、最新のタスク一覧が表示される。
        
    - 親コンポーネント（例: `App.jsx`）側で状態管理とコールバック関数を実装し、以下のように`TaskList`を呼び出すこと。
        
    
    ```jsx
    <TaskList
      tasks={tasks}
      onDeleteTask={handleDeleteTask}
      onToggleTask={handleToggleTask}
    />
    ```
    
    - 親コンポーネントでは、タスクを削除する関数 `handleDeleteTask` とタスクの完了状態を切り替える関数 `handleToggleTask` をそれぞれ実装すること。
        

- **目的:**
    
    - propsを利用したデータ受け渡しと、動的なリスト生成を学ぶ。
        
    - 削除や完了状態の切替など、子コンポーネントから親コンポーネントにイベントを通知する方法を学ぶ。
        
    - Reactの「親が状態を管理し、子がUIを表示する」という単方向データフローを実践的に理解する。
	    
	- map関数やfilter関数の記載の仕方を学ぶ。
        
- **注意点:**
    
    - 必ず各リスト項目には`key`属性を設定し、重複しない値を指定すること。
        
    - コールバック関数をpropsとして渡す際、アロー関数を利用して引数を渡す方法を理解すること。
        
- **ヒント:**
    
    - React公式ドキュメントの「[Lists and Keys](https://legacy.reactjs.org/docs/lists-and-keys.html)」を参考にする。
        
    - 親側で`handleDeleteTask`ではfilter関数を、`handleToggleTask`ではmap関数を使用すると良い。

![12.png](https://image.docbase.io/uploads/ab31b27d-dbea-464a-b42b-1f03976b90cd.png =WxH)

---

### **13. TaskInfoコンポーネントの作成**

- **問題:**  
    タスク情報（未完了のタスク数/総タスク数）を表示するTaskInfoコンポーネントを実装してください
    
- **詳細:**
    
    1. **コンポーネントの設計:**
        
        - `src/components/TaskInfo.jsx` を作成し、**親から `incomplete`（未完了のタスク数）と `total`（総タスク数）をprops**として受け取る。
            
        - 子は単に表示のみ行う（「プレゼンテーショナルコンポーネント」）。計算やロジックは親が担当。
            
    2. **UIの実装:**
        
        - `<div>` で、`incomplete` と `total` を表示するだけに留める。
            
    3. **リアルタイム更新の確認:**
        
        - 親コンポーネント（App.jsx）で `tasks` が追加/削除されると再レンダリングが発生し、TaskInfoも自動的に更新される機能を実装する（totalTasksとincompleteTasksを定義する）。
            
- **目的:**
    
    - **データ表示専用コンポーネント**の実装と、親からのprops受け渡しを理解する。
        
    - 「親で計算、子は表示」の設計パターンを体験する。
        
- **注意点:**
    
    - 「子で計算したい」というケースもあり得るが、ここでは**親がまとめて計算**して子に数値を渡す方針とする。
        
- **ヒント:**
            
    - JSXで `{incomplete}`と`{total}` を表示するだけなら、10行程度のシンプルなコンポーネントとなる。

![13.png](https://image.docbase.io/uploads/05af690a-eb0b-45df-8152-29fabb9a303f.png =WxH)

---

<div style="page-break-before:always"></div>

## 【Step 3：Redux-Reactの統合】

### **14. Redux Toolkitの導入とストアの作成**

- **問題:**  
    Redux Toolkitをプロジェクトに導入し、基本的なReduxストアを作成してください。  

- **詳細:**
    

以下の手順を参考に、Redux Toolkitを用いた状態管理の基盤を作成してください。

1. **Redux Toolkitのインストール:**
    

プロジェクトにRedux Toolkitをインストールしてください。

```bash
npm install @reduxjs/toolkit
```

2. **Reduxストアの設定:**
    
- `src/store/store.js`を作成し、Redux Toolkit公式ドキュメントの「[Quick Start](https://redux-toolkit.js.org/tutorials/quick-start)」を参考にして、以下の内容を含む基本的なストアの設定を記述してください。
    
    - Redux Toolkitの`configureStore()`をインポートして使用する。
        
    - リデューサーは`todos`という名前で`taskReducer`という仮のリデューサーを設定する（具体的な内容は次の問題で作成します）。
        
    - 作成したストアをexportし、他のファイルから利用できるようにする。
        
- この問題ではリデューサーの具体的な実装は不要です。リデューサーについては次の問題で追加します。
    
- **目的:**
    
    - Redux Toolkitの導入方法を理解し、公式ドキュメントを使った情報収集と自己学習のスキルを習得する。
        
- **注意点:**
    
    - リデューサーの具体的な実装は次の問題で行います。ここではストアの基本設定のみ行います。
        
- **ヒント:**
    
    - Redux Toolkit公式ドキュメント（[Getting Started](https://redux-toolkit.js.org/introduction/getting-started)または[Quick Start](https://redux-toolkit.js.org/tutorials/quick-start)）を参照してください。
        
    - シンプルかつ拡張しやすい設計を心がけましょう。

---

### **15. Redux ToolkitのSlice（スライス）の作成**

- **問題:**  
    Redux Toolkitの`createSlice()`を使い、タスク管理用のリデューサー（Slice）を作成してください。
    
- **詳細:**
    

App.jsxで管理していたタスク処理（追加、削除、完了切り替え）をSliceで集中管理するために、以下の内容を含むSliceを作成し、状態管理のロジックを実装してください。

1. **Sliceの作成:**
    

- `src/features/tasksSlice.js`を作成します。
    
- 以下のアクションと機能をSlice内に定義します。
    

| 機能    | アクション      | 説明             |
| ----- | ---------- | -------------- |
| タスク追加 | addTask    | 新しいタスクを追加する    |
| タスク削除 | deleteTask | 指定されたタスクを削除する  |
| 完了切替  | toggleTask | タスクの完了状態を切り替える |

- Redux Toolkit公式ドキュメントの「[Quick Start](https://redux-toolkit.js.org/tutorials/quick-start)」を参考に、以下のテンプレートを用いてSliceを作成してください。
    

```js
// src/features/tasksSlice.js
import { createSlice } from '@reduxjs/toolkit';

const initialState = {
  tasks: [],
};

const tasksSlice = createSlice({
  name: 'tasks',
  initialState,
  reducers: {
    // ▼ タスクを追加する処理（addTask）を記載

    // ▼ 指定したタスクを削除する処理(deleteTask)を記載

    // ▼ 指定したタスクの完了状態を切り替える処理(toggleTask)を記載
  },
});

export const { /* 作成したアクションを記載 */ } = tasksSlice.actions;
export default tasksSlice.reducer;
```

- **目的:**
    
    - Redux Toolkitを用いて実践的な状態管理（アクション、リデューサー）を理解し、具体的なタスク管理機能を実装できるようになる。
        
- **注意点:**
    
    - Redux ToolkitのImmerを活用し、直接的に状態を変更する簡潔な記法で記述してください。
        
- **ヒント:**
    
    - 必要に応じて[Redux Toolkit公式ドキュメント「createSlice」](https://redux-toolkit.js.org/api/createSlice) も参考にしてください。
	    
    - App.jsx内のhandleの処理内容をSliceに置き換えることを意識して実装してください。
        
    - 機能の拡張を見据えてシンプルな実装を心がけましょう。

---

### **16. React-ReduxのProvider設定**

- **問題:**  
    ReduxストアをReact全体に供給するProvider設定を実装してください
    
- **詳細:**
    

1. **react-reduxのインストール:**
    
    - npm（またはyarn）を使い `react-redux` を追加インストールする。
        
2. **Providerの設定 (react-redux):**
    
    - ルートコンポーネント（例：`src/index.jsx` ）で `react-redux` の `<Provider>` をインポートし、ストアを供給する。 （これにより、**Appコンポーネント以下のReactツリー**で `useSelector` や `useDispatch` フックが使えるようになる。）

- **目的:**
    
    - `react-redux` の `<Provider>` とストアを接続し、**Reactコンポーネントツリー**でReduxの状態管理を活用するための基盤を構築する。
        
    - この仕組みを使うと、アプリのどの階層のコンポーネントからでも、`useSelector` / `useDispatch` を介してストアの状態やアクションを扱える。
        
- **注意点:**
    
    - **`react-redux`** をインストールしないと `<Provider>` / `useSelector` / `useDispatch` が使えない。
        
    - すでに Redux Toolkit を使ってストアを作成しているため、そのストアを流用して `<Provider store={store}>` に渡すだけで良い。
        
    - Providerを設定しない状態では `useSelector` や `useDispatch` を呼ぶとエラーになる（「could not find react-redux context value; please ensure the component is wrapped in a Provider」など）。
        
- **ヒント:**
    
    - React-Redux公式ドキュメントの「[Provider](https://react-redux.js.org/api/provider)」セクションを参照することで、index.jsxの記載を理解できる。
        

---

### **17. Redux Hooks の実装**

- **問題:**  
    React-Redux の Hooks（`useSelector`, `useDispatch`）を用いて、**App.jsx** 内で直接 Redux ストアの状態取得およびアクションディスパッチの機能を実装してください。
    
- **詳細:**
    

1. **Hooks を使った状態取得とアクションディスパッチの実装:**
    
    - `useSelector` を用いて、Reduxストアからタスク配列（例: `state.todos.tasks`）を取得。
        
    - `useDispatch` を用いて、タスクの追加・削除・完了状態切替のためのアクションをディスパッチ。
        
2. **App.jsx 内での実装:**
    
    - 新しいコンポーネント（container等）は作成せず、すべての Redux ロジックを App.jsx 内に記述する。

- **目的:**
    
    - Redux Hooks の基本的な利用方法を理解し、シンプルで直接的な状態管理を体験する。
        
    - Redux 状態管理ロジックを一元化し、明確で保守しやすいコードを書く。
        
- **注意点:**
    
    - 必ず `react-redux` をインストールし、Providerの設定を行ったうえで Hooks を使用する。
        
- **ヒント:**
    
    - React-Redux の公式ドキュメント「Hooks」セクションを参考にする（[React-Redux Hooks API](https://react-redux.js.org/api/hooks)）。
        

---

<div style="page-break-before:always"></div>

## 【Step 4：TypeScriptへのリファクタリング】
### **18. TypeScriptの導入**

- **問題:**  
    TypeScriptをプロジェクトに導入し、Reactアプリ（Redux込み）をTypeScript化するための初期設定を実施してください
    
- **解答・解説:**  
    以下のステップで、**Redux** を含むReactプロジェクトに後からTypeScriptを導入します。
    

1. **npm installの実行:**
    
    - まず、TypeScript本体と、React用＆Redux用の型定義パッケージをインストールします。
        
    - 例:
        
        ```bash
        npm install --save-dev typescript @types/react @types/react-dom @types/redux @types/react-redux
        ```
        
    - これにより、`*.tsx` ファイルや Redux周りの型補完、JSX構文に対する型サポートが有効になります。
        
2. **TypeScript設定ファイルの作成:**
    
    - `npx tsc --init` を実行し、プロジェクトルートに `tsconfig.json` を生成します。        
        
3. **拡張子と型定義の確認:**
    
    - すでに存在する `.js` ファイルを順次 `.ts` / `.tsx` にリネームする。Reactコンポーネントは通常 `.tsx` を使います。
        
    - 例: `TaskAdd.jsx` → `TaskAdd.tsx`
                

- **目的:**
    
    - Reduxを含むReactプロジェクトを**型安全**に強化するため、TypeScriptの導入と基本設定を行う。
        
    - 後のステップで、コンポーネントのpropsやReduxのリデューサーに対し型定義を導入し、保守性と可読性を高める。
        
- **注意点:**
    
    - プロジェクトで既にBabelやWebpack/Viteなどを使っている場合、**tsconfig.json** とビルドツールの設定が連携されるように調整が必要（Create React App / Viteの場合はTypeScriptテンプレートがある）。
        
    - すべての`.js`ファイルを一斉に変えるのではなく、**段階的**に `.ts` / `.tsx` へ変えつつ、型付けを進める方法もある。
        
- **ヒント:**
    
    - TypeScript公式ドキュメントを参照し、React + Redux + TypeScript の基本構成を把握する。
        

---

### **19. 主要なReactコンポーネントのTypeScript変換（TaskAdd）**

- **問題:**  
    TaskAddコンポーネントをTypeScriptに変換してください
    
- **詳細:**
                
    1. **Props & 内部状態の型付け**:
        
        - Propsには「`onAddTask: (text: string) => void;`」のようにインターフェースを定義し、コンポーネント引数に適用する。
        
	2. イベントハンドラの型付け:
		
		- handleSubmit関数のイベント引数の型を明示的に指定する。
    
- **目的:**
    
    - TypeScriptによる型安全な開発のメリットを体感し、コンポーネントの**Props** と **内部状態** を明示的に型定義する方法を学ぶ。
        
- **注意点:**
    
    - **tsconfig.json** で `"jsx": "react-jsx"` にしておき、JSX を扱える状態にする。
        
    - コード変更後、コンパイラが警告を出したり、エディタが型エラーを報告する場合は、それを修正しながら進める。
        
- **ヒント:**
    
    - `React.FC` は使用しない。
 
---
### **20. 他のReactコンポーネントのTypeScript変換（TaskList、TaskInfo）**

- **問題:**  
    TaskListおよびTaskInfoコンポーネントをTypeScriptに変換してください
    
- **詳細:**
                
    1. **型定義の追加**
        
        - それぞれの `props` に対してインターフェイスを定義し、タスク配列やコールバック関数などの型を明示する。
            
        - 例: `TaskListProps { tasks: Task[]; onDeleteTask?: (id: number) => void; ... }`
            
        - `TaskInfoProps { incomplete: number; total: number }`
            
        - 必要に応じて、**共通の `Task` インターフェイス** を作り、`id`, `text`, `completed` の型を一括管理するとよい。
            

3. **動作確認**
    
    - 変換後、コンパイルエラーや型エラーが出ないかチェックし、タスク一覧表示・未完了数表示などの機能が正しく動作するか確認する。
        

- **目的:**
    
    - **複数のコンポーネント**でTypeScriptの型定義を適用し、**UIコードの可読性・保守性**をさらに向上させる。
        
    - TaskAddだけでなくTaskListやTaskInfoも型付けすることで、**プロジェクト全体の型整合性**が保たれ、大規模化にも耐えうる設計を実現する。
        
- **注意点:**
    
    - **コンポーネント間で共通の型**(例: `Task`) を使い回すと、エラーやすり合わせが減って保守しやすい。
        
- **ヒント:**
    
    - `React.FC` は使用しない。
        

---

### **21. Redux関連ファイルのTypeScript対応**

- **問題:**  
    Reduxの関連ファイルをTypeScript対応に変更してください
    
- **詳細:**
    
    1. **Reduxファイルを.ts化**
        
        - store, sliceを `.js` から `.ts` に変換。
            
    2. **型定義の追加**
        
        - `RootState` や `AppDispatch` を **store** から推論する形で定義する (`ReturnType` / `typeof`).
            
        - `interface Todo` などアプリのドメインモデルを定義し、slice の `PayloadAction<Todo>` のように使う。
            
        - initialState, reducers などが型整合を取れるかチェック。
            
    3. **全体の型安全性確認**
        
        - 既存のコンテナコンポーネント(`useSelector`, `useDispatch`) がエラーなく型を取得できるかテスト。
            
        - タスク追加/削除などが型安全に扱えるか確認。
            
- **目的:**
    
    - Reduxによる状態管理もTypeScriptで実装し、**アプリ全体**を型安全にする。
        
    - store, slice, reducers, action payload などの型定義を行い、保守性を高める。
        
- **注意点:**
    
    - 各ファイルで型が食い違わないように**RootState** や **AppDispatch** などを中心にまとめる。
        
    - PayloadAction を使う場合、**generic** の型を間違えないように。
        
- **ヒント:**
    
    - Redux Toolkit公式のTypeScript Quick StartやPayloadActionの例を参照し、実際に**slice** へ型付けすると分かりやすい。
        
    - store設定ファイルで `export type RootState = ReturnType<typeof store.getState>;` などを定義すると、**useSelector** がRootStateを推論できるようになる。
        

---

### **22. App.tsxのTypeScript対応**

- **問題:**  
    App.tsx`をTypeScript対応に変更してください
    
- **詳細:**
    
    1. **コンポーネントのTypeScript化**
        
        - `App.jsx` を `.tsx` に変換し、Reactコンポーネントを型安全に実装する。
            
    2. **型定義の追加**
        
        - stateについて、型定義を追加する。
            
        - イベントハンドラ（`handleAddTask`, `handleDeleteTask`, `handleToggleTask`）の引数にも型定義を行う。
            
    3. **Redux関連の型を利用**
        
        - Reduxの型（`RootState`, `AppDispatch`）や、sliceからエクスポートした`addTask`, `deleteTask`, `toggleTask`を適切に型付けする。
            
        - `useSelector`, `useDispatch` に型指定を追加し、Reduxの状態を型安全に扱えるようにする。
            
- **目的:**
    
    - ReactコンポーネントをTypeScript化することで、アプリケーション全体を型安全に保つ。
        
    - props, state, Reduxの状態、イベント処理を型定義により明示し、保守性を高める。
        
- **注意点:**
    
    - 型定義には`interface`または`type`を利用し、適切に定義すること。
        
    - Reduxの`RootState`, `AppDispatch`を正しくインポートし、型推論を利用して型安全性を担保する。
        
- **ヒント:**
    
    - Redux Toolkit公式のTypeScriptの 「[Quick Start](https://redux-toolkit.js.org/tutorials/quick-start)」を参考にし、特に`useSelector`の型付け方法を参照する。
        
    - イベントハンドラは、引数に型定義（`string`, `number` など）を明示することで、型安全に実装できる。
        

---


### **23. UI/UX改善のためのバリデーション強化**

- **問題:**  
    入力検証と視覚的フィードバックの強化処理を実装してください
    
- **詳細:**
    
    1. **TaskAddコンポーネント内でのバリデーション追加:**
        
        - ** **重複チェック**（既に同じタスク名が存在するか）と入力が空文字（またはスペースのみ）の場合のバリエーションチェックを組み込み、バリデーションエラー時にユーザーへわかりやすいエラーメッセージを表示する。
            
    2. **エラー発生時の視覚的フィードバック:**
        
        - CSSクラスを条件付きで付与し、**赤枠やshakeアニメーション**などアピールを行う。
            
        - 例: `className={hasError ? 'task-input error' : 'task-input'}` + `@keyframes shake { ... }`.
            
    3. **エラー解消時のリセット:**
        
        - 再入力または別の操作でエラー原因が解消されたら、**赤枠やエラーメッセージ**を除去する。
            
        - ステート管理で `errorMessage` や `hasError` をリセットする等。
            
- **目的:**
    
    - **ユーザー体験向上**のため、**厳密な入力検証**と**わかりやすい視覚的フィードバック**を実装し、使いやすくする。
        
    - Reactコンポーネントでのエラーメッセージ表示やCSSクラス切り替えの設計を学ぶ。
        
- **注意点:**
    
    - CSSクラスやエラーステートが**永続**することなく、入力が再度正常になったら**リセット**されるように注意する。
        
- **ヒント:**
    
    - CSSのアニメーション (`@keyframes`) や条件付きクラス (`className={condition ? 'error' : ''}`) を活用する。
        
    - バリデーション失敗時には `setErrorMessage('...')` → UIで `<p className="error-msg">{errorMessage}</p>` のように表示するなどのアプローチを参考にすると実装しやすい。
	    
	- 下記のようなtriggerError関数を定義し、エラー発生時に呼び出す仕組みにすることを推奨する。

``` tsx
const triggerError = (message: string) => {
    setHasError(false);
    setTimeout(() => setHasError(true), 0); // クラスの再追加で再描画を促す
    setErrorMessage(message);
 };

```
<div style="page-break-before:always"></div>

## 【Step 5：単体試験の導入】

### **24. 単体試験の実施**

- **問題:**  
    Reactコンポーネントに対して簡易的な単体試験を導入し、これまで実装した機能が正しく動作しているか確認してください。
    
- **詳細:**
    
    以下のツールを使用して、簡易的な単体試験を作成します。
    
    - **テストランナー：** Jest
        
    - **テストユーティリティライブラリ：** React Testing Library
        

1. **必要なライブラリのインストール（TypeScriptおよびJSX対応済み）:**
    

```bash
npm install --save-dev jest ts-jest @types/jest @testing-library/react @testing-library/jest-dom jest-environment-jsdom
```

2. **Jestの設定（jest.config.js）:**
    

プロジェクトルート直下に`jest.config.js`を作成します。

```js
export default {
  preset: 'ts-jest',
  testEnvironment: 'jsdom',
  setupFilesAfterEnv: ['@testing-library/jest-dom'],
  transform: {
    '^.+\\.tsx?$': 'ts-jest'
  },
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1'
  }
};
```

3. **テストファイルの作成:**
    

テスト対象のコンポーネントごとに`.test.tsx`ファイルを作成します。例として、`TaskAdd`コンポーネントのテストを作成します。

**ファイル構成例：**

```
src/
├── components/
│   ├── TaskAdd.tsx
│   └── TaskAdd.test.tsx
```

4. **単体試験の実施:**

下記の機能が動作するか単体テストを行い、確かめてください。
- **TaskAdd.test.tsx**
    
    - タスク追加処理が正しく実行されるか
        
    - バリデーション（空白や重複）が正しく機能するか
        
- **TaskList.test.tsx**
    
    - タスクの一覧が正しく表示されるか
        
    - 削除ボタンや完了切替ボタンが正しく動作するか
        
- **TaskInfo.test.tsx**
    
    - タスク数（総数・未完了数）が正しく表示されるか


TaskAdd.test.tsxの記載例
```tsx
// TaskAdd.test.tsx
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import '@testing-library/jest-dom';
import TaskAdd from './TaskAdd';
import type { Task } from './TaskList';

describe('TaskAddコンポーネントのテスト', () => {
  // テスト用の既存タスク
  const mockExistingTasks: Task[] = [
    { id: 1, text: 'existing task', completed: false },
  ];

  // onAddTask用のモック関数
  const mockOnAddTask = jest.fn();

  beforeEach(() => {
    // 各テストの前にモック関数をリセット
    mockOnAddTask.mockClear();
  });

  // 1. タスク追加処理が正しく実行されるかのテスト
  test('有効なタスクが正常に追加されること', () => {
    // コンポーネントをレンダリング
    render(
      <TaskAdd onAddTask={mockOnAddTask} existingTasks={mockExistingTasks} />
    );

    // 入力フィールドを取得
    const inputElement =
      screen.getByPlaceholderText('タスクを入力してください');

    // 入力フィールドに値を入力
    fireEvent.change(inputElement, { target: { value: 'new task' } });

    // 追加ボタンをクリック
    const buttonElement = screen.getByText('追加');
    fireEvent.click(buttonElement);

    // 検証: タスク追加関数が正しい値で呼ばれたか
    expect(mockOnAddTask).toHaveBeenCalledWith('new task');

    // 検証: 入力フィールドがクリアされたか
    expect(inputElement).toHaveValue('');
  });

  // 2-1. バリデーション（空白チェック）のテスト
  test('空のタスクを追加しようとするとエラーが表示されること', async () => {
    // コンポーネントをレンダリング
    render(
      <TaskAdd onAddTask={mockOnAddTask} existingTasks={mockExistingTasks} />
    );

    // 追加ボタンをクリック（何も入力せずに）
    const buttonElement = screen.getByText('追加');
    fireEvent.click(buttonElement);

    // 非同期処理を待機してからエラーメッセージの表示を検証
    await waitFor(() => {
      const errorElement = screen.getByText(
        'タスクを入力してください（空白のみは不可）'
      );
      expect(errorElement).toBeInTheDocument();
    });

    // 検証: タスク追加関数が呼ばれていないこと
    expect(mockOnAddTask).not.toHaveBeenCalled();
  });

  // 2-2. バリデーション（重複チェック）のテスト
  test('重複するタスクを追加しようとするとエラーが表示されること', async () => {
    // コンポーネントをレンダリング
    render(
      <TaskAdd onAddTask={mockOnAddTask} existingTasks={mockExistingTasks} />
    );

    // 入力フィールドに既存のタスク名を入力
    const inputElement =
      screen.getByPlaceholderText('タスクを入力してください');
    fireEvent.change(inputElement, { target: { value: 'existing task' } });

    // 追加ボタンをクリック
    const buttonElement = screen.getByText('追加');
    fireEvent.click(buttonElement);

    // 非同期処理を待機してからエラーメッセージの表示を検証
    await waitFor(() => {
      const errorElement = screen.getByText('同じタスク名が既に存在します');
      expect(errorElement).toBeInTheDocument();
    });

    // 検証: タスク追加関数が呼ばれていないこと
    expect(mockOnAddTask).not.toHaveBeenCalled();
  });
});

```

5. **テストの実行方法:**
    

- プロジェクトの`package.json`に以下のスクリプトを追加します。
    
    ```json
    "scripts": {
      "test": "jest"
    }
    ```
    
- ターミナルから以下のコマンドを実行し、テストを実施します。
    
    ```bash
    npm test
    ```
    
- 特定のファイルのみテストしたい場合は以下のように実行します。
    
    ```bash
    npm test src/components/TaskAdd.test.tsx
    ```
        
- **目的:**
    
    - 単体試験の基本的な作成方法を学び、Reactコンポーネントが意図した通りに機能しているかを確認する。
        
    - JestとReact Testing Libraryを使った簡易的な単体テストを習得する。
        
- **注意点:**
    
    - コンポーネントがPropsを正しく処理することや、ユーザーインタラクションに基づいて正しい処理を呼び出すことを主に検証します。
        
    - テストが通らない場合は、元のコンポーネントの実装を再度確認・修正してください。
        
- **ヒント:**
    
    - React Testing Libraryはユーザー視点のテスト作成に特化しているため、実際に画面を操作するような感覚でテストを書くと理解しやすいです。
        
    - テストケースは小さく分割し、一つ一つの機能や挙動を明確にすることが望ましいです。

![24.png](https://image.docbase.io/uploads/bc63e9b4-5b44-4355-a93f-a70173ee8bd7.png =WxH)

