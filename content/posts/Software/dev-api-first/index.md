---
title: "[開發] API-first approach"
date: 2025-06-10T10:34:00+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[開發] API-first approach"
    identifier: software-dev-api-first
    parent: software
    weight: 1000
---
## 高效協作的基石：深入理解 API-First 開發方法
在現代軟體開發的浪潮中，追求更快的交付速度、更敏捷的反應能力，以及更優質的使用者體驗，是所有團隊的共同目標。傳統的瀑布式開發流程，因其僵化和漫長的等待週期，已逐漸無法滿足市場的快速變化。為此，「API-First」開發方法應運而生，它不僅僅是一種技術實踐，更是一種推動團隊高效協作的開發哲學。

本文將深入探討 API-First 的核心概念，比較其與傳統開發流程的差異，分析其優劣，並提供在前端專案中實踐 API Mock 的具體教學。

### 什麼是 API-First Approach？
**API-First (API 優先)** 是一種軟體開發策略，其核心精神是**將 API (應用程式介面) 視為整個產品的核心與一等公民 (First-class Citizen)。**

在開發啟動之初，不再是先設計資料庫或撰寫後端邏輯，而是由前後端團隊，甚至包含產品、設計團隊，共同協商並定義出一份清晰、嚴謹的 **API 契約 (API Contract)**。這份契約詳細描述了 API 的路由、請求方法、參數、數據格式以及回傳的響應內容。

這份契約一旦確立，就成為前後端各自開發的共同依據。後端團隊依照契約實作業務邏輯與資料庫；前端團隊則可以立即使用這份契約，搭配 Mock (模擬) 技術來打造使用者介面，無需等待後端 API 的實際完成。

最常用來定義 API 契約的工具是 **OpenAPI 規範 (前身為 Swagger)**。它提供了一套標準化的格式 (通常是 YAML 或 JSON)，讓人類和機器都能輕鬆理解 API 的功能與結構。

> 核心理念： 先定義好軟體元件之間如何溝通 (API)，再各自實現內部邏輯。

## 典範轉移：API-First vs. 傳統開發流程
為了更清晰地理解 API-First 帶來的變革，我們從幾個關鍵維度來比較它與傳統開發流程的差異。
|比較維度	|傳統開發流程 (Database-First)	|API-First 開發流程|
|-|-|-|
|**開發啟動點**|	**資料庫先行**：設計資料庫結構 -> 開發後端 API -> 前端串接。	|**契約先行**：前後端共同定義 API 契約。|
|**團隊依賴性**|	**強烈的上下游依賴**：前端強烈依賴後端，後端依賴資料庫設計。任何上游變動都會造成下游阻塞。|	**並行開發**：前後端解耦，可同時進行開發。前端依賴的是「契約」，而非「已完成的後端程式」。|
|**前後端溝通**|	**後端主導**：後端開發完 API 後，提供給前端使用，前端常處於被動接收的角色。溝通多發生在整合階段。|	**協同合作**：開發初期就共同協商 API 規格。前端甚至能主導介面規格，因為他們最了解介面需要什麼資料。|
|**迭代速度**|	**緩慢且僵化**：任何需求變更都可能需要從資料庫層級開始修改，牽一髮動全身，迭代週期長。	|**快速且敏捷**：前端可以基於 Mock 數據快速迭代 UI/UX，不受後端進度限制，非常適合敏捷開發中的快速原型和頻繁調整。|
|**錯誤發現時機**|	**後期整合階段**：許多介面不匹配、資料格式錯誤的問題，直到最後整合測試時才會浮現，修復成本高。	|**開發初期**：由於 API 契約先行，規格不一致的問題在設計階段就被解決。介面和使用者體驗問題也能在早期透過原型被發現。|

## API-First 的優點與挑戰
採用 API-First 方法能帶來顯著的好處，但同時也伴隨著一些需要克服的挑戰。

### ✅ 優點
1. 加速產品上市時間 (Faster Time to Market)：前後端並行開發，消除了傳統流程中的等待時間，顯著縮短了從概念到上線的總體開發週期。
2. 提升使用者體驗 (Improved User Experience)：UI/UX 的開發和迭代可以更早開始，並快速產出可操作的原型以收集使用者回饋，確保最終產品更貼近使用者需求。
3. 降低團隊依賴性 (Reduced Dependencies)：透過 API Mock，前端開發不再被後端進度所束縛，開發流程更加流暢。
4. 清晰的 API 契約：在開發初期共同定義的 API 契約，如同雙方的「法律文件」，有效避免了後期整合時的誤解、扯皮和返工。
5. 早期發現問題：介面邏輯、資料需求、甚至是潛在的業務邏輯漏洞，都可以在產品的早期階段就被發現和修正，降低修復成本。
6. 更好的進度可視化：即使後端服務尚未完成，前端也能提供一個功能完整的可操作介面給專案關係人 (Stakeholders) 審查，讓進度更加透明。
### ⚠️ 挑戰 (缺點)
1. 需嚴格管理 API 契約：API 契約是協作的基石。如果契約沒有被嚴格遵守或在開發過程中頻繁無序地變動，將會導致整合時的混亂，甚至需要大量返工。
2. 模擬數據的準確性：Mock 數據可能無法完全反映真實後端數據的複雜性、邊界條件和錯誤情況。開發時需注意，整合真實 API 時仍可能發現新問題。
3. 前期溝通成本較高：雖然減少了後期的整合成本，但 API-First 將大量的溝通工作前提至專案初期。團隊需要投入時間進行有效的討論和協商。
4. 可能忽略底層複雜性：若過於關注前端介面需求，有時可能會低估後端實現所需數據模型或業務邏輯的複雜性，導致後端開發時遇到意想不到的困難。
5. 對開發人員技能要求更高：前端開發人員需要具備 API 設計的思維，甚至需要掌握 Mock Server 的搭建能力。

