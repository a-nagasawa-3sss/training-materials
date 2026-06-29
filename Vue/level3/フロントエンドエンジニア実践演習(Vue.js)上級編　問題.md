> 更新日：2026/04/03
> バージョン: 1.0
# Vue 3 上級編 — 在庫管理UI 演習問題

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
| Step 1 開始前（スケルトンそのまま） | ❌ **白画面** | `stores/inventory.ts` が `receiveStock` / `shipStock` を import しているが、これらは `inventoryApi.ts` にまだエクスポートされていない。ES モジュールのリンク段階でエラーとなりアプリ全体がロードされない |
| Step 1（issue 2-1・2-2）実装後 | ⚠️ **一部クラッシュ** | state はスケルトンに実装済みのためアプリは起動する。ただし `StockForm.vue` の入庫フォームを開くと `matchedItem` / `selectedItem` が未宣言のため `ReferenceError` が発生してフォームがクラッシュ |
| Step 3（issue 5-5・5-6）実装後 | ✅ **全画面正常表示** | すべての変数が宣言され、クラッシュは完全に解消される |

**なぜこの順序でクラッシュが解消されるのか:**

1. **issue 2-1・2-2（`receiveStock` / `shipStock` のエクスポート）を実装する**と、`stores/inventory.ts` の import が解決され、アプリのモジュールグラフが完成する。state 変数（`items` ・ `categories` 等）はスケルトンに実装済みのため、即座にアプリが起動できる。
2. **issue 5-5・5-6（`selectedItem` / `matchedItem` の宣言）を実装する**と、入庫フォームの template が参照する変数がすべて揃い、フォーム画面のクラッシュも解消される。

> Step 1 実装中は開発サーバーを起動しても確認できません。issue 2-1・2-2 を実装した後に `npm run dev:full` で動作確認してください。

**各クラッシュ解消後の確認ポイント:**

**issue 5-5・5-6 実装直後（全タブ確認可）:**
- 「入庫」タブを開いてもクラッシュしないことを確認する
- フォームの各入力欄（商品名・カテゴリ・数量）が表示されることを確認する
- この時点では issue 3-2～3-5 / 7-1 が未実装のため、送信しても API は呼ばれない（正常）

**Step 2（issue 3-1～3-5）完了後（状態管理が機能する）:**
- 「在庫一覧」タブ: ページ読み込み時に在庫データが表示されるようになる（issue 7-1 実装後）
- 「入庫」「出庫」タブ: フォーム送信後にトースト通知が表示され、在庫一覧が更新されることを確認する
- ブラウザの開発者ツール（F12）→「Network」タブで、`/api/inventory` への GET / POST リクエストが発生していることを確認する

---

## 【Step 1：型定義と API 関数の実装】

> **対応テーマ**: ④ REST API 連携  
> **目標時間**: 2h

---

### 1. 型定義ファイルの実装

- **問題:**  
  `src/types/inventory.ts` に、アプリ全体で使用する型定義を実装してください。

- **詳細:**  
  以下の型をファイルに定義してください。

  > **注意:** `InventoryItem`・`InventoryListResponse`・`Category` の3つはスケルトンに実装済み参考例として記載されています。`// TODO:` コメントが付いている型（issue: 1-1〜1-7）のみ実装してください。

  1. **在庫アイテム型の定義:**（issue: 1-1）
      - `InventoryItem` インターフェース: `id: number`, `name: string`, `categoryId: number`, `quantity: number`, `updatedAt: string`

  2. **カテゴリ一覧レスポンス型の定義:**（issue: 1-2）
      - `CategoryListResponse` — `Category` の配列型

  3. **新規商品登録リクエスト型の定義:**（issue: 1-3）
      - `CreateProductRequest` — `name: string`, `categoryId: number`, `quantity: number`

  4. **入庫リクエスト型の定義:**（issue: 1-4）
      - `ReceiveRequest` — `quantity: number`

  5. **出庫リクエスト型の定義:**（issue: 1-5）
      - `ShipRequest` — `quantity: number`

  6. **操作レスポンス型の定義:**（issue: 1-6）
      - `StockOperationResponse` — `success: boolean`, `item: InventoryItem`

  7. **新規商品登録レスポンス型の定義:**（issue: 1-7）
      - `CreateProductResponse` — `success: boolean`, `item: InventoryItem`

- **目的:**
  - API のリクエスト・レスポンスの形を TypeScript の `interface` / `type` で定義する
  - 型定義を一か所に集中させることで、ストア・サービス・コンポーネントの全層で型の恩恵を受けられるようにする

- **注意点:**
  - すべての型を `export` してください。他のファイルから参照できるようにする必要があります。
  - `interface` と `type` の使い分けは任意ですが、拡張可能なオブジェクト型には `interface` を使うのが一般的です。

- **ヒント:**
  - `res.json()` を `as Promise<InventoryListResponse>` とキャストしているのはなぜでしょうか？（TypeScript が `fetch` の戻り値を `any` と推論することと関係しています）

---

### 2. API 関数の実装

- **問題:**  
  `src/services/inventoryApi.ts` に、バックエンド API と通信する関数群を実装してください。

