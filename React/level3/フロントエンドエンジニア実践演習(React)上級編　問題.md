> 更新日：2026/05/08
> バージョン: 1.0
# React 上級編 — 在庫管理UI 演習問題

## 問題の進め方

- 各 Step は **前の Step に依存** しています。Step 1 から順番に取り組んでください。
- 問題を解くための土台として、スケルトンコード（`src/` 内の各ファイル）が提供されています。
- スケルトン内の `// TODO:` コメントが実装箇所です。それ以外の箇所は実装参考としてください。
- 実装後はアプリを起動して動作確認してください。

---

```bash
# 開発サーバー起動（APIサーバーも同時起動）
npm run dev:full
```

---

## 【開発サーバーの起動状態について】

> **実装を進める前に必ず読んでください。**

スケルトンコードは段階的に実装することを前提としているため、**実装途中の段階では開発サーバー（`npm run dev:full`）を起動しても画面がクラッシュ（白画面）します。** これは想定内の状態です。以下の表で「いつクラッシュが解消されるか」を確認してください。

| フェーズ | クラッシュの有無 | 原因 |
|---|---|---|
| Step 1 開始前（スケルトンそのまま） | ❌ **白画面** | `InventoryContext.tsx` が `receiveStock` / `shipStock` を import しているが、これらは `inventoryApi.ts` にまだエクスポートされていない。ES モジュールのリンク段階でエラーとなりアプリ全体がロードされない |
| Step 1（issue 2-1・2-2）実装後 | ❌ **白画面** | `inventoryReducer.ts` の `initialState` が `{} as InventoryState` のスタブのため `state.items` / `state.categories` が `undefined`。`InventoryList` / `StockForm` が `state.items.map()` を呼んだ瞬間に `TypeError: undefined is not iterable` が発生してクラッシュ |
| Step 2（issue 3-3）実装後 | ⚠️ **一部クラッシュ** | `initialState` が正しく設定されアプリは起動する。ただし `StockForm` の入庫フォームを開くと `matchedItem` / `selectedItem` が未宣言のため `ReferenceError` が発生してフォームがクラッシュ |
| Step 3（issue 7-2・7-3）実装後 | ✅ **全画面正常表示** | すべての変数が宣言され、クラッシュは完全に解消される |

**なぜこの順序でクラッシュが解消されるのか:**

1. **issue 2-1・2-2（`receiveStock` / `shipStock` のエクスポート）を実装する**と、`InventoryContext.tsx` の import が解決され、アプリのモジュールグラフが完成する。
2. **issue 3-3（`initialState` の初期値設定）を実装する**と、`state.items` / `state.categories` が空配列 `[]` になり、`map()` が安全に動作するようになる。
3. **issue 7-2・7-3（`selectedItem` / `matchedItem` の宣言）を実装する**と、入庫フォームの JSX が参照する変数がすべて揃い、フォーム画面のクラッシュも解消される。

> Step 1 実装中は開発サーバーを起動しても確認できません。issue 2-1・2-2 → issue 3-3 の順に実装を終えてから `npm run dev:full` で動作確認してください。

**各クラッシュ解消後の確認ポイント:**

**issue 3-3 実装直後（在庫一覧・出庫タブのみ確認可）:**
- `npm run dev:full` でサーバーを起動し、ブラウザで `http://localhost:5173` を開く
- 「在庫一覧」タブ: issue 5-1 / 11-1 がまだ未実装のため、在庫データは表示されない（空の表・ローディングなしが正常）
- 「出庫」タブ: 商品リストは空だが画面がクラッシュしないことを確認する
- 「入庫」タブ: issue 7-2・7-3 未実装のためクラッシュする（この時点では正常）

**issue 7-2・7-3 実装直後（全タブ確認可）:**
- 「入庫」タブを開いてもクラッシュしないことを確認する
- フォームの各入力欄（商品名・カテゴリ・数量）が表示されることを確認する
- この時点では issue 5-1〜5-5 / 11-1 が未実装のため、送信しても API は呼ばれない（正常）

**Step 2（issue 3-1〜5-6）完了後（状態管理が機能する）:**
- 「在庫一覧」タブ: ページ読み込み時に在庫データが表示されるようになる（issue 11-1 実装後）
- 「入庫」「出庫」タブ: フォーム送信後にトースト通知が表示され、在庫一覧が更新されることを確認する
- ブラウザの開発者ツール（F12）→「Network」タブで、`/api/inventory` への GET / POST リクエストが発生していることを確認する

---

## 【Step 1：型定義と API 関数の実装】

> **対応テーマ**: ④ REST API 連携  
> **目標時間**: 1h

---

### 1. 型定義ファイルの実装

- **問題:**  
  `src/types/inventory.ts` に、アプリ全体で使用する型定義を実装してください。

- **詳細:**  
  以下の型をファイルに定義してください。

  1. **カテゴリ一覧レスポンス型の定義:**（issue: 1-1）
      - `CategoryListResponse` — `Category` の配列型

  2. **新規商品登録リクエスト型の定義:**（issue: 1-2）
      - `CreateProductRequest` — `name: string`, `categoryId: number`, `quantity: number`

  3. **入庫リクエスト型の定義:**（issue: 1-3）
      - `ReceiveRequest` — `quantity: number`

  4. **出庫リクエスト型の定義:**（issue: 1-4）
      - `ShipRequest` — `quantity: number`

  5. **操作レスポンス型の定義:**（issue: 1-5）
      - `StockOperationResponse` — `success: boolean`, `item: InventoryItem`

  6. **新規商品登録レスポンス型の定義:**（issue: 1-6）
      - `CreateProductResponse` — `success: boolean`, `item: InventoryItem`

- **目的:**
  - API のリクエスト・レスポンスの形を TypeScript の `interface` / `type` で定義する
  - 型定義を一か所に集中させることで、reducer・サービス・コンポーネントの全層で型の恩恵を受けられるようにする

- **注意点:**
  - すべての型を `export` してください。他のファイルから参照できるようにする必要があります。
  - `interface` と `type` の使い分けは任意ですが、拡張可能なオブジェクト型には `interface` を使うのが一般的です。

---

### 2. API 関数の実装

- **問題:**  
  `src/services/inventoryApi.ts` に、バックエンド API と通信する関数群を実装してください。

- **詳細:**  
  5つの関数のうち、`fetchInventory`・`fetchCategories`・`createProduct` の3つは実装済み参考例です。`receiveStock` と `shipStock` の2つをコードコメントに従って実装してください。

  1. **`fetchInventory()`** — `GET /api/inventory`（実装済み参考例）
      - 戻り値の型: `Promise<InventoryListResponse>`
      - `fetch` を使い `${BASE}/inventory` へ GET リクエストを送る
      - `res.ok` が `false` の場合、`Error` をスロー
      - 成功したら `res.json() as Promise<InventoryListResponse>` を返す

  2. **`fetchCategories()`** — `GET /api/categories`（実装済み参考例）
      - 戻り値の型: `Promise<CategoryListResponse>`

  3. **`createProduct(payload: CreateProductRequest)`** — `POST /api/inventory`（実装済み参考例）
      - 戻り値の型: `Promise<CreateProductResponse>`

  4. **`receiveStock(id: number, payload: ReceiveRequest)`** — `POST /api/inventory/:id/receive`（issue: 2-1）
      - 戻り値の型: `Promise<StockOperationResponse>`
      - `method: 'POST'`、`headers: { 'Content-Type': 'application/json' }`、`body: JSON.stringify(payload)` を設定する
      - `res.ok` が `false` の場合、`res.json().catch(() => ({}))` でエラーボディをパースし、`message` プロパティがあればそれを、なければデフォルト文言が入った `Error` をスローする
      - 成功したら `res.json() as Promise<StockOperationResponse>` を返す

  5. **`shipStock(id: number, payload: ShipRequest)`** — `POST /api/inventory/:id/ship`（issue: 2-2）
      - 戻り値の型: `Promise<StockOperationResponse>`
      - `receiveStock` と同様のパターンで実装する

