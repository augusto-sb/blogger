import { createApp } from 'vue'
import './style.css'
import App from './App.vue'

console.log(import.meta.env.VITE_MESSAGE)

createApp(App).mount('#app')