- **詳細:**  
  はじめに型のインポートを確認してください。続ける5つの関数のうち、`fetchInventory`・`fetchCategories`・`createProduct` の3つは実装済み参考例です。`receiveStock` と `shipStock` の2つをコードコメントに従って実装してください。各関数は `fetch` を用いて HTTP 通信を行います。

  **〈準備〉型のインポート:**
  - `@/types/inventory` から API で使用する型をすべて `import type` してください
  - インポートする型: `InventoryListResponse`, `CategoryListResponse`, `CreateProductRequest`, `CreateProductResponse`, `ReceiveRequest`, `ShipRequest`, `StockOperationResponse`

  1. **`fetchInventory()`** — `GET /api/inventory`（実装済み参考例）
      - 戻り値の型: `Promise<InventoryListResponse>`
      - `fetch` を使い `${BASE}/inventory` へ GET リクエストを送る
      - `res.ok` が `false` の場合、`Error` をスロー（例: `在庫一覧の取得に失敗しました (${res.status})`）
      - 成功したら `res.json() as Promise<InventoryListResponse>` を返す

  2. **`fetchCategories()`** — `GET /api/categories`（実装済み参考例）
      - 戻り値の型: `Promise<CategoryListResponse>`
      - `fetch` を使い `${BASE}/categories` へ GET リクエストを送る
      - `res.ok` が `false` の場合、`Error` をスロー（例: `カテゴリ一覧の取得に失敗しました (${res.status})`）
      - 成功したら `res.json() as Promise<CategoryListResponse>` を返す

  3. **`createProduct(payload: CreateProductRequest)`** — `POST /api/inventory`（実装済み参考例）
      - 戻り値の型: `Promise<CreateProductResponse>`
      - `method: 'POST'`、`headers: { 'Content-Type': 'application/json' }`、`body: JSON.stringify(payload)` を設定する
      - `res.ok` が `false` の場合、`Error` をスロー（例: `商品登録に失敗しました (${res.status})`）
      - 成功したら `res.json() as Promise<CreateProductResponse>` を返す

  4. **`receiveStock(id: number, payload: ReceiveRequest)`** — `POST /api/inventory/:id/receive`（issue: 2-1）
      - 戻り値の型: `Promise<StockOperationResponse>`
      - `method: 'POST'`、`headers: { 'Content-Type': 'application/json' }`、`body: JSON.stringify(payload)` を設定する
      - `res.ok` が `false` の場合、`res.json().catch(() => ({}))` でエラーボディをパースし、`message` プロパティがあればそれを、なければデフォルト文言が入った `Error` をスローする（例: `入庫登録に失敗しました (${res.status})`）
      - 成功したら `res.json() as Promise<StockOperationResponse>` を返す

  5. **`shipStock(id: number, payload: ShipRequest)`** — `POST /api/inventory/:id/ship`（issue: 2-2）
      - 戻り値の型: `Promise<StockOperationResponse>`
      - `method: 'POST'`、`headers: { 'Content-Type': 'application/json' }`、`body: JSON.stringify(payload)` を設定する
      - `res.ok` が `false` の場合、`res.json().catch(() => ({}))` でエラーボディをパースし、`message` プロパティがあればそれを、なければデフォルト文言が入った `Error` をスローする（例: `出庫登録に失敗しました (${res.status})`）
      - 成功したら `res.json() as Promise<StockOperationResponse>` を返す

- **目的:**
  - `fetch` の低レベルな処理（URL 組み立て・ヘッダー設定・ステータスチェック・JSON 変換）をこのファイルに集約する
  - ストアがHTTP通信の詳細を知らなくて済む「関心の分離」を実現する

- **注意点:**
  - ベース URL の定数 `const BASE = '/api'` は `src/services/inventoryApi.ts` の先頭付近（インポートブロックの直後）に定義済みです。各関数内で `${BASE}/...` として使用してください。
  - `res.ok` が `false` の場合は必ず `throw new Error(...)` してください。呼び出し元のストアでエラーを`catch` できるようにするためです。
  - POST 系リクエストには必ず `headers: { 'Content-Type': 'application/json' }` と `body: JSON.stringify(payload)` を付けてください。

- **ヒント:**
  - `services/inventoryApi.ts` を作らずにストアに直接 `fetch` を書いた場合、何が問題になりますか？変更するファイルの数と、テストのしやすさの観点から考えてみてください。
  - GET リクエストの基本構造:
    ```typescript
    const res = await fetch(`${BASE}/...`)
    if (!res.ok) throw new Error(`エラーメッセージ (${res.status})`)
    return res.json() as Promise<型名>
    ```

---

## 【Step 2：Pinia ストアの実装】

> **対応テーマ**: ② 状態管理  
> **目標時間**: 3h

---

### 3. ストアのアクション実装

- **問題:**  
  `src/stores/inventory.ts` に、以下のアクション（関数）を実装してください。

- **詳細:**  

  1. **`clearMessages()` 関数:**（issue: 3-1）
      - `error` と `successMessage` を両方 `null` にリセットする

  2. **`loadInventory()` 関数:**（issue: 3-2）
      - `isLoading` を `true` にして通信開始
      - `clearMessages()` を呼んで前回のメッセージをリセット
      - `fetchInventory()` を呼んで `items` に結果を格納
      - 失敗した場合は `error` にエラーメッセージを格納
      - `finally` で `isLoading` を `false` に戻す

  3. **`loadCategories()` 関数:**（issue: 3-3）
      - `fetchCategories()` を呼んで `categories` に結果を格納

  4. **`receive(id, quantity)` 関数:**（issue: 3-6）
      - `isLoading` を `true` にして通信開始
      - `clearMessages()` を呼んで前回のメッセージをリセット
      - `receiveStock()` を呼ぶ
      - 成功したら `items` 内の対象商品を `result.item` で上書きし、`successMessage` をセット
      - 失敗したら `error` にメッセージをセット
      - `finally` で `isLoading` を `false` に戻す

  5. **`ship(id, quantity)` 関数:**（issue: 3-4）
      - `isLoading` を `true` にして通信開始
      - `clearMessages()` を呼んで前回のメッセージをリセット
      - `shipStock()` を呼ぶ
      - 成功したら `items` 内の対象商品を `result.item` で上書きし、`successMessage` をセット
      - 失敗したら `error` にメッセージをセット
      - `finally` で `isLoading` を `false` に戻す

  6. **`receiveOrCreate(name, quantity, categoryId?)` 関数:**（issue: 3-5）
      - `isLoading` を `true` にして通信開始
      - `clearMessages()` を呼んで前回のメッセージをリセット
      - `items` の中に `name` と一致する商品があれば `receiveStock()` を呼び、`items` の該当要素を `result.item` で上書きする
      - 一致する商品がなければ `createProduct({ name, categoryId!, quantity })` で在庫数を直接指定して新規登録し、`items` に push する
      - 成功したら `successMessage` をセット
      - 失敗したら `error` にメッセージをセット
      - `finally` で `isLoading` を `false` に戻す