- **目的:**
  - `fetch` の低レベルな処理（URL 組み立て・ヘッダー設定・ステータスチェック・JSON 変換）をこのファイルに集約する
  - Reducer が HTTP 通信の詳細を知らなくて済む「関心の分離」を実現する

- **注意点:**
  - ベース URL の定数 `const BASE = '/api'` は先頭付近に定義済みです。
  - `res.ok` が `false` の場合は必ず `throw new Error(...)` してください。

- **ヒント:**
  - GET リクエストの基本構造:
    ```typescript
    const res = await fetch(`${BASE}/...`)
    if (!res.ok) throw new Error(`エラーメッセージ (${res.status})`)
    return res.json() as Promise<型名>
    ```

---

## 【Step 2：useReducer による状態管理の実装】

> **対応テーマ**: ② 状態管理  
> **目標時間**: 5.5h

---

### 3. State 型・Action 型・初期値の定義

- **問題:**  
  `src/reducers/inventoryReducer.ts` に、アプリ全体の状態を管理する State 型・Action Union 型・初期値を定義してください。

- **詳細:**  

  1. **`InventoryState` 型の定義:**（issue: 3-1）
      - `items: InventoryItem[]`
      - `categories: Category[]`
      - `isLoading: boolean`
      - `error: string | null`
      - `successMessage: string | null`
      - `searchQuery: string`
      - `categoryFilterId: number | null`
      - `sortKey: 'name' | 'quantity' | 'categoryId' | 'updatedAt'`
      - `sortOrder: 'asc' | 'desc'`

  2. **`InventoryAction` Union 型の定義:**（issue: 3-2）
      - `{ type: 'FETCH_START' }` — 通信開始（isLoading: true、メッセージリセット）
      - `{ type: 'FETCH_INVENTORY_SUCCESS'; payload: InventoryItem[] }` — 在庫取得成功
      - `{ type: 'FETCH_CATEGORIES_SUCCESS'; payload: Category[] }` — カテゴリ取得成功
      - `{ type: 'FETCH_ERROR'; payload: string }` — 通信失敗
      - `{ type: 'RECEIVE_SUCCESS'; payload: InventoryItem }` — 入庫成功
      - `{ type: 'SHIP_SUCCESS'; payload: InventoryItem }` — 出庫成功
      - `{ type: 'CREATE_SUCCESS'; payload: InventoryItem }` — 新規商品登録成功
      - `{ type: 'CLEAR_MESSAGES' }` — メッセージリセット
      - `{ type: 'SET_SEARCH_QUERY'; payload: string }` — 検索文字列更新
      - `{ type: 'SET_CATEGORY_FILTER'; payload: number | null }` — カテゴリ絞り込み更新
      - `{ type: 'SET_SORT'; payload: { key: InventoryState['sortKey']; order: 'asc' | 'desc' } }` — ソート更新

  3. **`initialState` の定義:**（issue: 3-3）
      - `InventoryState` 型に従った初期値オブジェクトを定義する
      - `items: []`, `categories: []`, `isLoading: false`, `error: null`, `successMessage: null`
      - `searchQuery: ''`, `categoryFilterId: null`, `sortKey: 'updatedAt'`, `sortOrder: 'desc'`

- **目的:**
  - `useReducer` が扱う State と Action の型を設計する
  - Union 型による Action の網羅的なパターンマッチングを学ぶ

- **注意点:**
  - Action 型は `type` プロパティで区別する **判別可能なユニオン型（Discriminated Union）** として定義してください。
  - TypeScript の `switch/case` で `action.type` を分岐させると、各 case 内で `payload` の型が自動的に絞り込まれます。

- **ヒント:**
  - 判別可能なユニオン型（Discriminated Union）の構文例:
    ```typescript
    type SampleAction =
        | { type: 'FETCH_START' }
        | { type: 'SET_NAME'; payload: string }
        | { type: 'SET_COUNT'; payload: number }
        | { type: 'SET_FILTER'; payload: number | null }
        | { type: 'SET_SORT'; payload: { key: string; order: 'asc' | 'desc' } }
    ```
  - なぜ `useState` を複数並べるよりも `useReducer` を使う方が管理しやすいのでしょうか？状態の変更パターンが増えたときのことを考えてみてください。

---

### 4. Reducer 関数の実装

- **問題:**  
  `src/reducers/inventoryReducer.ts` に `inventoryReducer` 関数を実装してください。

- **詳細:**  
  `(state: InventoryState, action: InventoryAction): InventoryState` というシグネチャで、`switch/case` を用いて各 action に対して新しい state を返す関数を実装してください。

  - **`FETCH_START`:**（スケルトン参考例として提供済み）
      - `isLoading: true`、`error: null`、`successMessage: null` にリセットした新しい state を返す

  - **`FETCH_INVENTORY_SUCCESS`:**（issue: 4-1）
      - `isLoading: false`、`items: action.payload` にした新しい state を返す

  - **`FETCH_CATEGORIES_SUCCESS`:**（issue: 4-2）
      - `isLoading: false`、`categories: action.payload` にした新しい state を返す

  - **`FETCH_ERROR`:**（issue: 4-3）
      - `isLoading: false`、`error: action.payload` にした新しい state を返す

  - **`RECEIVE_SUCCESS`:**（スケルトン参考例として提供済み）
      - `isLoading: false`、`successMessage` をセット
      - `items` の中の `action.payload.id` と一致する要素を `action.payload` で置き換えた新しい配列を返す

  - **`SHIP_SUCCESS`:**（issue: 4-4）
      - `isLoading: false`、`successMessage` をセット
      - `items` の中の `action.payload.id` と一致する要素を `action.payload` で置き換えた新しい配列を返す

  - **`CREATE_SUCCESS`:**（issue: 4-5）
      - `isLoading: false`、`successMessage` をセット
      - `items` に `action.payload` を追加した新しい配列を返す

  - **`CLEAR_MESSAGES`:**（issue: 4-6）
      - `error: null`、`successMessage: null` にした新しい state を返す

  - **`SET_SEARCH_QUERY`:**（issue: 4-7）
      - `searchQuery: action.payload` にした新しい state を返す

  - **`SET_CATEGORY_FILTER`:**（issue: 4-8）
      - `categoryFilterId: action.payload` にした新しい state を返す

  - **`SET_SORT`:**（issue: 4-9）
      - `sortKey: action.payload.key`、`sortOrder: action.payload.order` にした新しい state を返す

- **目的:**
  - reducer が「**純粋関数**」であることを理解する（副作用なし・同じ入力は常に同じ出力）
  - state の **immutable（不変）更新** パターンを習得する（スプレッド構文の活用）

- **注意点:**
  - state を直接変更してはいけません。常に `{ ...state, 変更したプロパティ }` のように新しいオブジェクトを返してください。
  - `switch` の `default` ケースは必ず `return state` にしてください。

- **ヒント:**
  - `RECEIVE_SUCCESS` で items を更新するときのパターン:
    ```typescript
    items: state.items.map((item) =>
      item.id === action.payload.id ? action.payload : item
    )
    ```
  - reducer が「純粋関数」でなければならない理由を考えてみてください。テストのしやすさと何の関係がありますか？

---

### 5. Context Provider の実装

- **問題:**  
  `src/contexts/InventoryContext.tsx` に、`useReducer` を使った Context Provider と、コンポーネントから利用するためのカスタムフック・アクション関数を実装してください。

