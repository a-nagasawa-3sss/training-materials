全24問構成となっています。各Stepの流れに沿って、順に問題を進めて下さい。

---

## Step 1: プロジェクト初期設定(Nuxt 3 + TypeScript)
## 1. **プロジェクト作成&不要ファイルの整理**  
   **内容:**  
   - 以下のコマンドでNuxt 3プロジェクトを初期化する。
     ```bash
     npx nuxi init quiz-app
     cd quiz-app
     npm install
     ```  
   - 不要なサンプルページ(例: `app.vue`やデフォルトのコンポーネント)を整理し、最小構成にする。
     
   **目的:**  
   - Nuxt 3 + TypeScriptプロジェクトの初期セットアップとディレクトリ構成の理解。
## 2. **Hello World表示**  
   **内容:**  
   - `/pages/index.vue`を作成し、画面に「Hello Nuxt + TypeScript」と表示する。
   - Vueのシンプルなテンプレート構文と`<script setup lang="ts">`を利用する。
     
   **目的:**  
   - Nuxtのページ構成とTypeScript環境の動作確認。
## Step 2: 基本ページ&コンポーネントの学習
## 3. **共通レイアウトの作成**  
   **内容:**  
   - `/layouts/default.vue`を作成し、ヘッダーとフッターを含む共通レイアウトを実装する。  
   - `<slot />`を用いて各ページのコンテンツを挿入する。
     
   **目的:**  
   - Nuxtのレイアウト機能を理解し、コンポーネントの分割方法を学ぶ。
## 4. **複数ページの作成&ナビゲーション**  
   **内容:**  
   - `/pages/index.vue`(ホームページ)と`/pages/about.vue`(または`/pages/other.vue`)を用意する。 
   - ヘッダー内またはレイアウト内に`<NuxtLink>`を使った簡単なナビゲーションメニューを実装する。
     
   **目的:**  
   - Nuxtのページルーティングと`<NuxtLink>`コンポーネントの使い方を理解する。
## Step 3: クイズ一覧の表示(JSONデータ取得 + 基本UI)
## 5. **JSONファイル(quizzes.json)の作成**  
   **内容:**  
   - プロジェクト内に`data`フォルダを作成し、`quizzes.json`ファイルを配置する。
   - 以下のようなダミークイズデータを登録する。
     ```json
     [
       {
         "id": 1,
         "title": "Nuxt基礎クイズ",
         "createdAt": "2025-01-01",
         "questions": [
           { "questionText": "問題文例", "options": ["A", "B"], "correctIndex": 0 }
         ]
       },
       {
         "id": 2,
         "title": "TypeScript基礎クイズ",
         "createdAt": "2025-01-05",
         "questions": [
           { "questionText": "別の問題文例", "options": ["C", "D"], "correctIndex": 1 }
         ]
       }
     ]
     ```  
   **目的:**  
   - ダミーデータを用意し、後続のAPI ルートや画面表示で活用する。
## 6. **APIルート`/server/api/quizzes.ts`のGET実装**  
   **内容:**  
   - Nuxt 3のサーバーAPI機能を利用して、`/server/api/quizzes.ts`を作成する。
   - Node.jsの`fs`モジュールと`path`を利用し、`data/quizzes.json`を読み込んで返却する。
     ```ts
     import { readFileSync } from 'fs'
     import { join } from 'path'

     export default defineEventHandler((event) => {
       const filePath = join(process.cwd(), 'data', 'quizzes.json')
       const data = JSON.parse(readFileSync(filePath, 'utf-8'))
       return data
     })
     ```  
   **目的:**  
   - Nuxt 3のAPIルート機能を習得し、GETリクエストに対応できるようにする。
## 7. **ホーム画面でクイズ一覧の取得と表示**  
   **内容:**  
   - `/pages/index.vue`内で`useFetch('/api/quizzes')`を使い、クイズ一覧データを取得する。
   - タイトルと作成日を簡易的なカードデザイン（Tailwind CSS を後で導入可能）で一覧表示する。
     
   **目的:**  
   - クライアントサイドでのデータ取得と状態管理、画面表示の基本的なデータフローを学ぶ。