- **目的:**
  - Pinia のセットアップ形式でアクション（`async function`）を定義する方法を学ぶ
  - `try/catch/finally` を用いた非同期処理の状態制御パターンを習得する

- **注意点:**
  - `finally` を省略すると、エラー発生時に `isLoading` が `true` のまま残ります。必ず `finally` で `false` に戻してください。
  - `receiveOrCreate` は「既存商品への加算」と「新規商品の登録+加算」の2ケースがあります。`items.find()` で商品が存在するか確認してください。
  - 新規商品登録時は `createProduct({ name, categoryId!, quantity })` で入庫数を初期在庫として直接指定して登録し、`items` に push してください。続けて `receiveStock()` を呼ぶ必要はありません。

- **共通実装パターン（`receive` / `ship` / `receiveOrCreate` 共通）:**

  `receive` / `ship` / `receiveOrCreate` はすべて以下の骨格で実装します。  
  API 呼び出し部分と items の更新方法・成功メッセージだけが3つで異なります。

  ```typescript
  async function actionName(...args) {
      isLoading.value = true;         // ① ローディング ON
      clearMessages();                // ② 前回メッセージをリセット
      try {
          const result = await API関数(引数);                              // ③ API 呼び出し
          items.value[index] = result.item;  // または items.value.push(…)  // ④ items を更新
          successMessage.value = '成功メッセージ';                          // ⑤ 成功メッセージ
      } catch (e) {
          error.value = e instanceof Error ? e.message : 'デフォルトメッセージ'; // ⑥ エラーをセット
      } finally {
          isLoading.value = false;    // ⑦ ローディング OFF（必ず実行）
      }
  }
  ```

- **ヒント:**
  - `try/catch` だけで `finally` を使わない場合、どのような問題が起きますか？
  - Pinia を使わずに `props` と `emit` だけで複数コンポーネント間の状態共有を実現しようとすると、何が大変になりますか？

---

## 【Step 3：コンポーネントの実装】

> **対応テーマ**: ① Composition API によるロジック分離  
> **目標時間**: 4.5h

---

### 4. 在庫一覧コンポーネントの実装

- **問題:**  
  `src/components/InventoryList.vue` の `<script setup>` を実装してください。

- **詳細:**  

  1. **ストアの取得:**（スケルトン参考例として提供済み）
      - `useInventoryStore()` でストアを取得する

  2. **ストアとの v-model 連携（`computed` get/set）:**（issue: 4-1）
      - `searchQuery`・`categoryFilterId` は `computed` の `get/set` パターンで定義し、テンプレートで `v-model` として使えるようにする

  3. **`categoryName` 関数の実装:**（issue: 4-2）
      - カテゴリ ID を受け取り、`store.categories.find()` で一致するカテゴリ名を返す（見つからなければ `カテゴリ${id}` を返す）

  4. **ソート状態の読み取り（`computed` get のみ）:**（スケルトン参考例として提供済み）
      - `sortKey`・`sortOrder` は `get` のみの `computed` として定義する（直接変更は `toggleSort()` 経由）

  5. **絞り込み＋ソート（`computed`）の実装:**（issue: 4-3）
      - `filteredItems` を `computed()` で定義する（絞り込みとソートを一つの算出プロパティにまとめる）
      - `searchQuery` による商品名の部分一致フィルタリング（空文字はスキップ）
      - `categoryFilterId` によるカテゴリ絞り込み（`null` はスキップ）
      - `sortKey` / `sortOrder` によるソート（`'asc'` なら昇順・`'desc'` なら降順）

  6. **`toggleSort(key)` 関数の実装:**（issue: 4-4）
      - 同じ列を再クリックしたら `store.sortOrder` を `'asc'` ⇔ `'desc'` で反転する
      - 別の列をクリックしたら `store.sortKey` を切り替え、`store.sortOrder` を `'asc'` にリセットする

  7. **在庫少バッジの判定:**（issue: 4-5 ※テンプレートの実装）
      - `LOW_STOCK_THRESHOLD`（= 10）は `src/stores/inventory.ts` から `import` 済みです
      - `v-for` 行の `:class` バインディングで `item.quantity <= LOW_STOCK_THRESHOLD` を判定し、`is-low-stock` クラス（黄色背景）を付ける
      - 在庫数セル内の `v-if` で同条件を判定し、`badge-low-stock` クラスの「在庫少」バッジを表示する

- **目的:**
  - `computed()` の get/set パターンを理解し、ストアの値を `v-model` にバインドする方法を学ぶ
  - `<script setup>` にロジックを集約し、`<template>` は結果を表示するだけにする責務分離を実践する