- **詳細:**  

  1. **Context の作成:**（スケルトン参考例として提供済み）
      - `InventoryContext` を `createContext` で作成する

  2. **`InventoryProvider` コンポーネントの実装:**（スケルトン参考例として提供済み）
      - `useReducer(inventoryReducer, initialState)` で `[state, dispatch]` を取得する
      - `dispatch` を使って API 呼び出しを行うアクション関数を実装する（後述）
      - `InventoryContext.Provider` で `children` をラップし、`value` に状態と関数を渡す

  3. **アクション関数の実装（Provider 内）:**

      > **実装前に確認:** アクション関数には `useCallback` によるメモ化が必要です。このセクションの後にある「**参考: `useCallback` によるアクション関数のメモ化**」を**先に読んでから実装を始めてください**。依存配列の設計方針（どの変数を含めるべきか）を理解した上で進むと、stale closure によるバグを防げます。

      - **`loadInventory()`:**（issue: 5-1）
          - **`useCallback(async () => { ... }, [])` の形で実装する**（`dispatch` は参照が安定しているため依存配列は `[]`）
          - `dispatch({ type: 'FETCH_START' })` で通信開始
          - `fetchInventory()` を呼んで成功したら `dispatch({ type: 'FETCH_INVENTORY_SUCCESS', payload: data })` を発行
          - 失敗した場合は `dispatch({ type: 'FETCH_ERROR', payload: エラーメッセージ })` を発行

      - **`loadCategories()`:**（issue: 5-2）
          - **`useCallback(async () => { ... }, [])` の形で実装する**
          - `fetchCategories()` を呼んで成功したら `dispatch({ type: 'FETCH_CATEGORIES_SUCCESS', payload: data })` を発行
          - 失敗した場合は `dispatch({ type: 'FETCH_ERROR', payload: エラーメッセージ })` を発行
          - ※ `loadInventory` と異なり `FETCH_START` は不要（カテゴリ取得はローディング表示に影響しない）

      - **`receiveOrCreate(name, quantity, categoryId?)`:**（issue: 5-3）
          - **`useCallback(async (...) => { ... }, [state.items])` の形で実装する**
          - 依存配列が `[state.items]` の理由: この関数は内部で `state.items.find()` を呼んで既存商品を検索します。依存配列を `[]` にすると **stale closure（古い参照問題）** が発生し、在庫データが更新された後も初回レンダリング時の `state.items`（空配列）を使い続けてしまいます。`state.items` を依存配列に含めることで、在庫データが変わるたびに最新の参照を使う関数が再生成されます。
          - `dispatch({ type: 'FETCH_START' })` で通信開始
          - `state.items` の中に `name` と一致する商品があれば `receiveStock()` を呼び、`dispatch({ type: 'RECEIVE_SUCCESS', payload: result.item })` を発行
          - 一致する商品がなければ `createProduct({ name, categoryId!, quantity })` を呼び、`dispatch({ type: 'CREATE_SUCCESS', payload: result.item })` を発行
          - 失敗した場合は `dispatch({ type: 'FETCH_ERROR', payload: エラーメッセージ })` を発行

      - **`ship(id, quantity)`:**（issue: 5-4）
          - **`useCallback(async (id, quantity) => { ... }, [])` の形で実装する**
          - `dispatch({ type: 'FETCH_START' })` で通信開始
          - `shipStock()` を呼んで成功したら `dispatch({ type: 'SHIP_SUCCESS', payload: result.item })` を発行
          - 失敗した場合は `dispatch({ type: 'FETCH_ERROR', payload: エラーメッセージ })` を発行

      - **`clearMessages()`:**（issue: 5-5）
          - **`useCallback(() => { ... }, [])` の形で実装する**
          - `dispatch({ type: 'CLEAR_MESSAGES' })` を発行する
          - > **`clearMessages` のメモ化が特に重要！** `ToastMessage.tsx` の `useEffect` の依存配列に `clearMessages` が含まれているため、`useCallback` でメモ化しないと毎レンダリングで参照が変わり、`useEffect` が無限実行されるバグが発生します。

  4. **`useInventory` カスタムフックの実装:**（issue: 5-6）
      - `useContext(InventoryContext)` で Context の値を取得して返す
      - Context が `null` の場合（Provider 外で使用された場合）はエラーをスローする

- **目的:**
  - `useReducer` + Context API による状態管理パターンを学ぶ
  - React における「グローバル状態共有」の仕組みを理解する

- **注意点:**
  - `try/catch` で非同期処理のエラーを必ずキャッチしてください。
  - `e instanceof Error ? e.message : 'エラーが発生しました'` のパターンで安全にエラーメッセージを取り出してください。
  - `useInventory` は `InventoryProvider` の **外側** で呼ぶとエラーになります。`App.tsx` の Provider 設定を確認してください。

- **ヒント:**
  - `useCallback` の依存配列の考え方: 関数内部で参照しているコンポーネントのスコープ変数（`state.items` など）は依存配列に含める必要があります。`dispatch` は `useReducer` によって参照が安定していることが React に保証されているため含める必要はありません。
  - `useReducer` の `dispatch` 関数はなぜ「安定している（参照が変わらない）」と言われるのでしょうか？

---

## 【Step 3：コンポーネントの実装】

> **対応テーマ**: ① コンポーネント責務分離・再利用  
> **目標時間**: 2.5h

---

### 6. 在庫一覧コンポーネントの実装

- **問題:**  
  `src/components/InventoryList.tsx` を実装してください。

- **詳細:**  

  1. **Context の取得:**（スケルトン参考例として提供済み）
      - `useInventory()` で状態と関数を取得する

  2. **絞り込み＋ソート（`useMemo`）の実装:**（issue: 6-1）
      - `filteredItems` を `useMemo()` で定義する
      - `searchQuery` による商品名の部分一致フィルタリング（空文字はスキップ）
      - `categoryFilterId` によるカテゴリ絞り込み（`null` はスキップ）
      - `sortKey` / `sortOrder` によるソート（`'asc'` なら昇順・`'desc'` なら降順）
      - 依存配列: `[state.items, state.searchQuery, state.categoryFilterId, state.sortKey, state.sortOrder]`

  3. **`categoryName` 関数の実装:**（issue: 6-2）
      - カテゴリ ID を受け取り、`state.categories.find()` で一致するカテゴリ名を返す（見つからなければ `` `カテゴリ${id}` `` を返す）
      - **`useCallback` でメモ化した形で実装すること** — 通常の関数宣言ではなく `const categoryName = useCallback((id: number) => ..., [state.categories])` の形で直接定義する
      - 依存配列には `state.categories` を設定する（`state.categories` が変化するたびに関数が再生成される）

  4. **`handleToggleSort(key)` 関数の実装:**（issue: 6-3）
      - 同じ列を再クリックしたら `sortOrder` を `'asc'` ⇔ `'desc'` で反転する
      - 別の列をクリックしたら `sortKey` を切り替え、`sortOrder` を `'asc'` にリセットする
      - `dispatch({ type: 'SET_SORT', payload: { key, order } })` を発行する
      - **`useCallback` でメモ化した形で実装すること** — 通常の関数宣言ではなく `const handleToggleSort = useCallback((key: SortKey) => ..., [state.sortKey, state.sortOrder])` の形で直接定義する
      - `dispatch` は `useReducer` が返す安定した参照のため依存配列への追加は不要（後述「参考: `useCallback` によるアクション関数のメモ化」参照）

  5. **在庫少バッジの判定:**（issue: 6-4 ※JSXの実装）
      - `LOW_STOCK_THRESHOLD`（= 10）と比較して `item.quantity <= LOW_STOCK_THRESHOLD` の条件を判定
      - 条件を満たす行に黄色背景のクラスを付与する
      - 在庫数セル内に「在庫少」バッジを条件付きレンダリングする

