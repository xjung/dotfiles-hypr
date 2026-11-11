" Vim syntax file for 1C:Enterprise (BSL) and OneScript.
"
" There is no tree-sitter grammar for BSL, so highlighting falls back to this
" file. bsl-language-server still supplies semantic tokens on top of it once it
" attaches, which is where types and locals get their colour.
"
" The language is case-insensitive and accepts Russian or English keywords
" interchangeably; both spellings are listed for every construct.

if exists("b:current_syntax")
  finish
endif

syntax case ignore

" Comments -------------------------------------------------------------------
syntax match bslComment "//.*$" contains=bslTodo,@Spell
syntax keyword bslTodo contained TODO FIXME XXX HACK NOTE ТОДО

" Literals -------------------------------------------------------------------
" Strings use "" as the escape for a literal quote, and a leading | continues
" a string onto the next line.
syntax region bslString start=+"+ skip=+""+ end=+"+ contains=bslStringContinue,@Spell
syntax match bslStringContinue contained "^\s*|"
syntax match bslDate "'\d\{8}\%(\d\{6}\)\='"
syntax match bslNumber "\<\d\+\%(\.\d\+\)\=\>"

" Declarations ---------------------------------------------------------------
syntax keyword bslStructure Процедура КонецПроцедуры Функция КонецФункции
syntax keyword bslStructure Procedure EndProcedure Function EndFunction
syntax keyword bslStorage Перем Знач Экспорт Var Val Export

" Control flow ---------------------------------------------------------------
syntax keyword bslConditional Если Тогда ИначеЕсли Иначе КонецЕсли
syntax keyword bslConditional If Then ElsIf Else EndIf
syntax keyword bslRepeat Для Каждого Из По Цикл КонецЦикла Пока
syntax keyword bslRepeat For Each In To Do EndDo While
syntax keyword bslStatement Возврат Прервать Продолжить Перейти
syntax keyword bslStatement Return Break Continue Goto
syntax keyword bslException Попытка Исключение КонецПопытки ВызватьИсключение
syntax keyword bslException Try Except EndTry Raise

" Operators and built-in values ----------------------------------------------
syntax keyword bslOperator И Или Не Новый And Or Not New
syntax keyword bslBoolean Истина Ложь True False
syntax keyword bslConstant Неопределено Undefined NULL
syntax keyword bslBuiltin Выполнить Вычислить Execute Eval
syntax match bslOperator "[-+*/<>=%]"

" Preprocessor and annotations -----------------------------------------------
syntax match bslPreProc "^\s*#\s*\%(Если\|ИначеЕсли\|Иначе\|КонецЕсли\|Тогда\)\>.*$"
syntax match bslPreProc "^\s*#\s*\%(If\|ElsIf\|Else\|EndIf\|Then\)\>.*$"
syntax match bslRegion "^\s*#\s*\%(Область\|КонецОбласти\|Region\|EndRegion\)\>.*$"
syntax match bslPreProc "^\s*#\s*\%(Использовать\|Use\)\>.*$"
syntax match bslAnnotation "&\%(НаКлиенте\|НаСервере\|НаСервереБезКонтекста\)\>"
syntax match bslAnnotation "&\%(НаКлиентеНаСервереБезКонтекста\|НаКлиентеНаСервере\)\>"
syntax match bslAnnotation "&\%(AtClient\|AtServer\|AtServerNoContext\|AtClientAtServerNoContext\)\>"
syntax match bslAnnotation "&\%(Перед\|После\|Вместо\|Before\|After\|Around\)\>"

" Labels and procedure calls -------------------------------------------------
syntax match bslLabel "^\s*\~\k\+:"
syntax match bslFunction "\<\k\+\ze\s*("

" Highlight links ------------------------------------------------------------
highlight default link bslComment Comment
highlight default link bslTodo Todo
highlight default link bslString String
highlight default link bslStringContinue Special
highlight default link bslDate Constant
highlight default link bslNumber Number
highlight default link bslStructure Keyword
highlight default link bslStorage StorageClass
highlight default link bslConditional Conditional
highlight default link bslRepeat Repeat
highlight default link bslStatement Statement
highlight default link bslException Exception
highlight default link bslOperator Operator
highlight default link bslBoolean Boolean
highlight default link bslConstant Constant
highlight default link bslBuiltin Function
highlight default link bslFunction Function
highlight default link bslPreProc PreProc
highlight default link bslRegion PreProc
highlight default link bslAnnotation Macro
highlight default link bslLabel Label

let b:current_syntax = "bsl"
