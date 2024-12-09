%dw 2.0
output application/json
var checklist = p('skipErrors') splitBy ", "

---
(checklist map ((item, index) -> vars.ErrorDescription contains item)) contains true