## 實戰：在 Vite 前端專案中實現 API Mock
理論結合實踐，才能真正掌握 API-First 的精髓。前端團隊的關鍵任務之一，就是根據 API 契約建立 Mock API。這裡我們以目前主流的 Vite 專案為例，介紹如何使用強大的 `msw` (Mock Service Worker) 工具庫來實現。

`msw` 的最大優勢在於它利用 Service Worker 技術在瀏覽器層面攔截網路請求，對你的應用程式碼是完全透明的，無需修改任何 fetch 或 axios 的邏輯，實現了零侵入的 Mock。

### 步驟 1：安裝 msw
在 Vite 專案根目錄下，執行以下指令：
```bash
npm install msw --save-dev
# 或者
yarn add msw --dev
```
### 步驟 2：建立 Mock 請求處理器 (Handlers)
這是定義 API Mock 行為的地方，相當於 Mock 版本的後端路由。

在 src 目錄下建立一個 mocks 資料夾。
在 src/mocks 中建立 handlers.js 檔案
```js
// src/mocks/handlers.js
import { http, HttpResponse } from 'msw';

// 定義你的 API Mock 列表
export const handlers = [
  // 攔截 GET /api/users 請求
  http.get('/api/users', () => {
    // 模擬成功的回應
    return HttpResponse.json(
      [
        { id: 1, name: '愛麗絲 (來自 Mock)' },
        { id: 2, name: '鮑伯 (來自 Mock)' },
      ],
      { status: 200 }
    );
  }),

  // 攔截 POST /api/posts 請求
  http.post('/api/posts', async ({ request }) => {
    // 解析請求的 body
    const newPost = await request.json();
    console.log('Mock Server 收到的 POST 資料:', newPost);

    // 模擬創建成功後的回應
    return HttpResponse.json(
      { 
        id: `mock_${Math.random().toString(36).substr(2, 9)}`, 
        ...newPost 
      },
      { status: 201 } // 狀態碼 201 表示資源已創建
    );
  }),

  // 模擬一個錯誤回應
  http.get('/api/error-endpoint', () => {
    return HttpResponse.json(
      { message: '這是一個模擬的伺服器錯誤！' },
      { status: 500 }
    );
  }),
];
```
### 步驟 3：設定瀏覽器環境的 Service Worker
1. 在 src/mocks 中建立 browser.js 檔案。
```js
// src/mocks/browser.js
import { setupWorker } from 'msw/browser';
import { handlers } from './handlers';

// 設定一個使用我們定義的 handlers 的 Service Worker
export const worker = setupWorker(...handlers);
```
### 步驟 4：在開發環境中啟動 Mock Service
最後，我們需要修改應用程式的入口文件 (通常是 src/main.jsx 或 src/main.tsx)，讓 msw 只在開發模式下啟動。
```js
import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import router from './router'
import { createPinia } from 'pinia'


const enableMocking = async ()=>{
  if(import.meta.env.MODE === 'development'){
    return;
  }
  const { worker } = await import('./mocks/browser');
  // `onunhandledrequest: 'bypass'` 能夠讓 msw 忽略那些
  // 我們沒有在 handlers 中定義的請求 (例如請求 css, svg 檔案)
  worker.start({
    onUnhandledRequest: 'bypass',
  });
}

enableMocking().then(()=>{
  const app = createApp(App)
  const pinia = createPinia();

  app.use(router) // 使用 router
  app.use(pinia); // 使用 pinia

  app.mount('#app')
})
```
現在，當你啟動 Vite 開發伺服器 (npm run dev)，打開瀏覽器的開發者工具，你會在 Console 看到 [MSW] Mocking enabled. 的訊息。此時，你在應用中發出的 /api/users 請求將會被 msw 攔截，並返回你在 handlers.js 中定義的模擬數據，而無需任何後端伺服器！

## 結論
API-First 並非銀彈，但它確實是現代敏捷開發中一種極其高效的協作策略。 它並非要削弱後端或資料庫的重要性，而是透過重新定義團隊的協作順序——從「依賴等待」轉變為「契約並行」——來達到解耦前後端、加速開發流程、並將使用者體驗置於更優先位置的目的。

成功實施 API-First 的關鍵在於：建立清晰、穩定、且團隊共識的 API 契約，並輔以順暢的溝通機制和可靠的 Mock 工具。 當團隊能夠擁抱這種思維轉變，便能更從容地應對複雜的需求，更快地將價值交付給使用者。

# Reference
- [mswjs/msw](https://github.com/mswjs/msw)