## Step 4: クイズ詳細&挑戦ページ(動的ルーティング + 基本ロジック)
## 8. **クイズ詳細ページの作成**  
   **内容:**  
   - `/pages/quiz/[id].vue`を作成し、`useRoute()`を利用して URL パラメータからクイズIDを取得する。
   - 取得したIDを元にクイズデータを表示する。(まずはコンソール出力などで確認しても構わない)
     
   **目的:**  
   - Nuxtの動的ルーティングの仕組みと、URLパラメータの利用方法を理解する。
## 9. 指定IDのクイズを取得して表示
**内容:**  
- `/pages/quiz/[id].vue`内で、`useRoute()`を用いてURLパラメータの`id`を取得する。  
- `useFetch('/api/quizzes')`で全クイズデータを取得し、取得結果からルートパラメータの`id`と一致するクイズをフロント側でフィルタリングする。  
- クイズのタイトル、各問題の問題文(複数ある場合は全て)を画面に表示する。  
- URLパラメータの活用と、取得したデータから条件に応じたフィルタリングの基本を習得する。
## 10. 簡易的な回答インターフェース
**内容:**  
- `/pages/quiz/[id].vue`内で、最初の問題の選択肢をラジオボタンまたは`<button>`を使って表示する。  
- ユーザーがいずれかの選択肢を選んだ後、「回答する」ボタンをクリックすると、選んだ選択肢(またはそのインデックス)がコンソールに出力される。  
  - 例：`console.log(selectedOption)`  
- この段階では、選択結果の保存は行わず、フォームの状態管理(Vueの`ref()`や`reactive()`を利用)に慣れることを目的とする。  

**目的:**  
- フォーム操作と状態管理の基本(選択状態の管理、イベントハンドリング)を学ぶ。
## Step 5: クイズ作成機能(フォーム + JSON書き込み)
## 11. クイズ作成ページ(/quiz/create)のフォームレイアウト
**内容:**  
- `/pages/quiz/create.vue`を作成し、クイズの「タイトル」「概要（任意）」「問題文」「選択肢」を入力できるフォームを実装する。  
- 「問題を追加」ボタンを設置し、ボタンをクリックすることでフォームに新たな問題入力欄を動的に追加できるよう、問題情報を配列で管理する。  
- 例：`const questions = ref<Array<Question>>([])`として、各問題オブジェクトをpushする。  
- フォームの入力状態は`v-model`や`reactive()`で管理する。  

**目的:**  
- 複数の入力項目を配列で管理する方法や、動的にフォームフィールドを追加する実装方法を学ぶ。
## 12. APIルートのPOST処理でJSONファイルに書き込み
**内容:**  
- Nuxt 3のサーバーAPI機能を利用し、`/server/api/quizzes.ts`内にPOSTブロックを追加する。  
- POSTリクエストの場合、リクエストボディ(新しいクイズ情報)を受け取り、既存の`data/quizzes.json`を読み込み、配列に新しいデータをpushした上で上書き保存する。  
  - 例:
    ```ts
    import { readFileSync, writeFileSync } from 'fs'
    import { join } from 'path'

    export default defineEventHandler(async (event) => {
      const filePath = join(process.cwd(), 'data', 'quizzes.json')
      if (event.node.req.method === 'POST') {
        const newQuiz = await readBody(event)
        const data = JSON.parse(readFileSync(filePath, 'utf-8'))
        data.push(newQuiz)
        writeFileSync(filePath, JSON.stringify(data, null, 2))
        return { message: 'Quiz added successfully' }
      }
      // GET 処理は別途記述
      const data = JSON.parse(readFileSync(filePath, 'utf-8'))
      return data
    })
    ```  
