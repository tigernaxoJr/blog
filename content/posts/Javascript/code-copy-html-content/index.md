---
title: "[Code] 複製元件內的文字"
date: 2020-11-13T06:26:00+08:00
hero: 
menu:
  sidebar:
    name: "[Code] 複製元件內的文字"
    identifier: jscode-copy-html-content
    parent: Javascript
    weight: 2000
---
要在前端用 JavaScript 將 DOM 的內容複製到剪貼簿有幾種姿勢：
## Clipboard API
基本上目前(2020年底)，主流瀏覽器近期版本都支援了，如果不考慮 IE 的話倒是可以使用，語法精簡而且能非同步操作。
 - 不支援 IE
 - 是非同步方法，會傳回 Promise
 - 支援從變數直接複製到剪貼簿
 - 只有 HTTPS 網頁可以使用此 API
 - Chrome 66 之後透過 Clipboard 複製已經不會彈出提示視窗
 - 只能在 active tab 發生作用 (a.k.a. 開發者無法在 colsole 做測試，會得到 `DOMException: Document is not focused.`)
 ```js
 function copyText(text) {

    // 判斷瀏覽器支援
    if (!navigator.clipboard) {
        alert("瀏覽器不支援 Clipboard API")
        // 這裡可以改用 document.execCommand('copy') 的方法
    }

    // 非同步複製至剪貼簿
    let resolve = () => { 
        console.log('透過 Clipboard 複製至剪貼簿成功'); 
    }
    let reject = (err) => { 
        console.error('透過 Clipboard 複製至剪貼簿失敗:' + err.toString() ); 
    }
    navigator.clipboard.writeText(text).then(resolve, reject);
}
 ```
## 複製隱藏元素
document.execCommand('copy')
 - 瀏覽器相容性最佳(支援IE)
 - 是同步方法
 - 只能從 DOM 擷取內容放到剪貼簿
 - 只有 IE 會彈出提示視窗
 - 可在 colsole 以指令測試。
 ```js
 // 這個 function 接收要複製的文字，從 dom 取值出來丟進去複製即可
// 同理可製作接收 dom 為參數直接取值複製的版本，但不太符合單一職責原則
function copyText(text) {
    // 設置一個剪貼用的隱藏 textarea
    var el = document.createElement("textarea");
    el.value = text;
    el.style.display="none";

    // 選取該 textarea
    document.body.appendChild(el);
    el.focus();
    el.select();

    // 複製文字內容
    document.execCommand('copy');

    // 移除該元素
    document.body.removeChild(el);
}
 ```
## 比較
|                 	| Clipboard API 	| document.execCommand('copy') 	|
|-----------------	|---------------	|------------------------------	|
| 在 colsole 測試 	| 不可          	| 可                           	|
| IE 支援性       	| 不支援        	| 支援                         	|
| HTTP可用        	| 不可(HTTPS only) | 可                           	|
| 同步/非同步     	| 非同步        	| 同步                         	|
| 複製原理        	| 值->剪貼簿    	| 值->隱藏元素->剪貼簿         	|

## Reference
- [StackOverflow - How do I copy to the clipboard in JavaScript?](https://stackoverflow.com/questions/400212/how-do-i-copy-to-the-clipboard-in-javascript?page=1&tab=votes)
- [MDN - Clipboard API](https://developer.mozilla.org/en-US/docs/Web/API/Clipboard_API)