- **目的:**
  - `useMemo` を使って重い計算を最適化し、必要なときだけ再計算する方法を学ぶ
  - コンポーネントにロジック（絞り込み・ソート）を集約し、JSX は結果を表示するだけにする責務分離を実践する

- **注意点:**
  - `filteredItems` のソートは **元の配列を破壊しない** ように注意してください（`[...array].sort(...)` を使う）。
  - `useMemo` の依存配列を正しく設定しないと、状態変化が反映されない場合があります。

- **ヒント:**
  - `useMemo` と `useCallback` の違いを説明できますか？
  - `useMemo` の依存配列が空 `[]` の場合、どのような動作になりますか？
  - `categoryName`（issue: 6-2）の実装イメージ:
    ```typescript
    const categoryName = useCallback((id: number): string => {
        return state.categories.find((c) => c.id === id)?.name ?? `カテゴリ${id}`;
    }, [state.categories]);
    ```
  - `handleToggleSort`（issue: 6-3）の実装イメージ:
    ```typescript
    const handleToggleSort = useCallback((key: SortKey) => {
        if (state.sortKey === key) {
            dispatch({ type: 'SET_SORT', payload: { key, order: state.sortOrder === 'asc' ? 'desc' : 'asc' } });
        } else {
            dispatch({ type: 'SET_SORT', payload: { key, order: 'asc' } });
        }
    }, [state.sortKey, state.sortOrder]);
    ```

---

### 7. 在庫フォームコンポーネントの実装

- **問題:**  
  `src/components/StockForm.tsx` を実装してください。

- **詳細:**  

  1. **Props の定義:**（スケルトン参考例として提供済み）
      - `mode: 'receive' | 'ship'` を Props として受け取る

  2. **入庫フォーム用 State（`useState`）の定義:**（スケルトン参考例として提供済み）
      - `receiveSelectId` — 「既存商品から選択」セレクトの商品 ID（`number | null`）
      - `productName` — 商品名テキスト入力（`string`）
      - `selectedCategoryId` — カテゴリ選択（`number | null`）

  2. **`useEffect` — `receiveSelectId` 変化時の自動入力:**（issue: 7-1）
      - `receiveSelectId` が変化したとき `productName`・`selectedCategoryId` を自動入力する
      - 依存配列: `[receiveSelectId, state.items]`

  4. **出庫・共通 State の定義:**（スケルトン参考例として提供済み）
      - `selectedId` — 出庫フォームの商品 ID（`number | null`）
      - `quantity` — 数量入力（`number | null`）
      - `validationError` — エラーメッセージ（`string | null`）

  4. 変数名: **`selectedItem` の計算:**（issue: 7-2）
      - `selectedId` から出庫対象の商品オブジェクトを `useMemo` または変数で取得する（在庫上限チェック用）

  5. 変数名: **`matchedItem` の計算:**（issue: 7-3）
      - `productName` を `state.items` と完全一致検索し、一致した商品を返す
      - 一致した場合 → 既存商品への加算入庫、`null` の場合 → 新規商品として登録する

  6. **`validate()` 関数の実装:**（issue: 7-4）
      - 入庫モード: 商品名が空の場合・新規商品でカテゴリ未選択の場合にエラー
      - 出庫モード: 商品未選択の場合・在庫数超過の場合にエラー
      - 数量が 1 未満の場合にエラー（共通）

  7. **`handleSubmit()` 関数の実装:**（issue: 7-5）
      - `validate()` が `false` の場合は処理を中断する
      - 入庫: `receiveOrCreate(productName, quantity, categoryId)` を呼ぶ
      - 出庫: `ship(selectedId, quantity)` を呼ぶ
      - 成功した場合のみフォームをリセットする（`state.error` が `null` の場合）

- **目的:**
  - `useState` によるローカル状態管理と、Context の State を組み合わせて使う方法を学ぶ
  - バリデーションロジックを `validate()` 関数に切り出し、`handleSubmit()` から呼ぶ責務分離を実践する

- **注意点:**
  - 送信失敗時はフォームの入力値を残してください（ユーザーが修正して再送信できる UX）。
  - `useEffect` の依存配列に `receiveSelectId` を含めてください。

---

### 8. トーストメッセージコンポーネントの実装

- **問題:**  
  `src/components/ToastMessage.tsx` を実装してください。

- **詳細:**  

  1. **`useEffect` による自動消去:**（issue: 8-1）
      - `state.successMessage` を監視し、メッセージがセットされたら3秒後に `clearMessages()` を呼ぶ
      - 依存配列: `[state.successMessage, clearMessages]`
      - クリーンアップ関数でタイマーをクリアする（`clearTimeout`）

- **目的:**
  - `useEffect` を用いてState の変化に反応した副作用（タイマー起動）を実装する
  - クリーンアップ関数の重要性を理解する（コンポーネントがアンマウントされたときのタイマーキャンセル）

- **注意点:**
  - `useEffect` のクリーンアップ関数でタイマーを必ずキャンセルしてください。クリーンアップなしでは、コンポーネントがアンマウントされた後もタイマーが動き続けます。
  - `useEffect` の依存配列に `clearMessages` を含めてください（`useCallback` でメモ化されていること）。

- **ヒント:**
  - クリーンアップ関数の書き方:
    ```typescript
    useEffect(() => {
      const timer = setTimeout(() => { ... }, 3000)
      return () => clearTimeout(timer)  // クリーンアップ
    }, [依存配列])
    ```

---

### （参考）`useCallback` によるアクション関数のメモ化（実装済み）

> issue: 5-1〜5-5 のアクション関数実装に `useCallback` のラップが組み込まれています。**issue 5 の実装前に先読みしてください。** 依存配列の設計方針を理解してから実装するとスムーズです。

- **なぜ `useCallback` が必要なのか:**  
  React ではコンポーネントが再レンダリングされるたびに関数が再生成され、**毎回異なる参照**になります。  
  `useCallback` でメモ化すると、依存配列の値が変わらない限り同じ関数参照を返し続けます。

- **依存配列の設計:**

  | 関数 | 依存配列 | 理由 |
  |---|---|---|
  | `loadInventory` | `[]` | 外部スコープの変数を参照しない |
  | `loadCategories` | `[]` | 外部スコープの変数を参照しない |
  | `receiveOrCreate` | `[state.items]` | 内部で `state.items.find()` を呼ぶため |
  | `ship` | `[]` | 外部スコープの変数を参照しない |
  | `clearMessages` | `[]` | `dispatch` は参照が安定しているため不要 |

  > `dispatch` は `useReducer` が返す関数で、React によって参照が安定していることが保証されているため、依存配列に含める必要はありません。

- **`clearMessages` のメモ化が特に重要な理由:**  
  `ToastMessage.tsx` の `useEffect` の依存配列に `clearMessages` が含まれています。  
  `useCallback` でメモ化しないと、`clearMessages` の参照が毎レンダリングで変わり、`useEffect` が毎回再実行されて3秒タイマーが意図せず繰り返し起動してしまいます。

- **`useCallback` と `useMemo` の違い:**  
  - `useCallback(fn, deps)` → **関数**をメモ化する（同じ関数参照を返す）  
  - `useMemo(() => value, deps)` → **計算結果の値**をメモ化する（同じ値を返す）

---

## 【Step 4：useEffect の統合】

> **対応テーマ**: ③ 副作用とuseEffect  
> **目標時間**: 1h

---

### 11. 初期データ取得の実装

- **問題:**  
  `src/pages/InventoryPage.tsx` に、コンポーネントマウント時に在庫一覧とカテゴリを取得する処理を実装してください。

- **詳細:**  

  1. **`useEffect` の実装:**（issue: 11-1）
      - `useEffect` のコールバック内で `loadInventory()` と `loadCategories()` を呼ぶ
      - 依存配列は `[]`（空配列）にして初回マウント時のみ実行されるようにする

