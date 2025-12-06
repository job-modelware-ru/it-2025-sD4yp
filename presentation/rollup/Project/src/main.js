import "./style.css"
import "./extra.css"
import { message } from "./module1.js"
import { plus } from "./utils/helper.js"
import cjsValue from "./module2.cjs"
import _ from "lodash"
import dayjs from "dayjs"

console.log("Main start")
console.log("Message:", message)
console.log("Sum:", plus(10, 20))
console.log("CommonJS value:", cjsValue)
console.log("Lodash chunk:", _.chunk([1,2,3,4,5], 2))
console.log("Today:", dayjs().format("DD.MM.YYYY"))