- **注意点:**
  - `computed()` で返す値を直接変更することはできません。ストアの値を変更したい場合は `set` で実装してください。
  - `filteredItems` のソートは **元の配列を破壊しない** ように注意してください（`[...array].sort(...)` を使う）。
  - `sortKey` と `sortOrder` はテンプレートから直接 `v-model` で変更せず、テーブルヘッダーの `click` イベントから `toggleSort()` を呼んで変更します。

- **ヒント:**
  - `ref()` と `computed()` の違いを説明できますか？
  - `computed` の get/set パターン:
    ```typescript
    const searchQuery = computed({
      get: () => store.searchQuery,
      set: (v) => { store.searchQuery = v },
    })
    ```

---

### 5. 在庫フォームコンポーネントの実装

- **問題:**  
  `src/components/StockForm.vue` の `<script setup>` を実装してください。

- **詳細:**  

  1. **Props の定義:**（issue: 5-1）
      - `mode: 'receive' | 'ship'` を `defineProps` で受け取る

  2. **入庫フォーム用 `ref` の定義:**（スケルトン参考例として提供済み）
      - `receiveSelectId` — 「既存商品から選択」セレクトの商品 ID（`number | null`、初期値: `null`）
      - `productName` — 商品名テキスト入力（`string`、初期値: `''`）
      - `selectedCategoryId` — カテゴリ選択（`number | null`、初期値: `null`）

  3. **`watch` — `receiveSelectId` 変化時の自動入力:**（issue: 5-3）
      - `receiveSelectId` が変化したとき `productName`・`selectedCategoryId` を自動入力する

  4. **出庫・共通 `ref` の定義:**（スケルトン参考例として提供済み）
      - `selectedId` — 出庫フォームの商品 ID（`number | null`、初期値: `null`）
      - `quantity` — 数量入力（`number | null`、初期値: `null`）
      - `validationError` — エラーメッセージ（`string | null`、初期値: `null`）

  5. **`selectedItem` computed の実装:**（issue: 5-5）
      - `selectedId` から出庫対象の商品オブジェクトを返す（在庫上限チェック用）

  6. **`matchedItem` computed の実装:**（issue: 5-6）
      - `productName` を `store.items` と完全一致検索し、一致した商品を返す
      - 一致した場合 → 既存商品への加算入庫、`null` の場合 → 新規商品として登録する

  7. **`validate()` 関数の実装:**（issue: 5-7）
      - 入庫モード: 商品名が空の場合・新規商品でカテゴリ未選択の場合にエラー
      - 出庫モード: 商品未選択の場合・在庫数超過の場合にエラー
      - 数量が 1 未満の場合にエラー（共通）

  8. **`submit()` 関数の実装:**（issue: 5-8）
      - `validate()` が `false` の場合は処理を中断する
      - 入庫: `store.receiveOrCreate(productName, quantity, categoryId)` を呼ぶ
      - 出庫: `store.ship(selectedId, quantity)` を呼ぶ
      - 成功した場合のみフォームをリセットする（`store.error` が `null` の場合）

- **目的:**
  - `defineProps` による型安全な Props 定義を学ぶ
  - バリデーションロジックを `validate()` 関数に切り出し、`submit()` から呼ぶ責務分離を実践する

- **注意点:**
  - バリデーション関数をなぜ `submit()` の外に切り出しているのでしょうか？再利用性とテストのしやすさを考えてみてください。
  - 送信失敗時はフォームの入力値を残してください（ユーザーが修正して再送信できる UX）。

- **ヒント:**
  - Options API（`data`, `methods`, `computed`）と比べて `<script setup>` の何が違いますか？
  - `validate()` をなぜ `submit()` の外に関数として切り出しているのでしょうか？

---

### 6. トーストメッセージコンポーネントの実装

- **問題:**  
  `src/components/ToastMessage.vue` の `<script setup>` を実装してください。

- **詳細:**  

  1. **ストアの取得:**（issue: 6-1）
      - `useInventoryStore()` でストアを取得する

  2. **`watch` による自動消去:**（issue: 6-2）
      - `store.successMessage` を監視し、メッセージがセットされたら3秒後に `store.clearMessages()` を呼ぶ `watch` を実装する

- **目的:**
  - `watch` を用いてストアの状態変化に反応した副作用（タイマー起動）を実装する
  - トーストの表示ロジックをこのコンポーネントにカプセル化する

- **注意点:**
  - `watch` の第一引数には `() => store.successMessage` というゲッター関数を渡してください。`store.successMessage` を直接渡すのとの違いはなんでしょうか？考えてみてください。
  - `watch` はコンポーネントのアンマウント時に自動でクリーンアップされます。`onUnmounted` で手動停止する必要はありません。

- **ヒント:**
  - `store.successMessage` を変化前と変化後で比較したい場合、`watch` の第2引数にどう書けばよいですか？

---

## 【Step 4：ライフサイクルの統合】

> **対応テーマ**: ③ ライフサイクル理解  
> **目標時間**: 1h

---

### 7. 初期データ取得の実装

- **問題:**  
  `src/views/InventoryView.vue` に、コンポーネントマウント時に在庫一覧とカテゴリを取得する処理と、テンプレートのバインディングを実装してください。