- **目的:**
  - `useEffect` がいつ発火するかを理解する（マウント後・依存配列変化時）
  - 初回データ取得を `useEffect` で行う理由（コンポーネント本体での直接呼び出しとの違い）を理解する

- **注意点:**
  - コンポーネント本体（関数の先頭）で直接 `loadInventory()` を呼ばないでください。レンダリングのたびに実行され、無限ループの原因になります。
  - `useEffect` の依存配列を `[]` にすることで「初回マウント時のみ」実行を保証します。

- **ヒント:**
  - `useEffect` の第2引数（依存配列）が以下の場合の動作の違いを説明できますか？
    - `[]` — 初回マウント時のみ
    - `[someValue]` — `someValue` が変化するたびに
    - なし（省略） — 毎レンダリング後

  - **React useEffect 実行タイミング一覧:**

    | 依存配列 | 実行タイミング | 主な用途 |
    |---|---|---|
    | `[]`（空配列） | 初回マウント後のみ | 初期データ取得・外部ライブラリ初期化 |
    | `[dep1, dep2]` | dep1 または dep2 が変化するたびに | 依存値変化に伴う副作用 |
    | なし | 毎レンダリング後 | ほぼ使わない（パフォーマンス問題） |
    | クリーンアップ return | アンマウント時 or 次の effect 実行前 | タイマー停止・イベントリスナー解除 |

---

## 【Step 5：通信状態制御の実装】

> **対応テーマ**: ⑤ 通信成功／失敗を考慮した状態制御  
> **目標時間**: 2h

---

### Reducer での状態遷移（単体テストで検証済み参考）

> issue: 5-1〜5-5 の実装に含まれる `dispatch` パターンと、issue: 4-1〜4-5 の Reducer の `isLoading` 制御は、Step 6 の単体テストで自動検証されます。問題としての実装は不要です。  
> コードコメントと以下の解説を読んで動作の流れを理解してください。

- **dispatch パターン（Context → Reducer の流れ）:**

  ```typescript
  dispatch({ type: 'FETCH_START' })    // ① 通信開始: isLoading: true
  try {
    const data = await fetchInventory()
    dispatch({ type: 'FETCH_INVENTORY_SUCCESS', payload: data })  // ② 成功: isLoading: false
  } catch (e) {
    dispatch({
      type: 'FETCH_ERROR',
      payload: e instanceof Error ? e.message : 'エラーが発生しました'  // ③ 失敗: isLoading: false
    })
  }
  // isLoading: false は reducer 側の SUCCESS / ERROR case で設定する（finally は使わない）
  ```

- **動作確認（任意）:**  
  `npm run dev:full` でアプリを起動し、以下を操作して UI の変化を観察してください。

  - 画面をリロードする → 一覧取得中に「読み込み中...」が表示され、完了後に一覧が出れば `FETCH_START → FETCH_INVENTORY_SUCCESS` が正しく動いている
  - 入庫フォームで送信する → 送信中にフォームが `disabled`（操作不可）になり、完了後に緑のトーストが出ればOK
  - 意図的にサーバーを停止した状態で操作する → エラーメッセージが表示されれば `FETCH_ERROR` が正しく動いている

    > **サーバーの停止・再起動方法:**  
    > `npm run dev:full` を実行しているターミナルで `Ctrl + C` を押すとサーバーが停止します。  
    > その状態で画面をリロードや送信操作を行い、エラーメッセージが表示されることを確認してください。  
    > 確認後は同じターミナルで再度 `npm run dev:full` を実行すると再起動できます。

- **目的:**
  - reducer + dispatch パターンでの状態遷移の完全性を保証する方法を理解する

- **注意点:**
  - React の reducer パターンでは **各 action のハンドラーで `isLoading: false` を設定** します。`finally` は不要です。
  - `e instanceof Error` のチェックは TypeScript の `catch (e: unknown)` に対応するための安全な書き方です。

---

### UI への状態反映（実装済み参考）

> すべてスケルトンコード内に実装済みで提供されています。問題としての実装は不要です。  
> `src/components/InventoryList.tsx` と `src/components/StockForm.tsx` のコメントを参照して理解してください。

- **内容:**  

  **InventoryList.tsx:**
  1. `state.isLoading` が `true` のとき `id="loading-state"` の要素を表示する
  2. `state.isLoading` が `false` かつ `state.items.length === 0` のとき `id="empty-state"` の要素を表示する
  3. それ以外のとき `id="inventory-table"` のテーブルを表示する

  **StockForm.tsx:**
  1. 通信中（`state.isLoading === true`）はすべての `<select>`, `<input>`, `<button>` を `disabled={state.isLoading}` で無効化する（実装済み）
  2. 成功時のみフォームをリセットする（`state.error` が `null` の場合のみ）

- **目的:**
  - 条件付きレンダリング（`&&` 演算子）で複数の排他的状態を切り替える方法を理解する
  - `disabled` 属性の実装例（`disabled={state.isLoading}`）はスケルトン内に実装済みです。Tailwind の `disabled:` バリアント（`disabled:bg-gray-100`、`disabled:cursor-not-allowed` など）も参考にしてください。

---

## 【Step 6：APIモックを用いたテスト（単体テスト・UI テスト）】

> **対応テーマ**: ⑥ APIモック・Vitest  
> **目標時間**: 3.5h

---

> **テスト実装を始める前に確認してください。**  
> Step 1〜5 の実装コードがすべて完成した後、テストコードの実装に入る前に以下のコマンドを実行してください。
>
> ```bash
> npm run test -- run
> ```
>
> このコマンドを実行すると、**テストケースの一部が失敗します。これは想定内の動作です。**  
> テストファイルには「実装済み参考例（issue 番号なし）」と「実装課題（issue: XX-X）」の2種類が含まれています。  
> 「実装課題」のテストケースは `// TODO:` で `expect` が未記述のため pass しますが、**参考例として実装済みのテストケース**の中にはスケルトンコードの未実装部分に依存するものがあり、この段階では fail します。  
> **fail しているテストケースが、これから実装するべき対象です。** 参考例のテストがすべて pass するよう、各 issue を実装してください。  
> なお、Step 1〜5 の実装に問題がある場合は、それ以外のテストも fail します。

---

### テストの実行コマンド

テストはファイル単位で実行できます。`-- run` を付けることでウォッチモードを使わず 1 回実行して終了します。

```bash
# ファイル単位でのテスト実行（1回実行して終了）
npm run test -- run __tests__/unit/services/inventoryApi.spec.ts
npm run test -- run __tests__/unit/reducers/inventoryReducer.spec.ts
npm run test -- run __tests__/unit/contexts/InventoryContext.spec.tsx
npm run test -- run __tests__/ui/components/InventoryList.spec.tsx
npm run test -- run __tests__/ui/components/StockForm.spec.tsx
npm run test -- run __tests__/ui/components/ToastMessage.spec.tsx
npm run test -- run __tests__/ui/pages/InventoryPage.spec.tsx

# 全テスト一括実行
npm run test -- run
```

---

### モックを使う理由と作り方

テストでは実際の HTTP 通信や Context を使わずに「テスト対象だけ」を動作させる必要があります。このために **モック（Mock）** を使います。

**なぜモックが必要なのか:**

- **テストの独立性:** `fetch` が実際に通信すると、サーバーが起動していないと失敗します。モックに差し替えることで「ロジックだけ」を検証できます。
- **任意の状態の再現:** 成功・失敗・特定のデータなど、テストしたい状況を自由に作り出せます。
- **実行速度:** 実際の通信なしで即座に結果が返るためテストが高速です。

**Vitest でのモックの基本パターン:**