**目的:**  
- サーバーサイドでのファイルの読み書きと、フロントからのPOSTリクエストの連携を理解する。
## 13. 作成完了後の画面遷移
**内容:**  
- クイズ作成フォームの「保存」ボタンを押下した後、POSTリクエストが成功すれば、`useRouter().push()`を使って`/quiz/[新しいID]`へ遷移する。  
- 成功時と失敗時で、アラートや画面上のメッセージ(例: `<p>`タグでエラーメッセージを表示)を出すようにする。  

**目的:**  
- フロント側での非同期通信結果に基づいた画面遷移と、ユーザーへのフィードバックの実装方法を学ぶ。
## Step 6: 状態管理(Redux→Pinia)・Tailwind導入
## 14. Piniaの導入&Store作成
**内容:**  
- Nuxt 3プロジェクトにPiniaを導入する。(`npm install pinia` などでインストール)
- `/stores/quizStore.ts`などのファイルを作成し、`defineStore`を使ってクイズ関連の状態管理用ストアを実装する。  
  - 例:
    ```ts
    import { defineStore } from 'pinia'
    export const useQuizStore = defineStore('quiz', {
      state: () => ({
        currentQuestionIndex: 0,
        answers: [] as number[],
      }),
      actions: {
        answerQuestion(answer: number) {
          this.answers.push(answer)
          this.currentQuestionIndex++
        }
      }
    })
    ```  
- Nuxt 3のプラグイン設定または`nuxt.config.ts`にPiniaを登録する。(Nuxt 3では自動的に有効化できる場合もある)

**目的:**  
- アプリ全体で共有する状態(例：クイズの進捗、回答履歴)をPiniaにより管理する基礎を学ぶ。
## 15. クイズ回答状態をPiniaで管理
**内容:**  
- 既に作成したPiniaのストア内に、ユーザーの「現在の問題インデックス」や「回答状況」を管理するstateを定義する。  
- `/pages/quiz/[id].vue`(または回答用の専用ページ)で、回答ボタン押下時にストアのアクション(例：`useQuizStore().answerQuestion(selectedIndex)`)を呼び出す。  

**目的:**  
- ページ間で状態を共有し、ユーザーの回答状況を管理する方法を習得する。
## 16. Tailwind CSSの導入&全画面での利用
**内容:**  
- Tailwind CSSをNuxtプロジェクトに導入する。  
  - 必要なパッケージをインストールする。  
    ```bash
    npm install -D tailwindcss@3.4.17 postcss autoprefixer
    ```  
  - `tailwind.config.js`を作成し`darkMode: 'class'`を設定し、必要に応じてカスタム設定を行う。  
  - `assets/css/tailwind.css`などに以下を記述し、`nuxt.config.ts`の`css`配列に追加する。
    ```css
    @tailwind base;
    @tailwind components;
    @tailwind utilities;
    ```  
- ホーム、作成、挑戦ページなど各画面で、カード、ボタン、フォームなどにTailwind CSSのユーティリティクラスを付与し、シンプルかつレスポンシブなデザインに整える。  

**目的:**  
- Tailwind CSSを使って効率的にUIを整える方法と、ダークモード対応(`dark:`クラス)を学ぶ。
# Step 7: 結果ページの実装
## 17. 結果ページ`/quiz/result/[id]`作成
**内容:**  
- クイズ挑戦が完了した際、Nuxtの`useRouter().push()`を利用して`/quiz/result/[id]`へ遷移する。  
- 結果ページでは、Piniaストア(例: `useQuizStore()`)に保存してある回答履歴や正解インデックスを参照し、正解数などの得点を計算して表示する。  
- 例として、ストアの`answers`配列とクイズの`questions`配列を比較し、正解の数を算出するロジックを実装する。  

**目的:**  
- ページ間で状態管理された回答データをもとに、結果集計と画面遷移の連携を学ぶ。
## 18. 「再挑戦」「ホームへ戻る」ボタン
**内容:**  
- 結果ページ上に「再挑戦する」ボタンを配置し、クリック時に同じクイズ(`/quiz/[id]`)へ戻る。  
- また、「ホームへ戻る」ボタンも配置して、トップページ(`/`)へ遷移する。  
- それぞれNuxtの`<NuxtLink>`コンポーネントまたは`useRouter().push()`を活用する。  