- **詳細:**  

  1. **`onMounted` の実装:**（issue: 7-1）
      - `onMounted()` を呼び出し、`async` コールバックを渡す
      - コールバック内で `store.loadInventory()` と `store.loadCategories()` を呼ぶ（`await` あり・なしどちらも正解）

  2. **タブのアクティブスタイル切り替え:**（issue: 7-2）
      - タブボタンの `:class` に配列形式で静的クラスと動的クラスを指定する
      - `activeTab === tab.key` のとき `'border-green-500 text-green-600 is-active'`、それ以外は `'border-transparent text-gray-500 hover:text-gray-700'` を付ける

  3. **タブクリックでのタブ切り替え:**（issue: 7-3）
      - タブボタンに `@click` で `activeTab = tab.key` をセットする

  4. **タブパネルの表示切り替え:**（issue: 7-4）
      - `#tab-panel-list` に `v-if="activeTab === 'list'"` を追加する
      - `#tab-panel-receive` に `v-else-if="activeTab === 'receive'"` を追加する
      - `#tab-panel-ship` に `v-else-if="activeTab === 'ship'"` を追加する

  5. **再読み込みボタンの実装:**（issue: 7-5）
      - `:disabled="store.isLoading"` でローディング中はボタンを無効化する
      - `@click="store.loadInventory()"` でクリック時に在庫データを再取得する

- **目的:**
  - `onMounted` がいつ発火するかを理解する
  - 初回データ取得を `onMounted` で行う理由（`<script setup>` トップレベルとの違い）を理解する
  - `:class` に配列形式で静的・動的クラスを組み合わせる方法を理解する
  - `v-if` / `v-else-if` による排他的な条件分岐レンダリングを実装する
  - `:disabled` / `@click` による属性バインディングとイベントハンドリングを実装する

- **注意点:**
  - `<script setup>` のトップレベルに直接 `store.loadInventory()` を書かないでください。コンポーネントが構築される段階（DOM が確定する前）で副作用を起こすことを避けるためです。
  - `v-if` / `v-else-if` / `v-else` は同じ親要素の直下に連続して並べる必要があります。間に別の要素を挟むと機能しません。
  - `:class` に配列を渡すと、配列の各要素がクラスとして結合されます。文字列・オブジェクト・三項演算子を混在させることができます。

- **ヒント:**
  - `onUnmounted` はどのような場面で使う必要が出てきますか？（イベントリスナー・外部購読のクリーンアップなど）
  - `:class` の配列形式と三項演算子の組み合わせ:
    ```html
    :class="['固定クラス', 条件 ? 'trueのクラス' : 'falseのクラス']"
    ```

  - **Vue 3 ライフサイクルフック一覧（Composition API）:**

    | フック | 発火タイミング | 主な用途 |
    |---|---|---|
    | `onBeforeMount` | DOM 生成直前（仮想 DOM は完成済み） | レンダリング直前の準備処理 |
    | `onMounted` | DOM への挿入完了直後 | 初期データ取得・DOM 操作・外部ライブラリの初期化 |
    | `onBeforeUpdate` | リアクティブ状態変化に伴う DOM 再描画の直前 | 更新前の DOM 値の記録 |
    | `onUpdated` | DOM 再描画完了直後 | 更新後の DOM へのアクセス（無限ループに注意） |
    | `onBeforeUnmount` | コンポーネントのアンマウント処理開始直前 | クリーンアップ前の最終処理 |
    | `onUnmounted` | コンポーネントがDOMから完全に取り除かれた後 | タイマー停止・イベントリスナー解除・購読キャンセル |
    | `onErrorCaptured` | 子孫コンポーネントでエラーが発生したとき | エラーバウンダリの実装 |
    | `onActivated` | `<KeepAlive>` でキャッシュされたコンポーネントが再表示されたとき | キャッシュ復帰時のデータ更新 |
    | `onDeactivated` | `<KeepAlive>` でキャッシュされたコンポーネントが非表示になったとき | キャッシュ保存時のリソース解放 |

    > **`<script setup>` トップレベルとの違い:**  
    > `<script setup>` のトップレベルに書いたコードはコンポーネントの「セットアップ（構築）フェーズ」に実行されます。このタイミングはまだ DOM が存在しないため、DOM へのアクセスや副作用（API 通信など）は `onMounted` の中で行うのが正しいパターンです。

---

## 【Step 5：通信状態制御の実装】

> **対応テーマ**: ⑤ 通信成功／失敗を考慮した状態制御  
> **目標時間**: 1.5h

---

### ストアでの状態遷移の実装（確認問題）

- **問題:**  
  Step 2（問題3）で実装したアクションに、通信中・成功・失敗の3状態を正しく管理する処理が含まれているか確認・修正してください。

- **詳細:**（確認問題 → `src/stores/inventory.ts` の issue: 3-2～3-6 の実装を確認する）
  各アクション（`loadInventory`, `receive`, `ship`, `receiveOrCreate`）が以下のパターンを満たしているか確認してください。

  ```typescript
  isLoading.value = true       // ① 通信開始: ローディング ON
  clearMessages()              // ② 前回のメッセージをリセット
  try {
    // API 呼び出し
    successMessage.value = '...'  // ③ 成功: メッセージをセット
  } catch (e) {
    error.value = e instanceof Error ? e.message : 'エラーが発生しました'  // ④ 失敗
  } finally {
    isLoading.value = false    // ⑤ 必ず OFF
  }
  ```

- **確認チェックリスト:**
  - [ ] `loadInventory()`: ① `isLoading = true` → ② `clearMessages()` → ③ `items` 更新 → ④ `error` セット → ⑤ `isLoading = false`
  - [ ] `receive()`: ① `isLoading = true` → ② `clearMessages()` → ③ `items` 更新 + `successMessage` セット → ④ `error` セット → ⑤ `isLoading = false`
  - [ ] `ship()`: ① `isLoading = true` → ② `clearMessages()` → ③ `successMessage` セット → ④ `error` セット → ⑤ `isLoading = false`
  - [ ] `receiveOrCreate()`: ① `isLoading = true` → ② `clearMessages()` → ③ `successMessage` セット → ④ `error` セット → ⑤ `isLoading = false`
  - [ ] `loadCategories()`: `try/catch` で `error` をセットしている（isLoading 管理は不要）
  - [ ] すべてのアクションで `finally` による `isLoading = false` が保証されている

