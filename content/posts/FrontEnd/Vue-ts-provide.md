---
title: "[Typescript] Typescript 用 InjectionKey 達成強型別 provide"
date: 2022-11-17T10:51:00+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[Vue] TS-Provide"
    identifier: frontend-vue-ts-provide
    parent: frontend
    weight: 1000
---
上游元件
```html
<script lang="ts">
import { InjectionKey, provide, reactive } from 'vue';
// State
export interface IState {
  drawer: boolean;
}
export const stateKey: InjectionKey<IState> = Symbol();
const state = reactive<IState>({
  drawer: false,
});
provide<IState>(stateKey, state);
</script>
```
下游元件
```html
<script setup lang="ts">
import { inject } from 'vue';
import { stateKey } from './Parent.vue';

const state = inject(stateKey, { drawer: false });
</script>
```
## Reference
 - [台部落 - 如何在 vue3 中提供一個類型安全的 inject 前提準備...](https://www.twblogs.net/a/60e3a1911cf175147a0e1951)