① **グローバル関数のモック（`vi.stubGlobal`）** — `fetch` のようなブラウザ組み込み関数を差し替えます。

```typescript
vi.stubGlobal('fetch', vi.fn());                               // 差し替え
vi.mocked(fetch).mockResolvedValue(makeResponse(data));        // 成功レスポンスを返すよう設定
vi.mocked(fetch).mockResolvedValue(makeResponse({}, 500));     // 500 エラーを返すよう設定
vi.unstubAllGlobals();                                         // テスト後に元に戻す
```

② **モジュールのモック（`vi.mock`）** — import したモジュール全体を自動モック化します。

```typescript
vi.mock('@/services/inventoryApi');                               // 自動モック化
vi.mocked(fetchInventory).mockResolvedValue([mockItem]);          // 成功を返すよう設定
vi.mocked(fetchInventory).mockRejectedValue(new Error('失敗'));  // エラーを返すよう設定
```

③ **モック関数（`vi.fn()`）** — 呼び出し内容を記録する関数を作成します。

```typescript
const mockFn = vi.fn();
expect(mockFn).toHaveBeenCalledTimes(1);             // 1回呼ばれたことを検証
expect(mockFn).toHaveBeenCalledWith(arg1, arg2);     // 引数を検証
```

> 詳細は問題文末尾の「補足: `vi.mocked` によるモックの作成について」も参照してください。

---

### 12. API 関数の単体テスト

- **問題:**  
  `__tests__/unit/services/inventoryApi.spec.ts` に、`fetchInventory()` のテストを実装してください。

- **詳細:**  

  1. **`vi.stubGlobal` による `fetch` のモック化:**（セットアップ）
      - `beforeEach` でグローバルの `fetch` を `vi.fn()` で作ったモック関数に差し替える
      - `afterEach` で `vi.unstubAllGlobals()` を呼んでリストアする

  2. **成功ケースのテスト:**（issue: 12-1）
      - モックが正常なレスポンスを返すよう `mockResolvedValue` で設定する
      - `fetchInventory()` が `InventoryItem` の配列を返すことを検証する

  3. **失敗ケースのテスト:**（issue: 12-2）
      - モックが 500 レスポンスを返すよう設定する
      - `fetchInventory()` が `Error` をスローすることを `rejects.toThrow()` で検証する

- **目的:**
  - `vi.stubGlobal` を用いたグローバル関数のモック化を学ぶ
  - 非同期関数のエラースローを `rejects.toThrow()` でテストする方法を学ぶ

- **ヒント:**
  ```typescript
  function makeResponse(body: unknown, status = 200): Response {
    return {
      ok: status >= 200 && status < 300,
      status,
      json: () => Promise.resolve(body),
    } as unknown as Response
  }
  ```

---

### 13. Reducer の単体テスト

- **問題:**  
  `__tests__/unit/reducers/inventoryReducer.spec.ts` に、`inventoryReducer` の状態遷移テストを実装してください。

- **詳細:**  

  1. **以下の3ケースをテストする:**
      - `FETCH_START` を dispatch したとき `isLoading` が `true` になり `error` が `null` になること（issue: 13-1）
      - `FETCH_INVENTORY_SUCCESS` を dispatch したとき `items` にデータが格納され `isLoading` が `false` になること（issue: 13-2）
      - `FETCH_ERROR` を dispatch したとき `error` にメッセージが格納され `isLoading` が `false` になること（issue: 13-3）

- **目的:**
  - reducer が純粋関数であるため、**実際にProviderをマウントせず** にロジックだけをテストできることを体験する
  - `input → output` の単純なテストで状態遷移を網羅する方法を学ぶ

- **注意点:**
  - reducer は純粋関数なので、`inventoryReducer(initialState, action)` を呼ぶだけでテストできます。モックは不要です。

- **ヒント:**
  - reducer のテストが簡単な理由を考えてみてください。

---

### 14. API 関数のリクエスト内容検証

- **問題:**  
  `__tests__/unit/services/inventoryApi.spec.ts` に、API 関数が「正しい URL・method・headers・body」で `fetch` を呼んでいることを検証するテストを追加してください。

- **詳細:**  

  1. **`fetchInventory` のリクエスト URL 検証:**（issue: 14-1）  
      - `fetchInventory()` を呼んだとき `fetch` が `'/api/inventory'` に呼ばれることを `toHaveBeenCalledWith` で検証する  
      - `fetch` は1回だけ呼ばれること（`toHaveBeenCalledTimes(1)`）も合わせて確認する

  2. **`receiveStock` のリクエスト URL・method・body 検証:**（実装済み参考例）  
      テストファイル内の「実装済み参考例」コメントが付いたテストを参照してください。  
      `receiveStock(1, { quantity: 5 })` を呼んだとき `fetch` が以下の引数で呼ばれることを検証しています。  
      ```typescript
      // ↓ 参考例（テストファイルの「実装済み参考例」コメント部分）
      await receiveStock(1, { quantity: 5 });
      expect(vi.mocked(fetch)).toHaveBeenCalledWith('/api/inventory/1/receive', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ quantity: 5 }),
      });
      ```

  3. **`createProduct` のリクエスト URL・method・body 検証:**（issue: 14-2）  
      - `createProduct({ name: '新商品', categoryId: 2, quantity: 3 })` を呼んだとき  
        - URL が `'/api/inventory'`  
        - `method: 'POST'`、`headers: { 'Content-Type': 'application/json' }`  
        - `body` が `JSON.stringify({ name: '新商品', categoryId: 2, quantity: 3 })` であることを検証する

- **目的:**
  - `vi.fn()` でモック化した関数の**呼び出し内容**（引数）を `toHaveBeenCalledWith` で検証するパターンを学ぶ
  - API 実装の「インターフェース契約」（URL・method・body）をテストで固定し、意図しない変更を検出できるようにする

- **注意点:**
  - `fetch` モックが成功レスポンスを返すよう `mockResolvedValue(makeResponse(someData))` で設定してから呼び出してください。
  - `toHaveBeenCalledWith` は**部分一致ではなく完全一致**なので、第2引数のオブジェクト構造を正確に指定してください。

- **ヒント:**
  ```typescript
  // fetch の呼び出し内容を検証する（createProduct の場合）
  await createProduct({ name: '新商品', categoryId: 2, quantity: 3 })
  expect(vi.mocked(fetch)).toHaveBeenCalledWith('/api/inventory', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ name: '新商品', categoryId: 2, quantity: 3 }),
  })
  ```

  > **参考例との対応:** `receiveStock` の検証パターン（テストファイルの「実装済み参考例」）と構造は同じです。URL・`body` に渡す値が `createProduct` 用になっている点だけが異なります。

---

### 15. Reducer の不変性・状態独立性の検証

- **問題:**  
  `__tests__/unit/reducers/inventoryReducer.spec.ts` に、reducer が **state を直接変更しない（immutable 更新）** ことと、**ある action が無関係のフィールドを変えない** ことを検証するテストを追加してください。