- **目的:**
  - `try/catch/finally` による状態遷移の完全性を保証する方法を理解する

- **注意点:**
  - `catch` の中で `return` しても `finally` は実行されます。
  - `e instanceof Error` のチェックは TypeScript の `catch (e: unknown)` に対応するための安全な書き方です。

- **ヒント:**
  - `try/catch` だけで `finally` を使わない場合、どのような問題が起きますか？

---

### 8. UI への状態反映

- **問題:**  
  `src/components/InventoryList.vue` と `src/components/StockForm.vue` の `<template>` で、通信状態に応じた表示切り替えを実装してください。

- **詳細:**  

  **InventoryList.vue:**
  1. `store.isLoading` が `true` のとき `id="loading-state"` の要素を表示する（issue: 8-1）
  2. `store.isLoading` が `false` かつ `store.items.length === 0`（元データが0件）のとき `id="empty-state"` の要素を表示する（issue: 8-2）
  3. それ以外のとき `id="inventory-table"` のテーブルを表示する（issue: 8-3）

  **StockForm.vue:**
  1. 通信中（`store.isLoading === true`）はすべての `<select>`, `<input>`, `<button>` を `:disabled="store.isLoading"` で無効化する（→ issue: 5-1,5-3,5-5,5-6,5-7,5-8 の各要素に実装済み）
  2. 成功時のみフォームをリセットする（`store.error` が `null` の場合のみ）（→ issue: 5-8 に実装済み）

- **目的:**
  - `v-if` / `v-else-if` / `v-else` で複数の排他的状態を切り替える方法を学ぶ
  - `:disabled` バインディングと Tailwind の `disabled:` バリアントを組み合わせる方法を学ぶ

- **注意点:**
  - `:disabled="store.isLoading"` で属性バインディングすることで、Tailwind の `disabled:bg-gray-100 disabled:cursor-not-allowed` が自動的に適用されます。
  - 通信失敗時はフォームの入力値を残してください。ユーザーが修正して再送信できる UX のためです。

- **ヒント:**
  - 成功トーストを「自動消去」、失敗トーストを「手動消去のみ」にした理由を UX の観点から説明できますか？
  - `disabled:bg-gray-100` は Tailwind のどのような仕組みで動いていますか？

---

## 【Step 6：APIモックを用いた UI テスト】

> **対応テーマ**: ⑥ APIモック・Vitest  
> **目標時間**: 4h

---

### 9. API 関数の単体テスト

- **問題:**  
  `__tests__/unit/services/inventoryApi.spec.ts` の `receiveStock()` と `shipStock()` のテストを実行し、問題 2-1・2-2 の実装が正しいことを確認してください。

- **詳細:**  

  **テストのセットアップ（実装済み）:**
  - `beforeEach` でグローバルの `fetch` を `vi.fn()` のモック関数（`mockFetch`）に差し替える（`vi.stubGlobal`）
  - `makeResponse(body, status)` ヘルパーでテスト用 `Response` オブジェクトを生成する
  - `mockFetch.mockReset()` で各テストを独立させる

  1. **`receiveStock()` テスト:**（issue: 9-1）
      - テスト対象: `src/services/inventoryApi.ts` — `receiveStock()`（問題 2-1 の実装確認）
      - 200 レスポンス時に `result.success === true` かつ `result.item.quantity === 110` であること
      - 400 エラー時: レスポンス JSON の `message` を含む Error がスローされること
      - 404 エラー時: `rejects.toThrow()` で Error スローを検証すること
      - 400 エラー（message なし）: フォールバックメッセージを含む Error がスローされること
      - JSON パースエラー時: フォールバックメッセージを含む Error がスローされること

  2. **`shipStock()` テスト:**（issue: 9-2）
      - テスト対象: `src/services/inventoryApi.ts` — `shipStock()`（問題 2-2 の実装確認）
      - 200 レスポンス時に `result.success === true` かつ `result.item.quantity === 90` であること
      - 400 エラー（在庫超過）時: サーバーの `message` を含む Error がスローされること
      - 404 エラー時: `rejects.toThrow()` で Error スローを検証すること
      - 400 エラー（message なし）: フォールバックメッセージを含む Error がスローされること
      - JSON パースエラー時: フォールバックメッセージを含む Error がスローされること

  3. **`fetchCategories()` テスト（実装済み参考例）:**
      - テスト対象: `src/services/inventoryApi.ts` — `fetchCategories()`（参考例実装の動作確認）
      - 200 レスポンス時に Category 配列が返ること
      - エラー系テスト（500）も同 `describe` 内に用意済み

  4. **`createProduct()` テスト（実装済み参考例）:**
      - テスト対象: `src/services/inventoryApi.ts` — `createProduct()`（参考例実装の動作確認）
      - 200 レスポンス時に `result.success === true` かつ `result.item` が返ること
      - エラー系テスト（400）も同 `describe` 内に用意済み

- **目的:**
  - `vi.stubGlobal` を用いたグローバル関数のモック化を理解する
  - `fetch` ラッパー関数の正常系・異常系を単体テストで確認する方法を学ぶ

- **注意点:**
  - **「※`// TODO:` あり」のテストは骨格が用意されています。** `mockFetch` の設定と `expect().rejects.toThrow()` を実装してください。
  - `fetchCategories()` と `createProduct()` のテストも同ファイルに実装済みです（参考例の動作確認用）。受講生が実装する必要はありません。
  - `rejects.toThrow()` を使ったエラー系テストも含まれています。`res.ok === false` 時に必ず `throw new Error(...)` していることを確認してください。