**目的:**  
- ユーザーに次のアクション(再挑戦やホームへ戻る)を提供し、UXの向上を図る。
## 19. 正答率表示 & 個別問題の正解表示(任意)
**内容:**  
- 得点計算として「正解数 ÷ 全問題数」から正答率を算出し、画面上に表示する。  
- さらに、各問題についてユーザーの回答と正解情報をリスト表示し、正解・不正解の判定結果を示す。  
- 例：問題番号、問題文、ユーザーの回答、正解をまとめたカードやリスト形式のUIを実装する。  

**目的:**  
- 詳細な結果表示によって、一問ごとの判定や全体のパフォーマンスの把握、アプリ完成度の向上を学ぶ。
# Step 8: ダークモード切替などの追加演習
## 20. ダークモード用のPiniaストア作成
**内容:**  
- 新たに`/stores/themeStore.ts`を作成し、以下のように`darkMode: boolean`を管理するストアを定義する。  
  ```ts
  import { defineStore } from 'pinia'

  export const useThemeStore = defineStore('theme', {
    state: () => ({
      darkMode: false
    }),
    actions: {
      toggleDarkMode() {
        this.darkMode = !this.darkMode
        // ドキュメントルートに .dark クラスを付与／削除
        // ここの部分を作成してください
      }
    }
  })
  ```  
**目的:**  
- アプリ全体のテーマ状態をPiniaで管理し、ユーザー操作に応じてダークモード/ライトモードを切り替える方法を学ぶ。
## 21. ダークモード トグルUI実装
**内容:**  
- ヘッダーまたは専用の`/layouts/default.vue`ページにトグルスイッチ(例：`<input type="checkbox">`やカスタムコンポーネント)を配置する。 
- トグル操作時に`useThemeStore().toggleDarkMode()`を呼び出し、テーマ状態を切り替える。  
- Tailwind CSSの`dark:`クラスが有効になるように、HTMLのルート要素に`.dark`クラスが付与される実装と連携させる。  

**目的:**  
- ユーザー操作とUIテーマの連動を実現し、ダークモード切替の体験を向上させる。
## 22. ダークモード時の色確認&細部調整
**内容:**  
- 各画面(ホーム、クイズ作成、挑戦、結果ページなど)のボタンやカード、テキストがダークモード時に見やすいかを確認する。  
- 必要に応じて、Tailwind CSSのクラス(例：`dark:bg-gray-800`, `dark:text-white`など)を追加し、色や背景の調整を行う。  

**目的:**  
- ダークモードにおけるUI/UXの最適化と、細部調整による完成度向上のノウハウを体得する。
# Step 9: (任意)更なる拡張
## 23. URL共有(クイズURLのコピー機能)
**内容:**  
- ホーム画面に「URLをコピー」「挑戦する」ボタンを追加する。  
- ボタン押下時に`navigator.clipboard.writeText(window.location.href)`などを使って、クイズ詳細ページのページURLをクリップボードにコピーできるようにする。 
- 「挑戦する」ボタン押下で、クイズ詳細ページに遷移できるようにする。  

**目的:**  
- マルチユーザー利用や他者へのクイズ共有を意識した機能実装を通じ、ブラウザAPIの活用方法を学ぶ。
## 24. Sassカスタマイズ&パーツごとのデザイン改良
**内容:**  
- Tailwind CSSのユーティリティクラスに加え、個別のコンポーネントで`*.module.scss`(または一般的なSCSSファイル)を利用して、再利用可能なカスタムスタイルを作成する。  
- ヘッダーやボタンなどのコンポーネントで、Sassの変数やミックスインを活用し、リッチなデザインに改良する。  
- 例：`assets/styles/_variables.scss`にテーマカラーを定義し、各コンポーネントでインポートして利用する。  

**目的:**  
- Tailwindの便利なユーティリティに加え、Sassを活用した細部までのデザインコントロールの方法を習得する。
※この問題は定まった正解はないため、scsssファイルを用いてアレンジしてください。
