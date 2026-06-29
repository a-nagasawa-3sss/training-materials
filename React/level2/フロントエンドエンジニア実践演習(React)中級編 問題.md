![中級タイトル.png](https://image.docbase.io/uploads/cde4b215-2727-449e-9225-f361ce465d90.png =WxH)

![Pasted image 20250516083144.png](https://image.docbase.io/uploads/4115f837-5a29-45e9-af03-aecfc69903b4.png =WxH)

<div style="page-break-before:always"></div>

## **1. プロジェクト作成 & 最新環境の準備**
#### 問題の概要
React 19.1.0、TypeScript 5.8.3、Redux Toolkit 2.8.2を使用した、最新のNext.js 15.3.1環境でクイズアプリの基本プロジェクトを作成し、適切な初期設定を行ってください。

#### 詳細
1. **最新環境のプロジェクト作成:**
	```bash
	npx create-next-app@15.3.1 quiz-app
	```

	StackBlitzなどを使っている場合は以下推奨
	``` bash
	npm install next@15.3.1
	```

2. **必要なパッケージのインストールと更新:**
	```bash
	npm install react@19.1.0 react-dom@19.1.0
	npm install -D typescript@5.8.3
	npm install tailwindcss@4.1.5 @tailwindcss/postcss@4.1.5 autoprefixer@10.4.19 postcss@8.4.38
	npm install @types/react@19.1.2 @types/react-dom@19.1.3
	npm install @reduxjs/toolkit@2.8.2 react-redux@9.2.0
	```
	
3. **package.jsonの確認:**
	- 依存関係に正しいバージョンが記載されていることを確認
	- スクリプトコマンドの確認（dev, build, startなど）
	
4. **初期ファイル構造の整理と必要なディレクトリの作成:**
	- App Routerのフォルダ構造を理解し、必要なファイルのみを残す
	- 共通コンポーネント用の`components`ディレクトリ作成
	- データファイル用の`data`ディレクトリ作成
	- Redux関連ファイル用の`lib`ディレクトリ作成

#### 目的
    - 最新のReactエコシステムと状態管理の設定方法を理解する
    - フロントエンド開発のセットアップ経験を得る
    - TypeScript、Redux、Tailwindを統合したモダンな開発環境の構築方法を学ぶ
    - アプリケーション全体で一貫した状態管理基盤を作る

#### 注意点
    - Redux Toolkitの初期設定はシンプルに保ち、後の課題で機能を拡張できるようにする
    - TypeScriptとReduxの型定義を適切に連携させる
    - App Routerの構造に合わせてRedux Providerを配置する
    - Server ComponentsとClient Componentsの区別を理解し、Reduxを適切に使用する

#### ヒント
    - Redux Providerは`app/providers.tsx`のような専用ファイルでクライアントコンポーネントとして実装するとよい
    - `'use client'`ディレクティブを理解し、Reduxを使用するコンポーネントで適切に使用する
    - 最初はシンプルなストア設定から始め、アプリケーションの成長に合わせて拡張する
    - TypeScriptでのカスタムフック（`useAppDispatch`、`useAppSelector`など）を早期に定義しておくと便利

#### Reduxストアの基本設定：
```typescript
    // lib/store.ts
    import { configureStore } from '@reduxjs/toolkit';
    
    export const store = configureStore({
      reducer: {
        // 後で各機能のreducerを追加する場所
      },
      // 開発環境ではDevToolsを有効化
      devTools: process.env.NODE_ENV !== 'production',
    });
    
    // TypeScriptでReduxを使うための型定義
    export type RootState = ReturnType<typeof store.getState>;
    export type AppDispatch = typeof store.dispatch;
    ```

#### 型付きのReactフックを作成：
```typescript
    // lib/hooks.ts
    import { useDispatch, useSelector } from 'react-redux';
    import type { TypedUseSelectorHook } from 'react-redux';
    import type { RootState, AppDispatch } from './store';
    
    // 型付きのDispatchとSelectorフック
    export const useAppDispatch: () => AppDispatch = useDispatch;
    export const useAppSelector: TypedUseSelectorHook<RootState> = useSelector;
    ```

#### Reduxプロバイダーをセットアップ：
```typescript
    // app/providers.tsx
    'use client';
    
    import { PropsWithChildren } from 'react';
    import { Provider } from 'react-redux';
    import { store } from '@/lib/store';
    
    export function Providers({ children }: PropsWithChildren) {
      return <Provider store={store}>{children}</Provider>;
    }
    ```

#### ルートレイアウトにプロバイダーを統合：
```typescript
    // app/layout.tsx
    import type { Metadata } from 'next';
    import { Inter } from 'next/font/google';
    import './globals.css';
    import { Providers } from './providers';
    
    const inter = Inter({ subsets: ['latin'] });
    
    export const metadata: Metadata = {
      title: 'Quiz App',
      description: 'React 19とNext.js 15で構築されたクイズアプリケーション',
    };
    
    export default function RootLayout({
      children,
    }: {
      children: React.ReactNode;
    }) {
      return (
        <html lang="ja">
          <body className={inter.className}>
            <Providers>
              {children}
            </Providers>
          </body>
        </html>
      );
    }
    ```

#### **postcss.config.jsの記載を最新化**
``` js
module.exports = {
  plugins: {
    '@tailwindcss/postcss': {},
    autoprefixer: {},
  },
}
```

#### **tsconfig.jsonの記載修正**
``` json
{
  "compilerOptions": {
    "target": "ES2022",
    ・・・以下、既存のまま
}
```

#### **app/globals.cssの記載を最新のTailwindに適用**
```css
@tailwind base; // 削除
@tailwind components; // 削除
@tailwind utilities; // 削除

@import 'tailwindcss';
```
<div style="page-break-before:always"></div>

## **2. Hello World表示とコンポーネント基本構造の理解**
#### 問題の概要
Next.jsとReactの特徴を活かした基本的なページコンポーネントを作成し、「Hello Next.js + TypeScript」を表示してください。
    
#### 詳細
1. **app/page.tsxの編集:**
	- `app/page.tsx`ファイルを編集し、Server Componentとして実装
	- Tailwind CSSを使用した基本的なスタイリングを適用
	
	**基本実装例:**
``` tsx
export default function Home() {
  return (
	<main className="flex min-h-screen flex-col items-center justify-center p-24">
	  <h1 className="text-4xl font-bold mb-4">Hello Next.js + TypeScript</h1>
	  <p className="text-xl">This is a server component</p>
	</main>
  );
}
```
※以降、Tailwindの設定を含んだサンプルコードが登場しますが、デザインは受講生の皆様にお任せいたします。一例として参考にしてください。
    
#### 目的
- Next.js 15とReact 19のアーキテクチャを把握する
- Server Componentsの基本概念を理解する
- Tailwind CSSを使った基本的なスタイリングを実践する
- 開発環境が正しく設定されていることを確認する

#### 注意点
- App RouterではページコンポーネントはデフォルトでServer Componentsとして動作する
- Server Components はサーバーで実行されるが、必ずしもSSR（リクエスト時レンダリング）ではない
- デフォルトでは静的レンダリング（ビルド時生成）される
- 動的な機能（cookies、headers、searchParams等）を使用すると自動的にSSRになる

#### ヒント
- `npm run dev`コマンドでアプリケーションを起動し、ブラウザで確認する
- Server Componentsはクライアントサイドのバンドルサイズを減らすメリットがある
- Tailwindのユーティリティクラスを使って、レスポンシブなレイアウトを簡単に実現できる

![2.png](https://image.docbase.io/uploads/0dc8e4a5-b5a6-4aba-96c9-9d71dae28feb.png =WxH)
<div style="page-break-before:always"></div>


## **3. レイアウトコンポーネントの作成**
#### 問題の概要
アプリケーション全体で共通のレイアウトを提供するカスタムレイアウトコンポーネントを作成してください。
レイアウトは、ヘッダー、フッター、そしてその間にメインコンテンツを表示する領域を持つ基本的な構造として実装してください。

#### 詳細
1. **レイアウトファイルの編集**
    - `app/layout.tsx`ファイルを編集して、アプリケーション全体に適用されるレイアウトを実装します
    - ヘッダー、フッター、メインコンテンツエリアを含む基本構造を作成します
    
2. **レイアウト構造の実装**
    - ヘッダーにはアプリ名を表示します
    - メインコンテンツ部分はchildrenプロパティを使用します
    - フッターには著作権表示などを入れます
    - Tailwind CSSを使ってスタイリングします
    
3. **TypeScriptの型定義の実装**
    - レイアウトコンポーネントのpropsに適切な型定義を行います
    - メタデータの型も正しく定義します

#### 目的
- Next.js App Routerのレイアウト機能の使い方と特徴を理解する
- TypeScriptによる型安全なコンポーネント実装を学ぶ
- Tailwind CSSを活用したレスポンシブレイアウトの実装方法を習得する
- Reduxと連携したアプリケーションの基本構造を理解する

#### 実装のためのヒント
##### レイアウトの基本構造
```tsx
// app/layout.tsx
import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import { Providers } from './providers';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: 'クイズアプリ',
  description: 'React 19とNext.js 15で構築されたクイズアプリケーション',
};

// TODO: レイアウトの型定義を行う
interface RootLayoutProps {
  // childrenの型を適切に定義
}

export default function RootLayout({ children }: RootLayoutProps) {
  return (
    <html lang="ja">
      <body className={inter.className}>
        <Providers>
          <div className="min-h-screen flex flex-col">
            {/* ヘッダー */}
            <header className="/* TODO: ヘッダーのスタイリング */">
              <div className="/* TODO: コンテンツ幅の設定 */">
                {/* アプリ名を表示 */}
              </div>
            </header>

            {/* メインコンテンツ */}
            <main className="/* TODO: メインコンテンツのスタイリング */">
              <div className="/* TODO: コンテンツ幅の設定 */">
                {/* TODO: childrenを配置する */}
              </div>
            </main>

            {/* フッター */}
            <footer className="/* TODO: フッターのスタイリング */">
              {/* 著作権表示などを入れる */}
            </footer>
          </div>
        </Providers>
      </body>
    </html>
  );
}
```

##### ヒント
1. **Next.js App Routerのレイアウト**
    - ルートレイアウト（`app/layout.tsx`）はアプリ全体の構造を定義します
    - `html`と`body`タグを必ず含めてください
    
2. **メタデータの定義**
    - `title`と`description`を設定して、SEO対策を行いましょう
    - Next.jsの`Metadata`型を使用してください
    
3. **TypeScriptの型定義**
    - `children`プロパティの型には`React.ReactNode`を使用します
    - これにより、どのようなReactコンテンツも子要素として受け入れられます
    
4. **レイアウトスタイリングのポイント**
    - Flexboxレイアウトを使用して、縦方向の配置を制御します
    - `flex-grow`をメインコンテンツに適用して、利用可能な空間を埋めるようにします
    - `max-w-4xl mx-auto`のようなクラスで、コンテンツを中央揃えにします
    
5. **Redux Providerの統合**
    - 問題1で作成した`Providers`コンポーネントを`body`内で使用します
    - これにより、アプリケーション全体でReduxステートにアクセスできるようになります
    
6. **レスポンシブデザインの考慮**
    - 小さな画面でも適切に表示されるように、コンテナにパディングを設定しましょう
    - Tailwindの`p-4`のようなクラスを活用します

![3.png](https://image.docbase.io/uploads/4480a8ae-f44c-4b61-935a-9f6ee1e0b0e5.png =WxH)

<div style="page-break-before:always"></div>

## **4. ナビゲーションコンポーネントの作成**
#### 問題の概要
アプリケーション全体で使用するナビゲーションコンポーネントを作成し、ページ間の移動を可能にしてください。

#### 詳細
1. **ナビゲーションコンポーネントの作成:**
    - `components/Navigation.tsx`を作成
    - Next.jsの`Link`コンポーネントを使用したナビゲーションを実装
    - 'use client'ディレクティブを使用し、クライアントコンポーネントとして実装
    - 現在のパスに基づいてアクティブなリンクのスタイルを変更する
    
2. **レイアウトへのナビゲーション組み込み:**
    - 作成したナビゲーションコンポーネントをレイアウトのヘッダー部分に組み込む
    - ホームとクイズ作成ページへのリンクを含める（クイズ作成ページは後で実装）
    
3. **ホームページのコンテンツ充実:**
    - `app/page.tsx`を編集して、アプリケーションの説明を追加

#### 目的
- Client ComponentsとServer Componentsの使い分けを学ぶ
- Next.jsの`Link`コンポーネントによるクライアントサイドナビゲーションを実装する
- 現在のパスに基づくUI条件分岐の実装方法を学ぶ
- レイアウトコンポーネントへの組み込み方法を理解する

#### 実装のためのヒント
##### 1. ナビゲーションコンポーネントの作成
```tsx
// components/Navigation.tsx
'use client'; // クライアントコンポーネントにするために必要

import Link from 'next/link';
import { usePathname } from 'next/navigation';

export default function Navigation() {
  // TODO: 現在のパスを取得
  const pathname = // usePathnameフックを使用
  
  return (
    <nav className="space-x-4">
      {/* TODO: ホームページへのリンク */}
      <Link 
        href="/" 
        className={/* TODO: 現在のパスに基づいてスタイルを条件付きで適用 */}
      >
        ホーム
      </Link>
      
      {/* TODO: クイズ作成ページへのリンク（ページは後で作成） */}
      <Link 
        href="/quiz/create" 
        className={/* TODO: 現在のパスに基づいてスタイルを条件付きで適用 */}
      >
        クイズ作成
      </Link>
    </nav>
  );
}
```

##### 2. レイアウトへのナビゲーションの組み込み
```tsx
// app/layout.tsx (既存のファイルを編集)
import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import { Providers } from "./providers";
// TODO: Navigationコンポーネントをインポート

// 省略

export default function RootLayout({ children }: RootLayoutProps) {
  return (
    <html lang="ja">
      <body className={inter.className}>
        <Providers>
          <div className="min-h-screen flex flex-col">
            {/* ヘッダー */}
            <header className="bg-gray-800 text-white p-4">
              <div className="max-w-4xl mx-auto flex justify-between items-center">
                <h1 className="text-xl font-bold">Quiz App</h1>
                {/* TODO: Navigationコンポーネントを追加 */}
              </div>
            </header>

            {/* メインコンテンツ */}
            <main className="flex-grow">
              <div className="max-w-4xl mx-auto p-4">
                {children}
              </div>
            </main>

            {/* フッター */}
            <footer className="bg-gray-200 p-4 text-center">
              <p className="text-sm text-gray-600">© 2025 Quiz App</p>
            </footer>
          </div>
        </Providers>
      </body>
    </html>
  );
}
```

##### 3. ホームページのコンテンツ更新（例）
```tsx
// app/page.tsx
export default function Home() {
  return (
    <div>
      <h1 className="text-2xl font-bold mb-4">クイズアプリへようこそ</h1>
      <p className="mb-4">
        このアプリケーションでは、オリジナルのクイズを作成したり、
        作成されたクイズに挑戦したりすることができます。
      </p>
      <div className="bg-blue-50 dark:bg-blue-900/20 p-4 rounded-lg">
        <h2 className="text-lg font-semibold mb-2">使い方</h2>
        <ul className="list-disc list-inside space-y-1">
          <li>「クイズ作成」から新しいクイズを作成できます</li>
          <li>作成されたクイズは一覧に表示されます</li>
          <li>クイズを選択して挑戦することができます</li>
        </ul>
      </div>
    </div>
  );
}
```

##### ヒント
1. **'use client' ディレクティブ**
    - `usePathname`のようなクライアントサイドフックを使用するコンポーネントには必ず`'use client'`ディレクティブが必要です
    - Server Componentでは使用できない機能:
        - React hooks (`useState`, `useEffect`, `usePathname`等)
        - ブラウザAPI (`window`, `document`等)
        - イベントハンドラー (`onClick`, `onChange`等)

2. **Link コンポーネント**    
    - `a`タグの代わりに`Link`コンポーネントを使用することで、ページ全体をリロードせずにナビゲーションできます
    - `href`属性にURLパスを指定します
    - その他の属性は通常の`a`タグと同様に使用できます

3. **条件付きスタイリング**
    - `usePathname`で取得した現在のパスと各リンクのパスを比較することで、アクティブなリンクのスタイルを変更できます
    - 例: `pathname === '/' ? 'text-white font-bold' : 'text-gray-300 hover:text-white'`

4. **レイアウトとの統合**
    - ナビゲーションコンポーネントはヘッダー内に配置し、すべてのページで共通して表示されるようにします
    - Flexboxを使用してタイトルとナビゲーションを水平に配置するとよいでしょう

5. **Server ComponentsとClient Components**
    - ページファイル（`page.tsx`）はデフォルトでServer Componentsです
    - ナビゲーションは状態を持つため、Client Componentとして実装します
    - 適切な使い分けにより、パフォーマンスの最適化が可能です

![4.png](https://image.docbase.io/uploads/b83ae143-769b-4c1a-9289-f286140a0352.png =WxH)

<div style="page-break-before:always"></div>


## **5. JSONファイル（`quizzes.json`）を作成**
#### 問題の概要
クイズアプリで使用するデータを保持するためのJSONファイルを作成します。このファイルには複数のクイズデータを含め、Next.jsのAPIルートから取得できるようにします。

#### 詳細
1. **フォルダとファイルの作成:**
    - プロジェクトのルートに`data`フォルダを作成
    - `data/quizzes.json`ファイルを作成
    
2. **サンプルデータの作成:**
    - 2〜3件のクイズデータを含むJSON配列を設計・作成
    - 各クイズには以下のプロパティを含める：
        - id (一意の識別子)
        - title (クイズのタイトル)
        - createdAt (作成日付)
        - questions (問題の配列)
            - 各問題には問題文、選択肢の配列、正解インデックスを含める

#### 目的
- フロントエンドで使用するデータ構造の設計方法を学ぶ
- JSONフォーマットを理解し、適切なデータモデリングを実践する
- 次のステップでのデータフェッチに備えたデータを用意する

#### 実装のためのヒント
##### JSONファイルのサンプル
```json
[
      {
        "id": 1,
        "title": "Web開発の基礎",
        "createdAt": "2025-01-15",
        "questions": [
          {
            "questionText": "HTMLは何の略称ですか？",
            "options": [
              "Hyper Text Markup Language",
              "High Technology Modern Language",
              "Hyper Transfer Markup Language",
              "Hybrid Text Management Language"
            ],
            "correctIndex": 0
          },
          {
            "questionText": "CSSは主に何の目的で使用されますか？",
            "options": [
              "サーバーサイドのロジック実装",
              "Webページのスタイリング",
              "データベース操作",
              "動的な機能の実装"
            ],
            "correctIndex": 1
          }
        ]
      },
      {
        "id": 2,
        "title": "React基礎知識",
        "createdAt": "2025-02-20",
        "questions": [
          {
            "questionText": "Reactは何の役割を持つライブラリですか？",
            "options": [
              "バックエンド開発",
              "データベース管理",
              "UIコンポーネント開発",
              "サーバー管理"
            ],
            "correctIndex": 2
          },
          {
            "questionText": "Reactの基本的な構成要素は何ですか？",
            "options": [
              "モジュール",
              "コンポーネント",
              "クラス",
              "関数"
            ],
            "correctIndex": 1
          },
          {
            "questionText": "JSXとは何ですか？",
            "options": [
              "JavaScriptのエクステンション",
              "JavaScriptとXMLを組み合わせた構文",
              "JavaScriptの実行環境",
              "JSON形式のXML"
            ],
            "correctIndex": 1
          }
        ]
      }
    ]
```

##### 作成のステップ
1. **フォルダとファイルの作成**
    - プロジェクトのルートディレクトリに`data`フォルダを作成します
    - `data`フォルダ内に`quizzes.json`という名前のファイルを作成します
    
2. **JSONデータの構造設計**
    - クイズデータは配列として定義します（`[]`で囲む）
    - 各クイズはオブジェクトとして定義します（`{}`で囲む）
    - 各問題もオブジェクトとして、問題の配列内に定義します
    - 正解の選択肢は、選択肢配列のインデックス（0から始まる）で指定します
    
3. **サンプルデータの作成**
    - 少なくとも2つのクイズを作成し、各クイズには2問以上の問題を含めます
    - 各問題には少なくとも2つ以上の選択肢を用意します
    - 問題の難易度や種類に変化をつけると、より実践的なアプリになります

##### JSONの書式と注意点
- JSON内ではJavaScriptのコメント（`//`や`/* */`）は使用できません
- すべてのプロパティ名は二重引用符（`"`）で囲む必要があります（シングルクォートは使用不可）
- 文字列値も二重引用符で囲みます
- 数値、真偽値（`true`/`false`）、`null`は引用符なしで記述します
- 配列やオブジェクトの最後の要素の後にはカンマを付けないようにします
- 日付は文字列として"YYYY-MM-DD"形式で格納するのが一般的です

##### データ検証
- JSONの構文が正しいか確認するには、エディタの組み込み機能やオンラインのJSON検証ツールを使用できます
- 実際のアプリでデータを使用する前に、構造が正しいことを確認することが重要です

<div style="page-break-before:always"></div>


## **6. APIルート実装でクイズデータを提供**
#### 問題の概要
Next.jsのRoute Handlersを使用して、作成したクイズデータを取得するAPIエンドポイントを実装します。このAPIエンドポイントにより、フロントエンドからJSONデータにアクセスできるようになります。

#### 詳細
1. **APIルートファイルの作成:**
    - `app/api/quizzes/route.ts`ファイルを作成します
    - Node.jsの`fs`と`path`モジュールを使用してJSONファイルを読み込みます
    - GETリクエストのハンドラー関数を実装して、クイズデータをJSON形式で返します
    
2. **型定義の追加:**
    - クイズデータの型を定義して、型安全なコードを作成します
    - TypeScriptの型システムを活用して、コードの品質と保守性を向上させます

#### 目的
- Next.js App RouterのRoute Handlers機能の使い方を学ぶ
- Web標準のRequest/Response APIの使用方法を理解する
- サーバーサイドでのファイル操作とエラーハンドリングを実践する
- TypeScriptによる型定義を通じて型安全なAPI開発を体験する

#### 実装のためのヒント
##### 1. APIルートファイルの構造
```typescript
// app/api/quizzes/route.ts
import { NextResponse } from 'next/server';
import fs from 'fs';
import path from 'path';

// TODO: クイズと質問の型定義を追加する
export type Question = {
  // 実装してください
};

export type Quiz = {
  // 実装してください
};

export async function GET() {
  try {
    // TODO: JSONファイルを読み込んでパースする
    // ヒント: 
    // 1. process.cwd()でプロジェクトルートを取得
    // 2. path.join()でファイルパスを構築
    // 3. fs.readFileSync()でファイルを読み込み
    // 4. JSON.parse()でパース
    
    // TODO: 成功レスポンスを返す
    // ヒント: NextResponse.json(data)を使用
    
  } catch (error) {
    // エラーレスポンスの例
    console.error('Error reading quizzes:', error);
    return NextResponse.json(
      { error: 'Failed to fetch quizzes' },
      { status: 500 }
    );
  }
}
```

##### ヒント
- **型定義について**: 前の問題で作成したJSONファイルの構造と一致する型を定義します。`Question`型には`questionText`、`options`、`correctIndex`が必要です
- **HTTPメソッド**: 関数名（`GET`、`POST`など）が対応するHTTPメソッドを表します
- **型の適用**: `JSON.parse()`の結果に`as Quiz[]`または`: Quiz[]`で型を明示的に指定することで、TypeScriptの型チェックが有効になります
- **エラーハンドリング**: ファイルが存在しない場合や、JSONのパースに失敗した場合を考慮して、try-catchブロックで適切にエラーを処理します

<div style="page-break-before:always"></div>


## **7. ホーム画面でクイズ一覧を取得し、表示する**
#### 問題の概要
ホームページでAPIエンドポイントからクイズ一覧を取得し、シンプルなカードレイアウトで表示します。ユーザーがクイズを一覧で見て選べるようにします。

#### 詳細
1. **データ取得ロジックの実装:**
    - `app/page.tsx`を編集して、Server Componentでのデータフェッチを実装
    - クイズの型定義を適切に使用する
    
2. **クイズ一覧の表示:**
    - 取得したクイズデータを配列としてマッピングし、各クイズをカード形式で表示
    - 少なくともタイトル、作成日、問題数、「挑戦する」ボタンを表示する
    - Tailwind CSSを使用してカードレイアウトをスタイリング
    
3. **空の状態の処理:**
    - クイズが存在しない場合の表示を考慮する

#### 目的
- React Server Componentsでのデータフェッチ方法を学ぶ
- 取得したデータを配列としてマッピングし、UIに表示する方法を習得する
- リンクとナビゲーションの実装方法を理解する
- 条件付きレンダリングの基本を学ぶ

#### 実装のためのヒント
##### 1. Server Componentでのデータフェッチ
```tsx
// app/page.tsx
import Link from 'next/link';
import { Quiz } from './api/quizzes/route'; // 型定義をインポート

// 非同期コンポーネント
export default async function Home() {
  // データ取得関数の呼び出し
  const quizzes = await fetchQuizzes();
  
  // 以下、コンポーネントのレンダリングロジック
  return (
    // JSXを返す
  );
}

// データ取得関数
async function fetchQuizzes(): Promise<Quiz[]> {
  // TODO: APIからデータを取得する
  // ヒント: fetch関数を使用し、絶対URLを構築する
}
```

##### 2. fetch APIの使用
```tsx
async function fetchQuizzes(): Promise<Quiz[]> {
  // ベースURLの取得 (Next.jsの環境変数)
  const baseUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000';
  
  // 絶対URLの構築とフェッチ
  const response = await fetch(`${baseUrl}/api/quizzes`, { 
    // オプション: キャッシュの制御
    cache: 'no-store' // SSRと同様、リクエストごとに新しいデータを取得
    // または { next: { revalidate: 60 } } でISR (60秒ごとにデータを再検証)
  });
  
  // エラーハンドリング
  if (!response.ok) {
    throw new Error('Failed to fetch quizzes');
  }
  
  // JSONデータの取得と返却
  return response.json();
}
```

##### 3. クイズ一覧の表示
```tsx
// クイズの一覧表示
{quizzes.length > 0 ? (
  <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
    {quizzes.map((quiz) => (
      // TODO: 各クイズをカードとして表示
      // ヒント: keyプロパティを必ず指定する
      <div key={quiz.id} className="/* TODO: カードのスタイリング */">
        {/* TODO: クイズのタイトル表示 */}
        {/* TODO: 作成日の表示 */}
        {/* TODO: 問題数の表示 */}
        {/* TODO: 「挑戦する」ボタン/リンク */}
      </div>
    ))}
  </div>
) : (
  // TODO: クイズがない場合の表示
)}
```
##### 4. Tailwind CSSを使ったカードデザイン
```tsx
<div className="border rounded-lg p-4 shadow-sm hover:shadow-md transition-shadow">
  {/* カードコンテンツ */}
</div>
```
ボタンのスタイリング例:
```tsx
<Link
  href={`/quiz/${quiz.id}`}
  className="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-md text-sm inline-block"
>
  挑戦する
</Link>
```
##### 5. Server ComponentsとClient Componentsの使い分け
データ取得はServer Componentで行い、インタラクティブな要素（ボタンなど）はClient Componentとして実装することが推奨されます。
この問題ではLinkコンポーネントはクライアントサイドのナビゲーションを自動的に行うため、特別に'use client'ディレクティブは必要ありません。

![7.png](https://image.docbase.io/uploads/9de9a272-ec70-4cad-a72e-c22b95aa7457.png =WxH)

<div style="page-break-before:always"></div>


## **8. クイズ挑戦ページの作成と実装**
#### 問題の概要
ユーザーがクイズに挑戦するためのページとインターフェースを作成します。この画面では、選択したクイズのIDに基づいて問題を取得し、ユーザーが問題に回答できるようにします。

#### 詳細
1. **クイズ挑戦ページの作成:**
    - `app/quiz/[id]/challenge/page.tsx`ファイルを作成
    - Server Componentでクイズデータを取得し、Client Componentに渡す構造を実装
    
2. **クイズ回答インターフェースの実装:**
    - 問題を1問ずつ表示するUI
    - 選択肢をラジオボタンまたはカード形式で表示
    - 「次へ」ボタンで次の問題へ進む機能
    - 最後の問題では「回答を送信」ボタン表示
    
3. **状態管理の実装:**
    - 現在の問題インデックス、選択された回答、すべての回答履歴を管理するステート

#### 目的
- クライアントサイドでのインタラクティブなUI実装方法を学ぶ
- Server ComponentとClient Componentの連携方法を理解する
- 動的ルーティングを活用したデータ取得方法を習得する
- React Hooksを使った状態管理の実践

#### 実装のヒント
まず、クイズ挑戦ページのServer Componentの雛形を作成します:
```tsx
// app/quiz/[id]/challenge/page.tsx
import { notFound } from 'next/navigation';
import QuizForm from '@/components/QuizForm';  // これから作成するコンポーネント
import { Quiz } from '@/app/api/quizzes/route';

interface QuizChallengePageProps {
  params: Promise<{
    id: string;
  }>;
}

export default async function QuizChallengePage({ params }: QuizChallengePageProps) {
  const { id } = await params;
  
  // クイズデータを取得
  const quiz = await fetchQuizById(parseInt(id, 10));
  
  if (!quiz) {
    notFound();
  }
  
  return (
    <div>
      <h1 className="text-2xl font-bold mb-2">{quiz.title}</h1>
      
      {/* クライアントコンポーネントにクイズデータを渡す */}
      <QuizForm quiz={quiz} />
    </div>
  );
}

// クイズデータ取得関数
async function fetchQuizById(id: number): Promise<Quiz | null> {
  try {
    // TODO: APIからクイズデータを取得する処理を実装
    // ヒント: 作成したAPIエンドポイントを使用
    // ヒント: 全クイズを取得してから、指定IDのクイズをfindで探す
    
    return null; // この行は適切な実装に置き換えてください
  } catch (error) {
    console.error('Error fetching quiz:', error);
    return null;
  }
}
```

次に、クイズ回答インターフェースのClient Componentの雛形です:
```tsx
// components/QuizForm.tsx
'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { Quiz } from '@/app/api/quizzes/route';

interface QuizFormProps {
  quiz: Quiz;
}

export default function QuizForm({ quiz }: QuizFormProps) {
  const router = useRouter();
  
  // TODO: 必要な状態を定義
  // ヒント: 現在の問題インデックス、選択された選択肢、全回答履歴
  
  // 現在の問題を取得
  const currentQuestion = quiz.questions[/* TODO: 現在の問題インデックス */];
  
  // 選択肢を選択したときの処理
  const handleOptionSelect = (optionIndex: number) => {
    // TODO: 選択された選択肢を状態に保存
  };
  
  // 回答を送信する処理
  const handleSubmitAnswer = () => {
    // TODO: 選択が未選択の場合は処理を中断
    
    // TODO: 回答を記録
    
    // TODO: 次の問題へ進むか、結果ページへ遷移する処理
    // ヒント: 最後の問題かどうかを条件分岐
  };
  
  return (
    <div className="my-6">
      <div className="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-6">
        {/* TODO: 問題番号表示 */}
        
        {/* TODO: 問題文表示 */}
        
        {/* TODO: 選択肢の表示とイベントハンドリング */}
        
        {/* TODO: 「次へ」または「回答を送信」ボタンの実装 */}
      </div>
    </div>
  );
}
```

#### ヒントと実装のポイント
1. **fetchQuizById 関数のヒント:**
    - `fetch`関数を使ってAPIエンドポイント(`/api/quizzes`)からすべてのクイズを取得
    - 環境変数や設定でベースURLを取得: `const baseUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000';`
    - 取得したクイズ配列から、指定されたIDとマッチするクイズを`find`メソッドで検索
    - キャッシュの設定を考慮: `{ cache: 'no-store' }`
    
2. **選択肢の選択処理:** 
    `setSelectedOption(optionIndex);`
    で選択された選択肢を保存
    
3. **次の問題への遷移処理:**
    ```tsx
    // 回答を記録
    const newAnswers = [...answers];
    newAnswers[currentQuestionIndex] = selectedOption;
    setAnswers(newAnswers);
    
    // 次の問題へ進むか結果ページへ
    if (currentQuestionIndex < quiz.questions.length - 1) {
      setCurrentQuestionIndex(currentQuestionIndex + 1);
      setSelectedOption(null); // 選択状態をリセット
    } else {
      // 最後の問題の場合は結果ページへ
      console.log('全回答:', newAnswers);
      // TODO: 結果ページへの遷移 (後の問題で実装予定)
    }
    ```
     
4. **選択肢の表示とスタイル:**
    ```tsx
    <div className="space-y-3">
      {currentQuestion.options.map((option, index) => (
        <div 
          key={index}
          className={`border rounded-lg p-3 cursor-pointer transition-colors ${
            selectedOption === index 
              ? 'bg-blue-100 dark:bg-blue-900 border-blue-500' 
              : 'hover:bg-gray-100 dark:hover:bg-gray-700'
          }`}
          onClick={() => handleOptionSelect(index)}
        >
          {/* ラジオボタンと選択肢テキスト */}
        </div>
      ))}
    </div>
    ```

![8.png](https://image.docbase.io/uploads/0fe99297-363f-4e46-b70d-e952e0857f11.png =WxH)

<div style="page-break-before:always"></div>


## **9. クイズ作成ページのフォームレイアウト実装**

#### **問題の概要**
新しいクイズを作成するためのフォームページを実装します。このページでは、クイズのタイトル、説明文、問題文、選択肢、正解の指定などを入力できるようにします。また、問題を追加できる動的なフォーム機能も実装します。

#### **詳細要件**
1. **クイズ作成ページの作成:**
    - `app/quiz/create/page.tsx`ファイルを作成
    - クライアントコンポーネント(`'use client'`)として実装
    - React Hooksを使ったフォーム状態管理の実装
    
2. **フォーム構造の実装:**
    - クイズのタイトル入力欄（必須）
    - 問題セクション（問題文、選択肢、正解指定）
    - 送信ボタン（次の課題で機能実装）
    
3. **動的フォーム機能:**
    - 「問題を追加」ボタンによる問題フォームの追加
    - 「選択肢を追加」ボタンによる選択肢の追加
    - 正解を選択するラジオボタン実装

#### **目的**
- React Hooksを使った複雑なフォーム状態管理を学ぶ
- 動的にフォーム要素を追加するUIパターンを理解する
- ネストされた状態（配列内のオブジェクト）の更新方法を習得する
- TypeScriptの型定義によるフォーム状態の型安全性を確保する

#### **実装のためのヒント**
##### **1. 基本的な型定義と状態設計**
まず、問題と選択肢のための型定義を行います:
```typescript
// app/quiz/create/page.tsx
'use client';

import { useState } from 'react';

// 問題の型定義
type Question = {
  questionText: string;     // 問題文
  options: string[];        // 選択肢の配列
  correctIndex: number;     // 正解の選択肢インデックス
};

export default function CreateQuizPage() {
  // フォーム状態の管理
  const [title, setTitle] = useState('');
  
  // 問題の配列を管理（少なくとも1つの問題を初期状態で持つ）
  const [questions, setQuestions] = useState<Question[]>([
    { 
      questionText: '', 
      options: ['', ''], // 最低2つの選択肢
      correctIndex: 0 
    }
  ]);
  
  // TODO: 以下に必要な関数と JSX を実装
}
```

##### **2. 問題と選択肢の操作関数**
問題や選択肢を追加・編集するための関数を実装します:
```typescript
// 問題を追加する関数
const addQuestion = () => {
  // TODO: 既存の問題配列に新しい空の問題を追加
  // ヒント: スプレッド構文を使って新しい配列を作成
};

// 問題のテキストを変更する関数
const handleQuestionTextChange = (questionIndex: number, text: string) => {
  // TODO: 指定されたインデックスの問題テキストを更新
  // ヒント: 配列のコピーを作成し、特定の要素だけを更新
};

// 選択肢を変更する関数
const handleOptionChange = (questionIndex: number, optionIndex: number, text: string) => {
  // TODO: 指定された問題の特定の選択肢を更新
  // ヒント: ネストされた配列の更新には複数レベルのコピーが必要
};

// 選択肢を追加する関数
const addOption = (questionIndex: number) => {
  // TODO: 指定された問題に新しい空の選択肢を追加
};

// 正解を設定する関数
const setCorrectAnswer = (questionIndex: number, optionIndex: number) => {
  // TODO: 指定された問題の正解インデックスを更新
};
```

##### **3. フォームレイアウトの JSX 実装**
フォームのレイアウトを実装します。Tailwind CSSを使ってスタイリングします:
``` tsx
return (
  <div className="max-w-3xl mx-auto py-8">
    <h1 className="text-2xl font-bold mb-6">新しいクイズを作成</h1>
    
    <div className="space-y-6">
      {/* TODO: クイズ基本情報セクションを実装 */}
      {/* 
        要件:
        ・タイトル入力欄（必須）
      */}
      
      {/* TODO: 問題フォームセクションを実装 */}
      {/* 
        要件:
        ・questions配列をmap関数で展開
        ・各問題に「問題 N」の見出し
        ・問題文入力欄
        ・選択肢入力欄（複数）
        ・正解選択用のラジオボタン
      */}
      
      {/* TODO: アクションボタンを配置 */}
      {/* 
        要件:
        ・問題追加ボタン
        ・クイズ作成ボタン
      */}
    </div>
  </div>
);
```

#### **実装のポイント**
- **状態の不変性**: Reactの状態を更新する際は必ず新しいオブジェクト/配列を作成します
- **ネストされた状態更新**: 配列内のオブジェクトを更新する際は、適切な深さでコピーを作成します
- **フォームの検証**: 必須項目にはrequired属性を設定し、視覚的にも「`*`」マークで示します
- **ユーザー体験**: 問題や選択肢の追加は簡単にできるよう直感的なUI設計を心がけます
- **TypeScript活用**: 型定義により、適切な状態管理とエラー防止を実現します
- **アクセシビリティ**: ラベルとinput要素の関連付けや、適切な属性設定を行います

状態の更新ロジックは一見複雑に見えますが、Reactのパターンとして重要なので、しっかり理解しましょう。

![9.png](https://image.docbase.io/uploads/b8bfaf4c-698e-4b49-ac43-3729ebe452cd.png =WxH)

<div style="page-break-before:always"></div>


## **10. APIルートにPOST処理を追加**
#### **問題の概要**
クイズ作成フォームの内容をサーバーサイドで保存するRoute Handlerを実装します。前の問題で作成したフォームからデータを受け取り、JSONファイルに追加して保存する機能を開発します。

#### **詳細要件**
1. **Route Handlerの拡張:**
    - `app/api/quizzes/route.ts`ファイルにPOST関数を追加
    - JSONファイルの読み込み→追加→保存処理を実装
    - バリデーションとエラーハンドリング機能の追加
    
2. **クライアント側送信処理:**
    - クイズ作成ページに送信機能を追加
    - フォームデータをJSON形式でPOSTリクエスト送信
    - 送信中の状態管理の実装
    - クイズ作成完了後にクイズ詳細ページに遷移する設定を追加

#### **目的**
- App RouterのRoute Handlersでのデータ操作方法を学ぶ
- クライアント-サーバー間の通信パターンを理解する
- サーバーサイドでのファイル操作とエラーハンドリングを実践する
- フォームデータの送信と非同期処理の管理方法を習得する

#### **実装のためのヒント**
##### **1. サーバーサイドのPOST処理実装**
まず、`app/api/quizzes/route.ts`ファイルに、POSTメソッドのハンドラーを追加します:
```typescript
// app/api/quizzes/route.ts
// 既存のインポートステートメントに加えて以下を追加
import { NextResponse } from 'next/server';
import fs from 'fs';
import path from 'path';

// 既存のGET関数は変更せず、以下のPOST関数を追加

export async function POST(request: Request) {
  try {
    // リクエストボディを取得
    const newQuiz = await request.json();
    
    // バリデーション
    if (!newQuiz.title || !newQuiz.questions || newQuiz.questions.length === 0) {
      return NextResponse.json(
        { error: 'Title and questions are required' },
        { status: 400 }
      );
    }
    
    // 各問題のバリデーション
    for (const question of newQuiz.questions) {
      if (!question.questionText || 
          !question.options || 
          question.options.length < 2 ||
          question.correctIndex === undefined) {
        return NextResponse.json(
          { error: 'Each question must have text, at least 2 options, and a correct answer' },
          { status: 400 }
        );
      }
    }
    
    // JSONファイルのパスを取得
    const filePath = path.join(process.cwd(), 'data', 'quizzes.json');
    
    // TODO: 既存のクイズデータを読み込む
    // ヒント: fsモジュールを使用してファイルを読み込み、JSONとしてパース
    
    // TODO: 新しいIDを生成（既存の最大ID + 1、または現在時刻）
    // ヒント: reduce関数を使用して最大IDを計算する
    
    // TODO: 新しいクイズオブジェクトを作成
    // ヒント: IDと現在の日付を追加したオブジェクトを作成
    
    // TODO: クイズを追加
    // ヒント: 既存の配列に新しいオブジェクトをpush
    
    // TODO: ファイルに書き込む
    // ヒント: JSON.stringifyでオブジェクトを文字列に変換し、ファイルに書き込む
    
    // 成功レスポンスを返す
    return NextResponse.json({ 
      message: 'Quiz created successfully', 
      quiz: quizToSave 
    }, { status: 201 });
    
  } catch (error) {
    console.error('Error creating quiz:', error);
    return NextResponse.json(
      { error: 'Failed to create quiz' },
      { status: 500 }
    );
  }
}
```

##### **2. クライアント側の送信機能実装**
次に、クイズ作成ページ(`app/quiz/create/page.tsx`)に送信機能を追加します:
```typescript
// app/quiz/create/page.tsx の既存のインポートに以下を追加
import { useRouter } from 'next/navigation';

export default function CreateQuizPage() {
  const router = useRouter();
  
  // 既存の状態変数に以下を追加
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  
  // 既存の関数はそのままで、以下の送信関数を追加
  
  // クイズを送信する関数
  const handleSubmit = async () => {
    // バリデーション
    if (!title.trim()) {
      setError('クイズタイトルを入力してください');
      return;
    }
    
    // TODO: 各問題のバリデーション
    // ヒント: 問題文と選択肢が入力されているか確認
    
    setError(null);
    setIsSubmitting(true);
    
    try {
      // TODO: APIにPOSTリクエストを送信
      // ヒント: fetch API を使用し、適切なヘッダーとボディを設定
      
      // TODO: レスポンス処理
      // ヒント: レスポンスのステータスコードをチェックし、エラー処理
      
      // TODO: 成功時の処理
      // ヒント: ユーザーにフィードバックを表示し、適切なページに遷移
      
    } catch (error) {
      // TODO: エラーハンドリング
      // ヒント: エラーメッセージを設定してユーザーに表示
      
    } finally {
      // 送信状態をリセット
      setIsSubmitting(false);
    }
  };
  
  // TODO: 既存のreturn文を修正して以下の要素を追加
  // 1. エラーメッセージ表示エリア
  // 2. 送信ボタンの更新（onClick、disabled、動的なスタイル）
}
```

#### **実装のポイント**
- **不変性**: Reactの状態更新とサーバーサイドでのデータ処理両方で、不変性を意識した操作を行います
- **バリデーション**: クライアントとサーバー両方でバリデーションを実装し、データの整合性を確保します
- **エラーハンドリング**: 様々なエラーケースに対応するため、適切なエラーハンドリングを行います
- **UX向上**: 送信中の状態表示やエラーメッセージの表示でユーザー体験を向上させます
- **型安全性**: TypeScriptの型を活用して、データ構造の一貫性を維持します
- **非同期処理**: `async/await`を使って、読みやすく管理しやすい非同期コードを記述します

<div style="page-break-before:always"></div>



## **11. クイズ回答状態をReduxで管理**
### **問題概要:**
クイズの回答状態をReduxで管理するためのSliceを作成し、クイズ回答ページと連携させてください。

### **詳細:**
1. **Sliceの作成:**
    - `lib/features/quiz/quizSlice.ts`ファイルを作成
    - createSliceを使って回答状態（現在の問題インデックス、回答履歴など）を管理するSliceを実装
2. **ストアへの統合:**
    - `lib/store.ts`にquizReducerを追加
3. **クイズ詳細ページとの連携:**
    - QuizFormコンポーネントをReduxと接続
    - 回答選択時にReduxのstateを更新する機能の実装

### **目的:**
- Redux Sliceを使った状態管理の設計方法を学ぶ
- Reduxのアクションとリデューサーのパターンを理解する
- Reduxを既存コンポーネントと統合する方法を習得する

### **実装のためのヒント:**
#### 1. クイズSliceの作成
```typescript
// lib/features/quiz/quizSlice.ts
import { createSlice, PayloadAction } from '@reduxjs/toolkit';

// クイズの状態を定義
interface QuizState {
  currentQuestionIndex: number;
  answers: number[];
  quizId: number | null;
}

// ペイロード型の定義
interface StartQuizPayload {
  quizId: number;
  questionCount: number;
}

interface AnswerPayload {
  questionIndex: number;
  selectedOptionIndex: number;
}

// 初期状態
const initialState: QuizState = {
  currentQuestionIndex: 0,
  answers: [],
  quizId: null,
};

// Sliceの作成
export const quizSlice = createSlice({
  name: 'quiz',
  initialState,
  reducers: {
    // TODO: クイズを開始する
    startQuiz: (state, action: PayloadAction<StartQuizPayload>) => {
      // クイズIDを設定
      // 回答配列を初期化（ヒント: -1で埋めた配列）
      // currentQuestionIndexを0に
    },
    
    // TODO: 回答を記録する
    setAnswer: (state, action: PayloadAction<AnswerPayload>) => {
      // answers配列の適切な位置に回答を保存
    },
    
    // TODO: 次の問題へ進む
    nextQuestion: (state) => {
      // currentQuestionIndexを増やす
    },
    
    // TODO: クイズをリセット
    resetQuiz: (state) => {
      // 初期状態に戻す
    }
  }
});

// アクションをエクスポート
export const { startQuiz, setAnswer, nextQuestion, resetQuiz } = quizSlice.actions;
export default quizSlice.reducer;
```

#### 2. ストアにReducerを追加
```typescript
// lib/store.ts
// TODO: 作成したquizReducerをインポートし、storeのreducerに追加
```

#### 3. クイズフォームコンポーネントとの連携
```tsx
// components/QuizForm.tsx
'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { Quiz } from '@/app/api/quizzes/route';
import { useAppDispatch, useAppSelector } from '@/lib/hooks';
import { startQuiz, setAnswer, nextQuestion, resetQuiz } from '@/lib/features/quiz/quizSlice';

interface QuizFormProps {
  quiz: Quiz;
}

export default function QuizForm({ quiz }: QuizFormProps) {
  const router = useRouter();
  const dispatch = useAppDispatch();
  
  // Reduxステートから値を取得
  const currentQuestionIndex = useAppSelector(state => state.quiz.currentQuestionIndex);
  const answers = useAppSelector(state => state.quiz.answers);
  
  // ローカルステート
  const [selectedOption, setSelectedOption] = useState<number | null>(null);
  
  // クイズが始まったときに初期化
  useEffect(() => {
    // TODO: startQuizアクションをdispatch
  }, [dispatch, quiz.id, quiz.questions.length]);
  
  // 現在の問題が変わったときに選択状態をリセットまたは復元
  useEffect(() => {
    const savedAnswer = answers[currentQuestionIndex];
    setSelectedOption(savedAnswer >= 0 ? savedAnswer : null);
  }, [currentQuestionIndex, answers]);
  
  // 既存の関数とJSXはそのまま使用
  const currentQuestion = quiz.questions[currentQuestionIndex];
  
  const handleOptionSelect = (optionIndex: number) => {
    setSelectedOption(optionIndex);
  };
  
  // 回答を送信する処理
  const handleSubmitAnswer = () => {
    if (selectedOption === null) return;
    
    // TODO: Reduxに回答を保存する処理
    // 1. setAnswerアクションをdispatch
    
    // TODO: 次の問題へ進むか、結果ページへ遷移する処理
    // 1. 最後の問題でなければnextQuestionをdispatch
    // 2. 最後なら結果ページへ遷移
  };

  // 最後の問題か確認するための変数isLastQuestionを定義

  // 既存のJSX部分はそのまま
  return (
    <div className="my-6">
      {/* ... */}
    </div>
  );
}
```

### **注意点:**
- Reduxの状態更新では、Immerが内部で処理するため、reducerの中でstateを直接変更してOK
- `new Array(n).fill(-1)`で未回答を表す配列を作成できる
- 最後の問題かどうかは`currentQuestionIndex === quiz.questions.length - 1`で判定

### **ヒント:**
- Redux DevToolsを使って状態変化をリアルタイムで確認しながら開発すると良い
- エラーが出た場合は、importの漏れや型の不一致を確認する
<div style="page-break-before:always"></div>


## **12. 結果ページの作成**
### **問題概要:**
クイズ回答後の結果を表示するページを実装してください。シンプルなスコア表示と「ホームに戻る」ボタンのみを含めます。

### **詳細:**
1. **結果ページの作成:**
    - `app/quiz/[id]/result/page.tsx`ファイルを作成
    - Client ComponentとしてRedux状態にアクセスする結果表示コンポーネントを実装

2. **結果計算ロジック:**
    - Reduxストアから回答データを取得
    - Server Componentでクイズデータを取得し、Client Componentにpropsとして渡す
    - 正解数を計算

3. **結果表示UI:**
    - クイズタイトル、正解数、総問題数の表示
    - 「ホームに戻る」ボタンの実装（Redux状態のリセット含む）

### **目的:**
- App RouterでのServer ComponentとClient Componentの連携方法を学ぶ
- ReduxストアとServer Componentで取得したデータの組み合わせ方を理解する
- シンプルで分かりやすい結果表示UIの実装を習得する

### **実装のためのヒント:**
#### 1. 結果ページの作成（Server Component）
```tsx
// app/quiz/[id]/result/page.tsx
import { notFound } from 'next/navigation';
import { Quiz } from '@/app/api/quizzes/route';
import ResultClient from './ResultClient';

interface ResultPageProps {
  params: Promise<{
    id: string;
  }>;
}

export default async function ResultPage({ params }: ResultPageProps) {
  // TODO: 以下を実装
  // 1. paramsからidを取得
  // 2. fetchQuizById関数でクイズデータを取得（問題8と同じ方法）
  // 3. クイズが存在しない場合はnotFound()
  // 4. ResultClientコンポーネントにquizを渡す
}
```

#### 2. 結果表示用クライアントコンポーネント
```tsx
// app/quiz/[id]/result/ResultClient.tsx
'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { useAppSelector, useAppDispatch } from '@/lib/hooks';
import { resetQuiz } from '@/lib/features/quiz/quizSlice';
import { Quiz } from '@/app/api/quizzes/route';

interface ResultClientProps {
  quiz: Quiz;
}

export default function ResultClient({ quiz }: ResultClientProps) {
  const router = useRouter();
  const dispatch = useAppDispatch();
  
  // TODO: Reduxから必要なデータを取得
  // ヒント: answersとquizIdが必要
  
  const [score, setScore] = useState(0);
  
  // 不正なアクセスのチェック
  useEffect(() => {
    // TODO: 回答データがない、またはquizIdが一致しない場合はホームへリダイレクト
  }, [/* 依存配列を適切に設定 */]);
  
  // 結果の計算
  useEffect(() => {
    // TODO: 正解数を計算してscoreに設定
    // ヒント: answersの各要素とquiz.questions[i].correctIndexを比較
  }, [/* 依存配列を適切に設定 */]);
  
  const handleBackToHome = () => {
    // TODO: 
    // 1. Redux状態をリセット
    // 2. ホームページへ遷移
  };
  
  // TODO: UIを実装
  // 要件:
  // - クイズタイトルの表示
  // - スコア表示（大きく、見やすく）
  // - 「問正解しました！」のメッセージ
  // - ホームに戻るボタン
  
  return (
    <div>
      {/* UIを実装 */}
    </div>
  );
}
```

### **ヒント:**
- 正解数の計算には`reduce`や`filter`を使うと効率的
- センター寄せには`text-center`や`mx-auto`を活用
- スコアは`text-4xl`や`text-5xl`で大きく表示
- カードデザインには`rounded-lg shadow-lg p-8`などを組み合わせる

![13.png](https://image.docbase.io/uploads/9c28723e-c25d-4d13-a952-7fb6cff0d4f4.png =WxH)

<div style="page-break-before:always"></div>


## **13. ダークモード切替機能の実装**
### **問題概要:**
ダークモード切替機能のためのRedux Sliceを作成し、切り替えUIを実装してください。

### **詳細:**
1. **Sliceファイルの作成:**
    - `lib/features/theme/themeSlice.ts`ファイルを作成
    - `darkMode: boolean`の状態を持つSliceを実装
    - `toggleDarkMode`アクションを定義（現在の状態を反転）
    - `setDarkMode`アクションを定義（特定の値を設定）

2. **Storeへの統合:**
    - `lib/store.ts`にthemeReducerを追加

3. **ダークモード切替UIの実装:**
    - `components/ThemeToggle.tsx`を作成
    - ヘッダーにトグルボタンを配置
    - Redux状態と連動してダークモードを切り替える

### **目的:**
- テーマ切替というアプリ全体に影響する機能をReduxで管理する方法を学ぶ
- Redux状態とDOM操作を連携させる実装方法を理解する
- ユーザーの設定を永続化する方法を習得する

### **実装のためのヒント:**
#### 1. テーマSliceの作成
```typescript
// lib/features/theme/themeSlice.ts
import { createSlice, PayloadAction } from '@reduxjs/toolkit';

interface ThemeState {
  darkMode: boolean;
}

const initialState: ThemeState = {
  darkMode: false,
};

export const themeSlice = createSlice({
  name: 'theme',
  initialState,
  reducers: {
    toggleDarkMode: (state) => {
      // TODO: 状態を反転させ、ローカルストレージに保存
    },
    
    setDarkMode: (state, action: PayloadAction<boolean>) => {
      // TODO: 指定された値を設定し、ローカルストレージに保存
    }
  }
});

export const { toggleDarkMode, setDarkMode } = themeSlice.actions;
export default themeSlice.reducer;
```

#### 2. ストアへのReducer追加
```typescript
// lib/store.ts
// TODO: themeReducerをインポートし、storeのreducerに追加
```

#### 3. ダークモード切替コンポーネントの作成
```tsx
// components/ThemeToggle.tsx
'use client';

import { useEffect } from 'react';
import { useAppSelector, useAppDispatch } from '@/lib/hooks';
import { toggleDarkMode } from '@/lib/features/theme/themeSlice';

export default function ThemeToggle() {
  const dispatch = useAppDispatch();
  const darkMode = useAppSelector(state => state.theme.darkMode);
  
  useEffect(() => {
    // TODO: darkModeの値に応じてHTMLのルート要素にdarkクラスを付与/削除
  }, [darkMode]);
  
  return (
    <button
      onClick={() => {/* TODO: toggleDarkModeをdispatch */}}
      className="p-2 rounded-lg bg-gray-200 dark:bg-gray-700 hover:bg-gray-300 dark:hover:bg-gray-600 transition-colors"
      aria-label="ダークモード切替"
    >
      {/* TODO: darkModeの状態に応じてアイコンを表示 */}
      {/* ヒント: darkMode ? 太陽アイコン : 月アイコン */}
    </button>
  );
}
```

#### 4. レイアウトへの組み込み
```tsx
// app/layout.tsx
import ThemeToggle from '@/components/ThemeToggle';

// header内のナビゲーションの隣に追加
<div className="flex items-center gap-4">
  <Navigation />
  {/* TODO: ThemeToggleコンポーネントを追加 */}
</div>
```

### **ヒント:**
- HTMLのルート要素は`document.documentElement`でアクセス
- クラスの追加/削除は`classList.add()`と`classList.remove()`を使用
- ローカルストレージへの保存は`localStorage.setItem('theme', value)`
- アイコンはSVGまたは絵文字（🌞/🌙）で実装可能
- `typeof window !== 'undefined'`でクライアントサイドかチェック

![14.png](https://image.docbase.io/uploads/0f28638c-dce7-404a-82da-9a59b1a90f1a.png =WxH)

<div style="page-break-before:always"></div>


## **14. ダークモード時のUI調整**
### **問題概要:**
ダークモード実装後、主要なコンポーネントの色調整を行ってください。

### **詳細:**
1. **必須調整箇所:**
    - フォーム入力欄のボーダーと背景色
    - エラーメッセージの色調整
    - 選択肢カードのホバー状態

2. **globals.cssへの追加:**
    ```css
    @custom-variant dark (&:where(.dark, .dark *));
    ```

### **目的:**
- ダークモードのUIデザイン原則を理解する
- Tailwind CSSの`dark:`機能の実践的な活用法を習得する
- 一貫性のあるカラースキームの実装方法を学ぶ

### **実装のためのヒント:**
#### 1. 調整が必要な主要コンポーネント
```tsx
// クイズ作成ページのフォーム入力欄
<input
  className="w-full border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-md shadow-sm p-2 border"
/>

// エラーメッセージ
<div className="bg-red-100 dark:bg-red-900/20 border-l-4 border-red-500 dark:border-red-400 text-red-700 dark:text-red-400 p-4">
  {error}
</div>

// 選択肢カード（QuizForm.tsx）
<div className={`border rounded-lg p-3 cursor-pointer transition-colors ${
  selectedOption === index 
    ? 'bg-blue-100 dark:bg-blue-900/30 border-blue-500' 
    : 'hover:bg-gray-100 dark:hover:bg-gray-700 border-gray-300 dark:border-gray-600'
}`}>
```

#### 2. よく使うダークモードパターン
- 背景色: `bg-white dark:bg-gray-800`
- テキスト: `text-gray-900 dark:text-gray-100`
- ボーダー: `border-gray-300 dark:border-gray-600`
- ホバー: `hover:bg-gray-100 dark:hover:bg-gray-700`

### **ヒント:**
- 背景色は純黒（`bg-black`）ではなく、`bg-gray-800`や`bg-gray-900`を使用
- コントラストを保ちつつ、明度を調整して目に優しい配色に
- `transition-colors`を追加すると、モード切替時の体験が向上

![15.png](https://image.docbase.io/uploads/a774c919-2563-4888-9063-98e927e9aaf5.png =WxH)


<div style="page-break-before:always"></div>

## **15. レンダリングモード理解 & 最適化**
### **問題概要:**
Next.js App Routerでのレンダリングパターンを理解し、効率的なデータ取得を実装してください。

### **詳細:**
1. **キャッシュの活用:**
    - クイズ一覧ページに適切なキャッシュ戦略を適用
    - `revalidate`を使用した定期的なデータ更新の実装

2. **レンダリング方式の理解:**
    - SSR、ISR、静的レンダリングの違いを理解
   
### **目的:**
- Next.js App Routerのデータフェッチングパターンを理解する
- キャッシュを活用したパフォーマンス最適化を学ぶ
- 実務で使用頻度の高いISRパターンを習得する

### **注意点:**
- App Routerは動的な機能（cookies、headers、searchParams等）を使用すると自動的にSSRになります
- `revalidate`を設定することで、ISR（Incremental Static Regeneration）として動作します
- 開発環境（`npm run dev`）では常に最新のデータが表示されるため、本番環境（`npm run build && npm run start`）で確認してください

### **ヒント:**
- データ取得パターンに応じてキャッシュ戦略を選択する：
    - 頻繁に更新するデータ → `cache: 'no-store'`（SSR）
    - 定期的に更新するデータ → `revalidate`（ISR）
    - ほとんど変わらないデータ → キャッシュオプションなし（永続キャッシュ）
- 今回のクイズアプリでは、新しいクイズが追加されることを考慮して、ISR（60秒ごとの更新）としています
- `export const revalidate = 60;`を追加するだけで、パフォーマンスと最新性のバランスが取れた実装になります

<div style="page-break-before:always"></div>


## **16. 単体テスト（local環境版）**

### **問題概要:**
Jestを使用して、作成したクイズアプリの主要な機能に対する簡単な単体テストを実装してください。

### **詳細:**
1. **テスト環境のセットアップ:**
    - Jestと必要なパッケージのインストール
    - テスト設定ファイルの作成
2. **実装するテスト:**
    - Reduxスライスのテスト（quizSlice）
    - ユーティリティ関数のテスト（スコア計算など）
    - 簡単なコンポーネントテスト（ThemeToggle）

### **目的:**
- Jestの基本的な使い方を学ぶ
- Redux ToolkitのSliceのテスト方法を理解する
- React Testing Libraryの基礎を習得する
- テスト駆動開発の重要性を理解する

### **実装のためのヒント:**
#### 1. 必要なパッケージのインストール
```bash
npm install -D jest @testing-library/react @testing-library/jest-dom jest-environment-jsdom @types/jest
```

#### 2. Jest設定ファイルの作成
```javascript
// jest.config.js
const nextJest = require('next/jest')

const createJestConfig = nextJest({
  // Next.jsアプリケーションのルートディレクトリを指定
  dir: './',
})

const customJestConfig = {
  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
  testEnvironment: 'jest-environment-jsdom',
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/$1',
  },
  // カバレッジ設定
  collectCoverageFrom: [
    'app/**/*.{js,jsx,ts,tsx}',
    'components/**/*.{js,jsx,ts,tsx}',
    'lib/**/*.{js,jsx,ts,tsx}',
    'util/**/*.{js,jsx,ts,tsx}',
    '!**/*.d.ts',
    '!**/node_modules/**',
    '!**/.next/**',
  ],
}

module.exports = createJestConfig(customJestConfig)
```

```javascript
// jest.setup.js
import '@testing-library/jest-dom'
```

#### 3. package.jsonにテストスクリプトを追加
```json
{
  "scripts": {
    // 既存のスクリプト...
    "test": "jest",
    "test:watch": "jest --watchAll"
  }
}
```

#### 4. テストファイルの作成
##### Redux Sliceのテスト
```typescript
// lib/features/quiz/__tests__/quizSlice.test.ts
import quizReducer, { 
  startQuiz, 
  setAnswer, 
  nextQuestion, 
  resetQuiz 
} from '../quizSlice';

describe('quizSlice', () => {
  const initialState = {
    currentQuestionIndex: 0,
    answers: [],
    quizId: null,
  };

  it('初期状態を返す', () => {
    expect(quizReducer(undefined, { type: 'unknown' })).toEqual(initialState);
  });

  it('クイズを開始できる', () => {
    const actual = quizReducer(initialState, startQuiz({ 
      quizId: 1, 
      questionCount: 3 
    }));
    
    expect(actual.quizId).toEqual(1);
    expect(actual.answers).toEqual([-1, -1, -1]);
    expect(actual.currentQuestionIndex).toEqual(0);
  });

  it('回答を記録できる', () => {
    const startedState = {
      currentQuestionIndex: 0,
      answers: [-1, -1, -1],
      quizId: 1,
    };
    
    const actual = quizReducer(startedState, setAnswer({
      questionIndex: 0,
      selectedOptionIndex: 2
    }));
    
    expect(actual.answers[0]).toEqual(2);
  });

  it('次の問題へ進める', () => {
    const state = {
      currentQuestionIndex: 0,
      answers: [1, -1, -1],
      quizId: 1,
    };
    
    const actual = quizReducer(state, nextQuestion());
    expect(actual.currentQuestionIndex).toEqual(1);
  });

  it('クイズをリセットできる', () => {
    const state = {
      currentQuestionIndex: 2,
      answers: [1, 0, 2],
      quizId: 1,
    };
    
    const actual = quizReducer(state, resetQuiz());
    expect(actual).toEqual(initialState);
  });
});
```

##### ユーティリティ関数のテスト
```typescript
// utils/quiz.ts
export function calculateScore(answers: number[], correctAnswers: number[]): number {
  if (answers.length !== correctAnswers.length) {
    throw new Error('回答数と問題数が一致しません');
  }
  
  return answers.reduce((score, answer, index) => {
    return score + (answer === correctAnswers[index] ? 1 : 0);
  }, 0);
}

export function getScoreMessage(score: number, total: number): string {
  const percentage = (score / total) * 100;
  
  if (percentage === 100) return '満点です！素晴らしい！';
  if (percentage >= 70) return 'よくできました！';
  if (percentage >= 50) return '合格です！';
  return 'もう一度チャレンジしてみましょう！';
}
```

```typescript
// utils/__tests__/quiz.test.ts
import { calculateScore, getScoreMessage } from '../quiz';

describe('calculateScore', () => {
  it('正解数を正しく計算する', () => {
    const answers = [0, 1, 2];
    const correctAnswers = [0, 1, 2];
    expect(calculateScore(answers, correctAnswers)).toBe(3);
  });

  it('部分的に正解の場合も正しく計算する', () => {
    const answers = [0, 1, 1];
    const correctAnswers = [0, 1, 2];
    expect(calculateScore(answers, correctAnswers)).toBe(2);
  });

  it('全問不正解の場合は0を返す', () => {
    const answers = [1, 2, 3];
    const correctAnswers = [0, 0, 0];
    expect(calculateScore(answers, correctAnswers)).toBe(0);
  });

  it('配列の長さが異なる場合はエラーを投げる', () => {
    const answers = [0, 1];
    const correctAnswers = [0, 1, 2];
    expect(() => calculateScore(answers, correctAnswers)).toThrow(
      '回答数と問題数が一致しません'
    );
  });
});

describe('getScoreMessage', () => {
  it('満点の場合のメッセージ', () => {
    expect(getScoreMessage(5, 5)).toBe('満点です！素晴らしい！');
  });

  it('70%以上の場合のメッセージ', () => {
    expect(getScoreMessage(7, 10)).toBe('よくできました！');
  });

  it('50%以上の場合のメッセージ', () => {
    expect(getScoreMessage(5, 10)).toBe('合格です！');
  });

  it('50%未満の場合のメッセージ', () => {
    expect(getScoreMessage(4, 10)).toBe('もう一度チャレンジしてみましょう！');
  });
});
```

##### コンポーネントテスト
```typescript
// components/__tests__/ThemeToggle.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import { Provider } from 'react-redux';
import { configureStore } from '@reduxjs/toolkit';
import ThemeToggle from '../ThemeToggle';
import themeReducer from '@/lib/features/theme/themeSlice';

// テスト用のストアを作成
function renderWithProviders(component: React.ReactElement) {
  const store = configureStore({
    reducer: {
      theme: themeReducer,
    },
  });

  return render(
    <Provider store={store}>
      {component}
    </Provider>
  );
}

describe('ThemeToggle', () => {
  it('ボタンが表示される', () => {
    renderWithProviders(<ThemeToggle />);
    const button = screen.getByRole('button', { name: 'ダークモード切替' });
    expect(button).toBeInTheDocument();
  });

  it('クリックでダークモードが切り替わる', () => {
    renderWithProviders(<ThemeToggle />);
    const button = screen.getByRole('button', { name: 'ダークモード切替' });
    
    // 初期状態では月アイコン（SVGの一部）が表示される
    expect(screen.getByRole('button')).toBeInTheDocument();
    
    // クリック後はHTMLクラスが追加される
    fireEvent.click(button);
    expect(document.documentElement.classList.contains('dark')).toBe(true);
    
    // 再度クリックすると元に戻る
    fireEvent.click(button);
    expect(document.documentElement.classList.contains('dark')).toBe(false);
  });
});
```

### **実行方法:**
```bash
# すべてのテストを実行
npm test

# ウォッチモードでテストを実行（ファイル変更を監視）
npm run test:watch
```

### **ヒント:**

- テストファイルは`__tests__`フォルダまたは`.test.ts`/`.test.tsx`拡張子で作成
- `describe`でテストをグループ化し、`it`または`test`で個別のテストを記述
- `expect`で期待値と実際の値を比較
- Reduxのテストではreducerに直接アクションを渡してテスト
- コンポーネントテストではRedux Providerでラップする必要がある

この実装により、基本的なテストの書き方を学び、今後の開発でテスト駆動開発（TDD）を実践できる基礎が身につきます。

<div style="page-break-before:always"></div>


## **16. 単体テスト（StackBlitz対応版）**
### **問題概要:**
Jestを使用して、作成したクイズアプリの主要な機能に対する簡単な単体テストを実装してください。
※StackBlitz環境ではネイティブアドオンが使用できないため、Babelを使用するように設定を変更する必要があります。

### **詳細:**
1. **テスト環境のセットアップ:**
    - Jestと必要なパッケージのインストール
    - Babel設定の追加
    - テスト設定ファイルの作成

### **実装のためのヒント:**
#### 1. 必要なパッケージのインストール
```bash
# Babel関連のパッケージを含めてインストール
npm install -D jest @testing-library/react @testing-library/jest-dom jest-environment-jsdom @types/jest babel-jest @babel/core @babel/preset-env @babel/preset-react @babel/preset-typescript
```

#### 2. Jest設定ファイルの修正（StackBlitz対応）
```javascript
// jest.config.js
module.exports = {
  testEnvironment: 'jest-environment-jsdom',
  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
  transform: {
    '^.+\\.(js|jsx|ts|tsx)$': [
      'babel-jest',
      {
        presets: [
          '@babel/preset-env',
          ['@babel/preset-react', { runtime: 'automatic' }],
          '@babel/preset-typescript',
        ],
      },
    ],
  },
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/$1',
    '\\.(css|less|scss|sass)$': '<rootDir>/__mocks__/styleMock.js',
  },
  transformIgnorePatterns: ['node_modules/(?!(.*\\.mjs$))'],
  testPathIgnorePatterns: ['<rootDir>/.next/', '<rootDir>/node_modules/'],
  moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx'],
};
```

#### 3. 必要なモックファイルの作成
```javascript
// __mocks__/styleMock.js
module.exports = {};
```

```javascript
// __mocks__/next/navigation.js
module.exports = {
  useRouter: () => ({
    push: jest.fn(),
    replace: jest.fn(),
    prefetch: jest.fn(),
    back: jest.fn(),
  }),
  usePathname: () => '/test-path',
  useSearchParams: () => ({
    get: jest.fn(),
  }),
  notFound: jest.fn(),
};
```

```javascript
// __mocks__/next/link.js
export default function Link({ children, href }) {
  return <a href={href}>{children}</a>;
}
```

#### 4. jest.setup.jsの作成
```javascript
// jest.setup.js
import '@testing-library/jest-dom';

// グローバルなモックの設定
global.fetch = jest.fn();
```

#### 5. package.jsonにテストスクリプトを追加
```json
{
  "scripts": {
    // 既存のスクリプト...
    "test": "jest",
    "test:watch": "jest --watchAll"
  }
}
```

#### 6. テストファイルの作成
##### Redux Sliceのテスト
```typescript
// lib/features/quiz/__tests__/quizSlice.test.ts
import quizReducer, { 
  startQuiz, 
  setAnswer, 
  nextQuestion, 
  resetQuiz 
} from '../quizSlice';

describe('quizSlice', () => {
  const initialState = {
    currentQuestionIndex: 0,
    answers: [],
    quizId: null,
  };

  it('初期状態を返す', () => {
    expect(quizReducer(undefined, { type: 'unknown' })).toEqual(initialState);
  });

  it('クイズを開始できる', () => {
    const actual = quizReducer(initialState, startQuiz({ 
      quizId: 1, 
      questionCount: 3 
    }));
    
    expect(actual.quizId).toEqual(1);
    expect(actual.answers).toEqual([-1, -1, -1]);
    expect(actual.currentQuestionIndex).toEqual(0);
  });

  it('回答を記録できる', () => {
    const startedState = {
      currentQuestionIndex: 0,
      answers: [-1, -1, -1],
      quizId: 1,
    };
    
    const actual = quizReducer(startedState, setAnswer({
      questionIndex: 0,
      selectedOptionIndex: 2
    }));
    
    expect(actual.answers[0]).toEqual(2);
  });
});
```

##### ユーティリティ関数のテスト
```typescript
// utils/quiz.ts
export function calculateScore(answers: number[], correctAnswers: number[]): number {
  if (answers.length !== correctAnswers.length) {
    throw new Error('回答数と問題数が一致しません');
  }
  
  return answers.reduce((score, answer, index) => {
    return score + (answer === correctAnswers[index] ? 1 : 0);
  }, 0);
}
```

```typescript
// utils/__tests__/quiz.test.ts
import { calculateScore } from '../quiz';

describe('calculateScore', () => {
  it('正解数を正しく計算する', () => {
    const answers = [0, 1, 2];
    const correctAnswers = [0, 1, 2];
    expect(calculateScore(answers, correctAnswers)).toBe(3);
  });

  it('部分的に正解の場合も正しく計算する', () => {
    const answers = [0, 1, 1];
    const correctAnswers = [0, 1, 2];
    expect(calculateScore(answers, correctAnswers)).toBe(2);
  });

  it('配列の長さが異なる場合はエラーを投げる', () => {
    const answers = [0, 1];
    const correctAnswers = [0, 1, 2];
    expect(() => calculateScore(answers, correctAnswers)).toThrow(
      '回答数と問題数が一致しません'
    );
  });
});
```

##### コンポーネントテスト
```typescript
// components/__tests__/ThemeToggle.test.tsx
import React from 'react';  // 明示的にReactをインポート
import { render, screen, fireEvent } from '@testing-library/react';
import { Provider } from 'react-redux';
import { configureStore } from '@reduxjs/toolkit';
import ThemeToggle from '../ThemeToggle';
import themeReducer from '@/lib/features/theme/themeSlice';

// テスト用のストアを作成
function renderWithProviders(component: React.ReactElement) {
  const store = configureStore({
    reducer: {
      theme: themeReducer,
    },
  });

  return render(
    <Provider store={store}>
      {component}
    </Provider>
  );
}

// documentオブジェクトのモック
beforeEach(() => {
  // documentElementのモック
  Object.defineProperty(document, 'documentElement', {
    writable: true,
    value: {
      classList: {
        add: jest.fn(),
        remove: jest.fn(),
        contains: jest.fn(() => false),
      },
    },
  });
});

describe('ThemeToggle', () => {
  it('ボタンが表示される', () => {
    renderWithProviders(<ThemeToggle />);
    const button = screen.getByRole('button', { name: 'ダークモード切替' });
    expect(button).toBeInTheDocument();
  });

  it('クリックでダークモードが切り替わる', () => {
    renderWithProviders(<ThemeToggle />);
    const button = screen.getByRole('button', { name: 'ダークモード切替' });
    
    // 初期状態の確認
    expect(button).toBeInTheDocument();
    
    // クリック後はHTMLクラスが追加される
    fireEvent.click(button);
    expect(document.documentElement.classList.add).toHaveBeenCalledWith('dark');
    
    // モックをリセット
    jest.clearAllMocks();
    
    // 再度クリックすると元に戻る（実際の動作はReduxの状態に依存）
    // このテストでは単純化のため、関数が呼ばれることだけを確認
  });
});
```

### **実行方法:**
```bash
# すべてのテストを実行
npm test

# ウォッチモードでテストを実行
npm run test:watch

# カバレッジレポートを生成
npm test -- --coverage
```

### **ポイント:**
- StackBlitz環境ではSWCが使用できないため、Babelを使用してトランスパイルします
- Next.jsのモジュールは手動でモックする必要があります
- シンプルなテストから始めて、徐々に複雑なテストに移行しましょう
- テストファイルは`__tests__`フォルダまたは`.test.ts`拡張子で作成します

![17.png](https://image.docbase.io/uploads/b0e37e46-5e22-43f1-9078-ba7c617a7a5b.png =WxH)

<div style="page-break-before:always"></div>

## その他のテストケース
### **1. フォームバリデーションのテスト**
- **クイズ作成ページのバリデーション関数**
    - 空のタイトルチェック
    - 問題文が空の場合のエラー
    - 選択肢が2つ未満の場合のエラー
    - 正解が選択されていない場合のエラー

### **2. APIルートのテスト**
- **GET /api/quizzes**
    - 正常なレスポンスの確認
    - ファイルが存在しない場合のエラーハンドリング
- **POST /api/quizzes**
    - 正常なデータ保存の確認
    - 不正なデータの場合のバリデーションエラー

### **3. 統合的なテストシナリオ**
- **クイズ挑戦の流れ**
    - 問題表示 → 選択 → 次へ → 結果表示の一連の流れ
    - Reduxストアの状態変化を追跡
- **結果計算のE2Eテスト**
    - 複数の回答パターンでの正解数計算
    - エッジケース（全問正解、全問不正解）

などのケースが存在します。
ぜひチャレンジしてみてください。



<div style="page-break-before:always"></div>

![Pasted image 20250516083144.png](https://image.docbase.io/uploads/17c96e36-2c3a-4a8f-ad02-1256aa76320b.png =WxH)
![Pasted image 20250516083221.png](https://image.docbase.io/uploads/886e9aef-1caa-4555-a2c4-daa864210657.png =WxH)