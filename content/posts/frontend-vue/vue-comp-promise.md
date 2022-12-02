---
title: "[DIY] 設計一個可回傳 Promise 的 Dialog 元件方法"
date: 2022-08-26T15:03:00+08:00
draft: false
hero: 
discription: asdf
menu:
  sidebar:
    name: "[元件] Promise 元件方法"
    identifier: frontend-vue-comp-promise
    parent: frontend-vue
    weight: 1000
---
有用過 [sweetalert2](https://sweetalert2.github.io/) 的話，應該會喜歡可以同步等待對話框回傳值的方式，
這裡做一個 Vue2 元件，呼叫該元件的方法會彈出對話框等待使用者輸入，並且回傳 Promise，
如此一來就能夠在同一個函式當中處理使用者輸入值。

Dialog 元件設計原理:
  1. 元件方法 GetConfirm() 顯示 Dialog 元件並回傳一個 Promise，。
  2. 設置[watcher](https://vuejs.org/v2/api/#vm-watch)讓元件取得使用者輸入後 resolve promise 

得利於上述元件的設計，實際上的效益是將複雜度封裝到子元件裡面(watcher移動到元件內)，
如此不需在上層元件撰寫使用者輸入取值的監視邏輯，
讓我們得以在上層元件直接 await GetConfirm 同步取得值進行操作。

這個概念的用途非常廣，例如 Vue router 的 component route guard，在離開表單頁面前跳出使用者確認的 Dialog。

## Vuejs 實作
```html
<button id="xBtn">執行測試</button>
<div id="xApp" class="modal" :style="{display: dialog?'block':'none'}">
  <div class="modal-content">
    <span class="close">Test Modal</span>
    <p>The value selected will resolve by promise.</p>
    <button @click="choose(1)">1</button>
    <button @click="choose(2)">2</button>
  </div>
</div>
```

```html
<script src="https://cdn.jsdelivr.net/npm/vue@2.x/dist/vue.js"></script>
 
<script>
let data = { result: null, dialog: false }
let dialog = new Vue({
  el: '#xApp',
  data:() => data,
  methods: {
   getConfirm() {
     // 先清空 result (避免兩次選中一樣的值無法觸發 watcher)
     this.result = null 
     // open dialog
     this.dialog = true 
     return new Promise((resolve, reject) => {
       try {
         const watcher = this.$watch(
           // 設置監視的對象為 result
           () => this.result ,
           // 一旦 result 的值有改變，就 resolve promise，並啟動下一輪 watcher 
           (newVal) => resolve(newVal) && watcher()
         )
       } catch (error) {
         // 如果出錯就 reject promise
         reject(error)
       }
     })
   },
   choose(value) {
     // 為 result 設置值觸發 watcher 解開 promise
     this.result = value 
     // 關閉 dialog
     this.dialog = false
   }
  }
})
document.getElementById('xBtn')
  .addEventListener( 'click', 
      async e => alert( await dialog.getConfirm() )
    );
</script>
```

```css
/* The Modal (background) */
.modal {
  display: none; /* Hidden by default */
  position: fixed; /* Stay in place */
  z-index: 1; /* Sit on top */
  padding-top: 100px; /* Location of the box */
  left: 0;
  top: 0;
  width: 100%; /* Full width */
  height: 100%; /* Full height */
  overflow: auto; /* Enable scroll if needed */
  background-color: rgb(0,0,0); /* Fallback color */
  background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
}

/* Modal Content */
.modal-content {
  background-color: #fefefe;
  margin: auto;
  padding: 20px;
  border: 1px solid #888;
  width: 80%;
}
```
## Vue-next 實作
這裡使用 vue-next/setup/quasar/typescript
### 程式碼
```html
<template>
  <q-dialog v-model="model" :persistent="persistent">
    <q-card>
      <slot>
        <q-card-section> {{ textComputed }} </q-card-section>
      </slot>
      <q-card-actions align="right">
        <slot name="action" :setter="SetResult">
          <q-btn dense color="primary" label="確認" @click="SetResult(true)" />
          <q-btn dense color="info" label="取消" @click="SetResult(false)" />
        </slot>
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue';
const model = ref(false);
const result = ref<unknown>(null);

interface IProps {
  text?: string;
  persistent?: boolean;
  width?: 'xs' | 'sm' | 'md' | 'lg' | 'max';
}
const props = withDefaults(defineProps<IProps>(), {
  text: '確認或取消？',
  persistent: true,
  width: 'max',
});

defineEmits(['input']);
const SetResult = (v: unknown) => (result.value = v);

const textTmp = ref<string | null>(null);
const textComputed = computed(() => textTmp.value || props.text);
async function GetResult(text: string | null = null) {
  textTmp.value = text || null;
  result.value = null;
  model.value = true;
  return new Promise((resolve, reject) => {
    console.log('new promise...');
    try {
      const watcher = watch(
        () => result.value,
        (cur) => {
          resolve(cur);
          watcher();
          model.value = false;
        }
      );
    } catch (error) {
      reject(error);
    }
  });
}
defineExpose({ SetResult, GetResult, model });
</script>
```
### 使用方法
```vue
<template>
  <!-- 確認 Dialog -->
  <DialogAsync ref="dlg" width="sm" />
  <q-btn @click="getUserInput()"> </q-btn>
</template>

<script setup lang="ts">
import DialogAsync from '../../components/DialogAsync/IndexPage.vue';
import { ref, Ref } from 'vue';

const dlg = ref(null);

// 顯示文字並取得使用者輸入的 true 或 false
const check = async (str?: string | null) =>
  await (dlg.value as typeof DialogAsync | null)?.GetResult(str);

const getUserInput = async () => {
  let result = await check('請確認')
  console.log('使用者選擇了：', result)
  }

</script>
```