- **詳細:**  

  1. **不変性の検証：`RECEIVE_SUCCESS` で元の state は変更されないこと:**（issue: 15-1）  
      - `prev` として `items: [mockItem]` を持つ state を用意する  
      - `inventoryReducer(prev, { type: 'RECEIVE_SUCCESS', payload: updatedItem })` を呼ぶ  
      - 戻り値（`next`）は `prev` と**異なるオブジェクト参照**であること（`not.toBe(prev)`）を検証する  
      - `next.items` も `prev.items` と**異なる配列参照**であること（`not.toBe(prev.items)`）を検証する  
      - `prev.items[0].quantity` が元の値のまま変わっていないこと（副作用がないこと）を検証する

  2. **状態独立性の検証：`CLEAR_MESSAGES` が items・categories に影響しないこと:**（issue: 15-2）  
      - `prev` として `items: [mockItem]`、`categories: [mockCategory]`、`error: 'エラー'`、`successMessage: '成功'` を持つ state を用意する  
      - `CLEAR_MESSAGES` を dispatch した後  
        - `next.error` が `null` であること  
        - `next.successMessage` が `null` であること  
        - `next.items` が `prev.items` と**同じ参照**であること（`toBe(prev.items)`）を検証する  
        - `next.categories` が `prev.categories` と同じ参照であること（`toBe(prev.categories)`）を検証する

  3. **状態独立性の検証：`SET_SEARCH_QUERY` が items・categories・sortKey 等に影響しないこと:**（issue: 15-3）  
      - `initialState` に `SET_SEARCH_QUERY: 'キーワード'` を dispatch した後  
        - `next.searchQuery` が `'キーワード'` になること  
        - `next.items` が `initialState.items` と同じ参照であること  
        - `next.sortKey`・`next.sortOrder`・`next.categoryFilterId` が `initialState` と同じ値であること  
        を検証する

- **目的:**
  - React で重要な「immutable な状態更新」の概念をテストを通して体験する
  - `toBe`（参照一致）と `toEqual`（値一致）の違いを使い分ける理由を理解する
  - reducer の action が**スコープ外のフィールドを変えない**という設計を検証できることを学ぶ

- **ヒント:**
  ```typescript
  // 参照が異なることの検証（immutability）
  expect(next).not.toBe(prev)           // オブジェクトが新規作成されている
  expect(next.items).not.toBe(prev.items) // 配列が新規作成されている

  // 参照が同じことの検証（不必要なコピーをしていない）
  expect(next.items).toBe(prev.items)   // 変更対象外は同じ参照を使い回している
  ```

---

### 16. InventoryContext カスタムフックの単体テスト

- **問題:**  
  新しいテストファイル `__tests__/unit/contexts/InventoryContext.spec.tsx` を作成し、`renderHook` を使って `useInventory()` カスタムフックの動作を単体テストしてください。

- **詳細:**  

  1. **セットアップ — `@/services/inventoryApi` のモック化:**  
      - `vi.mock('@/services/inventoryApi')` でモジュールごとモックする  
      - `InventoryProvider` を `wrapper` として `renderHook` に渡すことで、Provider の外側でフックを呼ぶエラーを回避する

  2. **初期状態の検証:**（issue: 16-1）  
      - `renderHook(() => useInventory(), { wrapper: InventoryProvider })` を呼ぶ  
      - `result.current.state.items` が空配列であること  
      - `result.current.state.isLoading` が `false` であること  
      を検証する

  3. **`loadInventory` 成功時の検証:**（issue: 16-2）  
      - `vi.mocked(fetchInventory).mockResolvedValue([mockItem])` でモックを設定する  
      - `act()` 内で `result.current.loadInventory()` を呼ぶ  
      - 呼び出し後に `result.current.state.items` が `[mockItem]` になっていることを検証する  
      - `result.current.state.isLoading` が `false` になっていることも確認する

  4. **`loadInventory` エラー時の検証:**（issue: 16-3）  
      - `vi.mocked(fetchInventory).mockRejectedValue(new Error('取得失敗'))` でモックを設定する  
      - `act()` 内で `result.current.loadInventory()` を呼ぶ  
      - `result.current.state.error` が `'取得失敗'` になっていることを検証する  
      - `result.current.state.isLoading` が `false` になっていることも確認する

  5. **`clearMessages` の検証:**（issue: 16-4）  
      - まず `loadInventory()` をエラーで呼んで `state.error` に値をセットする  
      - 次に `act()` 内で `result.current.clearMessages()` を呼ぶ  
      - `state.error` と `state.successMessage` が両方 `null` になっていることを検証する

  6. **`receiveOrCreate` — 既存商品の入庫:**（issue: 16-5）  
      - `loadInventory()` でアイテムをロードした後、`receiveOrCreate('白Tシャツ', 5)` を呼ぶ  
      - `vi.mocked(receiveStock)` が `(1, { quantity: 5 })` の引数で呼ばれたことを `toHaveBeenCalledWith` で検証する  
      - 成功後に `state.successMessage` が `null` でないことを確認する

- **目的:**
  - `renderHook` + `act` を使った**カスタムフック専用のテスト手法**を学ぶ
  - `vi.mock()` でモジュール全体をモックし、`vi.mocked()` で型安全に操作するパターンを習得する
  - Context + Reducer の組み合わせが**非同期のアクション関数も含めてテスト可能**であることを体験する

- **注意点:**
  - `act()` は非同期処理を含む場合 `await act(async () => { ... })` の形にしてください。
  - `renderHook` の `wrapper` に `InventoryProvider` を渡すことで、フック内の `useContext(InventoryContext)` が正しく動作します。
  - `vi.mocked(fetchInventory)` で型安全なモック参照を取得できます。

- **ヒント:**
  ```typescript
  import { renderHook, act } from '@testing-library/react'
  import { vi, describe, it, expect, beforeEach } from 'vitest'
  import { useInventory, InventoryProvider } from '@/contexts/InventoryContext'
  import { fetchInventory, receiveStock } from '@/services/inventoryApi'

  vi.mock('@/services/inventoryApi')

  describe('useInventory()', () => {
    beforeEach(() => {
      vi.resetAllMocks()
    })

    it('初期状態が正しいこと', () => {
      const { result } = renderHook(() => useInventory(), {
        wrapper: InventoryProvider,
      })
      expect(result.current.state.items).toEqual([])
    })

    it('loadInventory 成功時に items が更新されること', async () => {
      vi.mocked(fetchInventory).mockResolvedValue([mockItem])
      const { result } = renderHook(() => useInventory(), {
        wrapper: InventoryProvider,
      })
      await act(async () => {
        await result.current.loadInventory()
      })
      expect(result.current.state.items).toEqual([mockItem])
    })
  })
  ```

---

### 17. コンポーネント UI テスト

- **問題:**  
  以下の3つのコンポーネントテストファイルに、指定のテストケースを実装してください。

- **詳細:**  

  **`__tests__/ui/components/InventoryList.spec.tsx`（5ケース）:**
  1. `items` が空のとき `#empty-state` が表示される（issue: 17-1）
  2. `items` があるとき `#inventory-table` に商品名が表示される（issue: 17-2）
  3. categories に応じたカテゴリ名（または `カテゴリ{id}`）が表示される（issue: 17-3）
  4. `quantity <= LOW_STOCK_THRESHOLD` の商品行に「在庫少」バッジと `is-low-stock` クラスが付く（issue: 17-4）
  5. `#search-input` に商品名を入力すると一覧が絞り込まれる（issue: 17-5）

  **`__tests__/ui/components/StockForm.spec.tsx`（2ケース）:**
  1. 商品名が未入力のまま送信すると `#validation-error` にエラーが表示される（issue: 17-6）
  2. 商品名と数量を入力して送信すると `receiveOrCreate()` が正しい引数で呼ばれる（issue: 17-7）

  **`__tests__/ui/components/ToastMessage.spec.tsx`（2ケース）:**
  1. `successMessage` がセットされると `#toast-success` が表示される（issue: 17-8）
  2. `vi.useFakeTimers()` を使い、`successMessage` 変化から 3 秒後に `clearMessages()` が呼ばれることを検証する（issue: 17-9）

- **目的:**
  - `@testing-library/react` でコンポーネントをレンダリングし、UI の表示パターンをテストする方法を学ぶ
  - `vi.useFakeTimers()` で時間依存のテストを実際に待たずに実施する方法を理解する

