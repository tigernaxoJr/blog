---
title: "[Typescript] Typescript 用 InjectionKey 達成強型別 provide"
date: 2022-11-17T11:49:00+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[Vue] TS-Provide"
    identifier: frontend-vue-ts-provide
    parent: frontend
    weight: 1000
---
Working with Reactivity
上游元件
```html
<script lang="ts">
import { InjectionKey, provide, Ref, reactive } from 'vue';
// State
export interface IState {
  drawer: boolean;
}
export const stateKey: InjectionKey<Ref<IState>> = Symbol();
const state = reactive<IState>({
  drawer: false,
});
provide<IState>(stateKey, computed(()=>state));
</script>
```
下游元件
```html
<script setup lang="ts">
import { inject, ref } from 'vue';
import { stateKey } from './Parent.vue';

const state = inject(stateKey, ref({ drawer: false }));
</script>
```
## Reference
 - [Vue.js/guild - Provide / Inject](https://vuejs.org/guide/components/provide-inject.html)
 - [Vue.js/api - Composition API: Dependency Injection](https://vuejs.org/api/composition-api-dependency-injection.html)