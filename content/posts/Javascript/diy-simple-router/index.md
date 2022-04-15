---
title: "[DIY] 用Typescript搭建簡易前端路由"
date: 2020-11-13T06:26:00+08:00
hero: 
menu:
  sidebar:
    name: "[DIY] 用Typescript搭建簡易前端路由"
    identifier: jsdiy-simple-router
    parent: Javascript
    weight: 3000
---
起始一個使用 vallina-ts 的 vite 專案並安裝套件，並使用 bootstrap 做簡單的 css 套用：
```bash
npm init vite@latest route-test
#依序選擇 vallina->vallina-ts

cd route-test 
npm i  # 安裝套件
npm i bootstrap # 安裝 bootstrap
```
在 index.html 新增元素 app
{{< highlight html "hl_lines=10-13" >}}
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="favicon.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Vite App</title>
  </head>
  <body>
    <div id="app" class="container-fluid">
      <div id="menu" class="row g-0"></div>
      <div id="root" class="row g-0"></div>
    </div>
    <script type="module" src="/src/main.ts"></script>
  </body>
</html>
{{< /highlight >}}

建立三個頁面檔案，分別是 `src/view/Home.ts`、`src/view/About.ts`、`src/view/PageNotFound.ts`，
這三個檔案是 typescript module，實作如下：
```ts
// Home.ts
export default {
	name: 'Home',
	render(): HTMLElement{
		let el = document.createElement('div');
		el.innerHTML = ` Home `;
		return el;
	}
}
// About.ts
export default {
	name: 'About',
	render(): HTMLElement{
		let el = document.createElement('div');
		el.innerHTML = ` About `;
		return el;
	}
}
// PageNotFound.ts
export default {
	name: 'PageNotFound',
	render(): HTMLElement{
		let el = document.createElement('div');
		el.innerHTML = ` PageNotFound `;
		return el;
	}
}
```

接著 `src/main.ts` 程式長這樣：
```ts
import './style.css'
import 'bootstrap/dist/css/bootstrap.min.css'
import About from './view/About'
import Home from './view/Home'
import NotFound from './view/NotFound'

// 介面宣告
export interface IRoute {
  name: string,
  render: () => HTMLElement
}

// 物件宣告
let loaded: boolean = false // 頁面是否已首次載入
// 路由對應
const routes: Map<string, IRoute> = new Map([
  ['/Home', Home],
  ['/About', About],
])
const rootDiv = <HTMLElement>document.getElementById('root') // 路由頁面所在的節點
const menuDiv = <HTMLElement>document.getElementById('menu') // menu 清單所在的節點

// 路由函式
function route(path: string = '/') {
  // 如果是首頁就導到 Home
  if(path === '/') {
    route('/Home')
    return 
  }
  // 如果不是第一次載入，則同路由不處理
  if(loaded && path.toLocaleLowerCase() === window.location.pathname.toLocaleLowerCase()) return
  let key = Array.from(routes.keys()).find(k=>k.toLocaleLowerCase() === path.toLocaleLowerCase())
  let page = key ? <IRoute>routes.get(key) : NotFound
  rootDiv.innerHTML = '' // 清空
  rootDiv.appendChild(page.render()); // 渲染
  window.history.pushState({}, route.name, window.location.origin + path)
}

// 載入時掛上 menu
window.onload = () => {
  routes.forEach(r=>{
    let item = document.createElement('div')
    item.classList.add('col', 'border')
    item.textContent = r.name
    item.addEventListener('click',()=> route(`/${r.name}`))
    menuDiv.appendChild(item)
  })
  route(window.location.pathname) // 載入的時候先做一次路由
  loaded = true // 設定載入完畢
}

// 攔截上一頁動作
window.onpopstate = ()=>{
  let path = window.location.pathname
  let page = routes.has(path) ? <IRoute>routes.get(path) : NotFound
  rootDiv.innerHTML = ''
  rootDiv.appendChild(page.render())
}
```

執行測試，至此完成
```bash
npm run dev
```