- **注意点:**
  - テスト用の Context Provider をラップして、任意の初期状態でコンポーネントをテストしてください。
  - `vi.useFakeTimers()` を使った後は `afterEach` で `vi.useRealTimers()` を呼んで元に戻してください。

- **ヒント:**
  - `@testing-library/react` の基本パターン:
    ```typescript
    import { render, screen, fireEvent } from '@testing-library/react'
    
    test('...', () => {
      render(<MyComponent />, { wrapper: TestProvider })
      expect(screen.getByTestId('loading-state')).toBeInTheDocument()
    })
    ```

---

### 18. ページコンポーネントの UI テスト

- **問題:**  
  `__tests__/ui/pages/InventoryPage.spec.tsx` に、`InventoryPage` コンポーネントのマウント時の挙動をテストしてください。

- **詳細:**  

  1. **`loadInventory` が1回呼び出されることの検証:**（実装済み参考）  
      - テストファイルの参考実装を確認してください。

  2. **`loadCategories` が1回呼び出されることの検証:**（issue: 18-1）  
      - `useInventory` をモック化し、`loadCategories` に `vi.fn()` を渡す  
      - `loadCategories` が `toHaveBeenCalledTimes(1)` であることを検証する

  3. **`loadInventory` と `loadCategories` の両方が1回ずつ呼び出されることの検証:**（issue: 18-2）  
      - 両関数をそれぞれ `vi.fn()` でモック化し、レンダリング後に両方が `toHaveBeenCalledTimes(1)` であることを検証する

- **目的:**
  - ページコンポーネントの `useEffect` によるマウント時の副作用をテストする方法を学ぶ
  - `vi.mock` で `useInventory` 全体をモック化することで、Context Provider なしでページをテストできることを理解する

- **注意点:**
  - `InventoryList`・`StockForm`・`ToastMessage` は本テストの関心外のため、スタブに差し替え済みです（セットアップ部分を参照）。
  - `MemoryRouter` でラップすることで React Router のコンテキストを提供してください。

- **ヒント:**
  ```typescript
  vi.mock('@/contexts/InventoryContext', () => ({
    useInventory: vi.fn(),
  }))

  vi.mocked(useInventory).mockReturnValue({
    state: { ...initialState },
    dispatch: vi.fn(),
    loadInventory: vi.fn(),
    loadCategories: vi.fn(),
    receiveOrCreate: vi.fn(),
    ship: vi.fn(),
    clearMessages: vi.fn(),
  })

  render(<InventoryPage />, { wrapper: MemoryRouter })
  expect(loadInventory).toHaveBeenCalledTimes(1)
  ```

---

> ### 📘 補足：`vi.mocked` によるモックの作成について
>
> テストファイルのセットアップ部分（`vi.mock(...)` と `vi.mocked(...)` を使っている箇所）は、あらかじめ実装済みで提供されています。
> ここでは、なぜこう書くのかを「単体テスト」と「UI テスト」のそれぞれについて解説します。
>
> ---
>
> #### 🔬 単体テスト（`InventoryContext.spec.tsx`）での `vi.mocked` の使い方
>
> **テスト対象:** `useInventory()` カスタムフック（`InventoryContext.tsx`）  
> **モック対象:** フックが内部で呼ぶ API 関数（`fetchInventory`・`receiveStock` など）
>
> 単体テストでは、**「Hook が API を正しく呼んで state を更新するか」** を検証します。  
> そのため、実際の HTTP 通信は行わず、API 関数だけをモックに差し替えます。
>
> ```typescript
> // ① モジュール全体を自動モックに差し替える
> // vi.mock() は巻き上げ（hoisting）されるため、import より前に実行される
> vi.mock('@/services/inventoryApi')
>
> // ② vi.mocked() で型安全なモック参照を取得し、戻り値を設定する
> //    vi.mocked() は「この関数はモックだよ」とTypeScriptに教えるためのラッパー
> //    （モックされた関数には .mockResolvedValue() などのメソッドが生えている）
> vi.mocked(fetchInventory).mockResolvedValue([mockItem])
> //  └── 成功パターン: fetchInventory() を呼ぶと [mockItem] で resolve する Promise を返す
>
> vi.mocked(fetchInventory).mockRejectedValue(new Error('取得失敗'))
> //  └── 失敗パターン: fetchInventory() を呼ぶと Error で reject する Promise を返す
>
> // ③ renderHook でフックを実行し、state の変化を検証する
> const { result } = renderHook(() => useInventory(), { wrapper: InventoryProvider })
> await act(async () => {
>   await result.current.loadInventory()
> })
> expect(result.current.state.items).toEqual([mockItem])
> ```
>
> **ポイント:** モックするのは「依存している API 関数」のみ。フック本体（useInventory）は**本物**が動く。
>
> ---
>
> #### 🖥️ UI テスト（`InventoryList.spec.tsx` など）での `vi.mocked` の使い方
>
> **テスト対象:** `<InventoryList />` などのコンポーネント  
> **モック対象:** コンポーネントが呼ぶ `useInventory()` フック全体
>
> UI テストでは、**「与えられた state に対してコンポーネントが正しく表示されるか」** を検証します。  
> API 通信はもちろん、Context Provider のセットアップも不要です。  
> `useInventory` が返す値を丸ごと差し替えることで、任意の state をコンポーネントに渡せます。
>
> ```typescript
> // ① useInventory を含むモジュールをモック化する
> //    ファクトリ関数を渡すことで「useInventory = vi.fn()」に差し替える
> vi.mock('@/contexts/InventoryContext', () => ({
>   useInventory: vi.fn(),
>   //             └── vi.fn() = 「何を返すかは後で指定する空のモック関数」
> }))
>
> // ② 各テストで mockReturnValue() を使って「このテストで useInventory が返す値」を指定する
> //    コンポーネントが useInventory() を呼ぶと、ここで指定したオブジェクトが返ってくる
> vi.mocked(useInventory).mockReturnValue({
>   state: { ...initialState, isLoading: false, items: mockItems, categories: mockCategories },
>   dispatch: vi.fn(),
>   loadInventory: vi.fn(),
>   loadCategories: vi.fn(),
>   receiveOrCreate: vi.fn(),
>   ship: vi.fn(),
>   clearMessages: vi.fn(),
> })
>
> // ③ コンポーネントをレンダリングするだけでよい（Provider のラップ不要）
> render(<InventoryList />)
> expect(screen.getByText('白Tシャツ')).toBeInTheDocument()
> ```
>
> **ポイント:** モックするのは「useInventory フック全体」。Context Provider や API 通信は一切関与しない。  
> `mockReturnValue()` でテストごとに state を自由に差し替えられるため、ローディング中・エラー・正常表示などの状態を手軽に再現できる。
>
> ---
>
> #### 📊 2種類のモックの比較
>
> | 比較項目 | 単体テスト（InventoryContext.spec.tsx） | UI テスト（InventoryList.spec.tsx 等） |
> |---|---|---|
> | テスト対象 | `useInventory()` フックのロジック | コンポーネントの表示・操作 |
> | モック対象 | API 関数（`fetchInventory` など） | `useInventory()` フック全体 |
> | モック手段 | `vi.mock('@/services/inventoryApi')` | `vi.mock('@/contexts/InventoryContext', ...)` |
> | 戻り値指定 | `.mockResolvedValue()` / `.mockRejectedValue()` | `.mockReturnValue()` |
> | Provider | `InventoryProvider` を `wrapper` として使う | 不要（フックごと差し替えるため） |
> | 主な検証内容 | state の値・API の呼び出し回数・引数 | DOM に表示される要素・クラス・テキスト |
>
> **どちらの `vi.mocked` も「本物の実装を差し替えて、テストしたい部分だけを動かす」という目的は同じです。**  
> 差し替えるレイヤーが「API 関数」か「フック全体」かが異なる点がポイントです。