- **ヒント:**
  - `makeResponse()` が返す `Response` の `ok` フラグは `status >= 200 && status < 300` で決まります。
  - `res.json().catch(() => ({}))` パターン: エラー時に JSON パースが失敗しても空オブジェクトにフォールバックし、デフォルト文言をスローします。

---

### 10. Pinia ストアの単体テスト

- **問題:**  
  `__tests__/unit/stores/inventory.spec.ts` で、ストアの各アクションのテストを確認・実装してください。

- **詳細:**  

  **テストのセットアップ（実装済み）:**
  - `vi.mock('@/services/inventoryApi')` でモジュール全体をモック化する
  - `beforeEach` で `setActivePinia(createPinia())` と `vi.clearAllMocks()` を呼んで状態を初期化する

  1. **`loadInventory()` テスト:**（issue: 10-1）
      - テスト対象: `src/stores/inventory.ts` — `loadInventory()`（問題 3-2 の実装確認）
      - 成功ケース: `items` にデータが格納され、`isLoading` が `false`、`error` が `null` になること
      - 失敗ケース: `error` にメッセージが格納され、`isLoading` が `false` になること
      - 通信中ケース: `loadInventory()` 呼び出し直後に `isLoading` が `true` になること

  2. **`loadCategories()` テスト:**（issue: 10-2）
      - テスト対象: `src/stores/inventory.ts` — `loadCategories()`（問題 3-3 の実装確認）
      - 成功時: `categories` にデータが格納されること
      - 失敗時: `error` にメッセージが格納されること

  3. **`receive()` テスト:**（issue: 10-3）
      - テスト対象: `src/stores/inventory.ts` — `receive()`（問題 3-6 の実装確認）
      - 成功時: 対象商品の在庫数が更新され `successMessage` がセットされること
      - 失敗時: `error` にメッセージがセットされること
      - 対象 ID が `items` に存在しないとき: `items` は変更されず `successMessage` だけがセットされること

  4. **`ship()` テスト:**（issue: 10-4）
      - テスト対象: `src/stores/inventory.ts` — `ship()`（問題 3-4 の実装確認）
      - 成功時: 対象商品の `quantity` が更新され `successMessage` がセットされること
      - 失敗時: `error` にメッセージがセットされること
      - 対象 ID が `items` に存在しないとき: `items` は変更されず `successMessage` だけがセットされること

  5. **`receiveOrCreate()` テスト:**（issue: 10-5）
      - テスト対象: `src/stores/inventory.ts` — `receiveOrCreate()`（問題 3-5 の実装確認）
      - 既存商品名の場合: `receiveStock()` が呼ばれ `items` が更新されること
      - 新商品名の場合: `createProduct()` が呼ばれ `items` に追加されること
      - 失敗時: `error` がセットされ `items` が変更されないこと

  6. **`clearMessages()` テスト（実装済み）:**
      - テスト対象: `src/stores/inventory.ts` — `clearMessages()`（問題 3-1 の実装確認）
      - `error` と `successMessage` が両方 `null` にリセットされること

- **目的:**
  - `vi.mock()` でモジュール全体をモック化し、ストアのロジックだけをテストする方法を学ぶ
  - `store.$patch` を使わずにアクションを介した状態遷移をテストする

- **注意点:**
  - **issue 10-1～10-5 はテスト骨格（`// TODO:`）が設けられています。** 各 `expect()` や API モック設定を実装してください。
  - **`clearMessages()` テストは実装済みです。** 問題 3-1 を正しく実装するとテストが通過します。
  - 通信中ケース（issue 10-1）では `new Promise(() => {})` で永遠に解決しない Promise を返し、`await` なしで状態を確認します。

- **ヒント:**
  - `vi.mock()` と `vi.spyOn()` の使い分けはどのような観点で決めますか？
  - `store.$patch` と `vi.mocked` を使ったテストではそれぞれ何を検証していますか？

---

### 11. コンポーネント UI テスト

- **問題:**  
  以下のコンポーネントテストファイルで、指定のテストケースを実装・確認してください。

- **詳細:**  

  **`__tests__/ui/components/InventoryList.spec.ts`:**
  1. `store.isLoading === true` のとき `#loading-state` が表示される（issue: 11-1）
  2. `store.items` が空のとき `#empty-state` が表示される（issue: 11-2）
  3. `#search-input` に商品名を入力すると一覧が絞り込まれる（issue: 11-3）
  4. `quantity <= LOW_STOCK_THRESHOLD` の商品にのみ `.badge-low-stock` が表示される（issue: 11-4）
  5. カテゴリセレクトで絞り込むと該当カテゴリの商品のみ表示される（issue: 11-5）
  6. `categoryName()` が `categoryId` からカテゴリ名を引き当て、一覧に表示される（issue: 11-6）
  7. 列ヘッダーをクリックすると `sortKey` / `sortOrder` が正しく切り替わる（issue: 11-7）

  **`__tests__/ui/components/StockForm.spec.ts`:**
  1. 商品名が未入力のまま送信すると `#validation-error` にエラーが表示される（issue: 12-1）※`// TODO:` あり
  2. 商品名と数量を入力して送信すると `store.receiveOrCreate()` が正しい引数で呼ばれる（issue: 12-2）※`// TODO:` あり
  3. `mode="receive"` / `mode="ship"` でそれぞれ対応するフォーム要素のみ表示される（issue: 12-3）テスト実装済み
  4. セレクトで既存商品を選ぶと `productName` テキスト欄に商品名が自動入力される（issue: 12-4）※`// TODO:` あり
  5. 既存商品名を入力すると「既存商品〜に加算します」ヒントが表示される（issue: 12-5）※`// TODO:` あり
  6. 選択商品の在庫数ちょうどの出庫数量ではバリデーションエラーが出ない（issue: 12-6）※`// TODO:` あり

  **`__tests__/ui/components/ToastMessage.spec.ts`:**
  1. `store.successMessage` がセットされると `#toast-success` が表示される（issue: 13-1）※`// TODO:` あり
  2. `vi.useFakeTimers()` を使い、`successMessage` 変化から 3 秒後に `clearMessages()` が呼ばれる（issue: 13-2）※`// TODO:` あり

  **`__tests__/ui/App.spec.ts`:**
  1. コンポーネントマウント時に `store.loadInventory()` がちょうど 1 回呼ばれる（issue: 14-1）
  2. コンポーネントマウント時に `store.loadCategories()` がちょうど 1 回呼ばれる（issue: 14-2）

- **目的:**
  - `store.$patch` でストアの状態を直接設定し、UI の表示パターンをテストする方法を学ぶ
  - `vi.useFakeTimers()` で時間依存のテストを実際に待たずに実施する方法を理解する

- **注意点:**
  - **「※`// TODO:` あり」の issue（11-1～11-7 / 12-1, 12-2, 12-4～12-6 / 13-1, 13-2 / 14-1, 14-2）**: テスト骨格が用意されています。`// TODO:` コメントを参考に実装してください。
  - **「テスト実装済み」の issue（12-3）**: テストコードはすでに記述されています。対応する問題（4-x / 5-x）を実装するとテストが通過します。
  - `trigger('submit')` / `setValue()` 後は `await wrapper.vm.$nextTick()` で Vue の DOM 更新を待ってから検証してください。
  - `vi.useFakeTimers()` を使ったテストは `afterEach` で `vi.useRealTimers()` を呼んで必ず元に戻してください。他のテストへの影響を防ぐためです。

- **ヒント:**
  - `await wrapper.vm.$nextTick()` を省略するとテストが失敗するのはなぜですか？
  - `vi.useFakeTimers()` を使わずに「3秒後に消える」をテストしようとすると何が問題になりますか？
  - コンポーネントのマウント時に `store.$patch` で状態を設定する方法:
    ```typescript
    store.$patch({ isLoading: true })
    const wrapper = mount(InventoryList, { global: { plugins: [pinia] } })
    ```

---

## issue テストで使用する比較関数（matcher）一覧

> 各 issue の `expect(...)` で使用する Vitest / Vue Test Utils の比較関数をまとめています。

### Vitest 組み込み matcher

| 関数 | 使用 issue | 用途 |
|---|---|---|
| `.toBe(value)` | 10-1, 10-2, 11-1, 11-2, 11-3, 11-5, 11-6, 11-7, 12-3, 12-4 | プリミティブ値（`true` / `false` / 文字列）の厳密な同一性比較（`===`） |
| `.toEqual(value)` | 11-1, 11-2, 11-5, 11-7 | オブジェクト・配列の**深い**比較（参照ではなく内容を比較） |
| `.toBeNull()` | 11-1, 11-2, 11-4, 11-5, 11-6, 11-7 | 値が `null` であることを検証 |
| `.toHaveLength(n)` | 11-4, 11-7 | 配列・文字列の長さが `n` であることを検証 |
| `.toContain(string)` | 12-1, 12-5 | 文字列が指定のサブ文字列を含むことを検証 |
| `.not.toContain(string)` | 11-3, 11-5 | 文字列が指定のサブ文字列を含まないことを検証 |
| `.toHaveBeenCalledOnce()` | 12-2, 12-6 | モック/スパイ関数がちょうど **1回** 呼ばれたことを検証 |
| `.not.toHaveBeenCalled()` | 10-5 | モック/スパイ関数が **1回も** 呼ばれていないことを検証 |
| `.toHaveBeenCalledWith(...args)` | 10-5, 12-2 | モック/スパイ関数が指定の引数で呼ばれたことを検証 |
| `rejects.toThrow(message)` | 9-1, 9-2 | 非同期関数が指定のメッセージを含む `Error` をスローすることを検証 |

### Vue Test Utils（VTU）の DOM 検証ヘルパー

| 関数 | 使用 issue | 用途 |
|---|---|---|
| `wrapper.find(selector).exists()` | 12-3, 12-6 | セレクターに一致する要素が DOM に存在するか（`true` / `false`）を返す |
| `wrapper.find(selector).text()` | 12-1 | セレクターに一致する要素のテキスト内容（`textContent`）を返す |
| `wrapper.text()` | 11-3, 11-5, 12-5 | コンポーネント全体のテキスト内容を返す |
| `wrapper.findAll(selector)` | 11-4 | セレクターに一致するすべての要素の配列を返す |

### `.toBe()` vs `.toEqual()` の使い分け

```typescript
// toBe: プリミティブ・参照の同一性で比較（=== と同じ）
expect(store.isLoading).toBe(false)        // boolean の比較
expect(store.error).toBe('エラーメッセージ')  // 文字列の比較

// toEqual: オブジェクト・配列の内容を再帰的に比較（参照が異なっても OK）
expect(store.items).toEqual([mockItem1, mockItem2])  // 配列の内容比較
expect(result[0]).toEqual(mockItem)                   // オブジェクトの内容比較
```

---

## テスト実行方法

```bash
# 全テスト実行
npx vitest run

# 特定ファイルのみ
npx vitest run __tests__/unit/stores/inventory.spec.ts
```
