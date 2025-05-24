--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]

local ____modules = {}
local ____moduleCache = {}
local ____originalRequire = require
local function require(file, ...)
    if ____moduleCache[file] then
        return ____moduleCache[file].value
    end
    if ____modules[file] then
        local module = ____modules[file]
        local value = nil
        if (select("#", ...) > 0) then value = module(...) else value = module(file) end
        ____moduleCache[file] = { value = value }
        return value
    else
        if ____originalRequire then
            return ____originalRequire(file)
        else
            error("module '" .. file .. "' not found")
        end
    end
end
____modules = {
["lualib_bundle"] = function(...) 
local function __TS__StringAccess(self, index)
    if index >= 0 and index < #self then
        return string.sub(self, index + 1, index + 1)
    end
end

local __TS__MathModf = math.modf

local __TS__NumberToString
do
    local radixChars = "0123456789abcdefghijklmnopqrstuvwxyz"
    function __TS__NumberToString(self, radix)
        if radix == nil or radix == 10 or self == math.huge or self == -math.huge or self ~= self then
            return tostring(self)
        end
        radix = math.floor(radix)
        if radix < 2 or radix > 36 then
            error("toString() radix argument must be between 2 and 36", 0)
        end
        local integer, fraction = __TS__MathModf(math.abs(self))
        local result = ""
        if radix == 8 then
            result = string.format("%o", integer)
        elseif radix == 16 then
            result = string.format("%x", integer)
        else
            repeat
                do
                    result = __TS__StringAccess(radixChars, integer % radix) .. result
                    integer = math.floor(integer / radix)
                end
            until not (integer ~= 0)
        end
        if fraction ~= 0 then
            result = result .. "."
            local delta = 1e-16
            repeat
                do
                    fraction = fraction * radix
                    delta = delta * radix
                    local digit = math.floor(fraction)
                    result = result .. __TS__StringAccess(radixChars, digit)
                    fraction = fraction - digit
                end
            until not (fraction >= delta)
        end
        if self < 0 then
            result = "-" .. result
        end
        return result
    end
end

local function __TS__Class(self)
    local c = {prototype = {}}
    c.prototype.__index = c.prototype
    c.prototype.constructor = c
    return c
end

local function __TS__ObjectEntries(obj)
    local result = {}
    local len = 0
    for key in pairs(obj) do
        len = len + 1
        result[len] = {key, obj[key]}
    end
    return result
end

local function __TS__New(target, ...)
    local instance = setmetatable({}, target.prototype)
    instance:____constructor(...)
    return instance
end

local __TS__Symbol, Symbol
do
    local symbolMetatable = {__tostring = function(self)
        return ("Symbol(" .. (self.description or "")) .. ")"
    end}
    function __TS__Symbol(description)
        return setmetatable({description = description}, symbolMetatable)
    end
    Symbol = {
        asyncDispose = __TS__Symbol("Symbol.asyncDispose"),
        dispose = __TS__Symbol("Symbol.dispose"),
        iterator = __TS__Symbol("Symbol.iterator"),
        hasInstance = __TS__Symbol("Symbol.hasInstance"),
        species = __TS__Symbol("Symbol.species"),
        toStringTag = __TS__Symbol("Symbol.toStringTag")
    }
end

local function __TS__InstanceOf(obj, classTbl)
    if type(classTbl) ~= "table" then
        error("Right-hand side of 'instanceof' is not an object", 0)
    end
    if classTbl[Symbol.hasInstance] ~= nil then
        return not not classTbl[Symbol.hasInstance](classTbl, obj)
    end
    if type(obj) == "table" then
        local luaClass = obj.constructor
        while luaClass ~= nil do
            if luaClass == classTbl then
                return true
            end
            luaClass = luaClass.____super
        end
    end
    return false
end

local __TS__Promise
do
    local function makeDeferredPromiseFactory()
        local resolve
        local reject
        local function executor(____, res, rej)
            resolve = res
            reject = rej
        end
        return function()
            local promise = __TS__New(__TS__Promise, executor)
            return promise, resolve, reject
        end
    end
    local makeDeferredPromise = makeDeferredPromiseFactory()
    local function isPromiseLike(value)
        return __TS__InstanceOf(value, __TS__Promise)
    end
    local function doNothing(self)
    end
    local ____pcall = _G.pcall
    __TS__Promise = __TS__Class()
    __TS__Promise.name = "__TS__Promise"
    function __TS__Promise.prototype.____constructor(self, executor)
        self.state = 0
        self.fulfilledCallbacks = {}
        self.rejectedCallbacks = {}
        self.finallyCallbacks = {}
        local success, ____error = ____pcall(
            executor,
            nil,
            function(____, v) return self:resolve(v) end,
            function(____, err) return self:reject(err) end
        )
        if not success then
            self:reject(____error)
        end
    end
    function __TS__Promise.resolve(value)
        if __TS__InstanceOf(value, __TS__Promise) then
            return value
        end
        local promise = __TS__New(__TS__Promise, doNothing)
        promise.state = 1
        promise.value = value
        return promise
    end
    function __TS__Promise.reject(reason)
        local promise = __TS__New(__TS__Promise, doNothing)
        promise.state = 2
        promise.rejectionReason = reason
        return promise
    end
    __TS__Promise.prototype["then"] = function(self, onFulfilled, onRejected)
        local promise, resolve, reject = makeDeferredPromise()
        self:addCallbacks(
            onFulfilled and self:createPromiseResolvingCallback(onFulfilled, resolve, reject) or resolve,
            onRejected and self:createPromiseResolvingCallback(onRejected, resolve, reject) or reject
        )
        return promise
    end
    function __TS__Promise.prototype.addCallbacks(self, fulfilledCallback, rejectedCallback)
        if self.state == 1 then
            return fulfilledCallback(nil, self.value)
        end
        if self.state == 2 then
            return rejectedCallback(nil, self.rejectionReason)
        end
        local ____self_fulfilledCallbacks_0 = self.fulfilledCallbacks
        ____self_fulfilledCallbacks_0[#____self_fulfilledCallbacks_0 + 1] = fulfilledCallback
        local ____self_rejectedCallbacks_1 = self.rejectedCallbacks
        ____self_rejectedCallbacks_1[#____self_rejectedCallbacks_1 + 1] = rejectedCallback
    end
    function __TS__Promise.prototype.catch(self, onRejected)
        return self["then"](self, nil, onRejected)
    end
    function __TS__Promise.prototype.finally(self, onFinally)
        if onFinally then
            local ____self_finallyCallbacks_2 = self.finallyCallbacks
            ____self_finallyCallbacks_2[#____self_finallyCallbacks_2 + 1] = onFinally
            if self.state ~= 0 then
                onFinally(nil)
            end
        end
        return self
    end
    function __TS__Promise.prototype.resolve(self, value)
        if isPromiseLike(value) then
            return value:addCallbacks(
                function(____, v) return self:resolve(v) end,
                function(____, err) return self:reject(err) end
            )
        end
        if self.state == 0 then
            self.state = 1
            self.value = value
            return self:invokeCallbacks(self.fulfilledCallbacks, value)
        end
    end
    function __TS__Promise.prototype.reject(self, reason)
        if self.state == 0 then
            self.state = 2
            self.rejectionReason = reason
            return self:invokeCallbacks(self.rejectedCallbacks, reason)
        end
    end
    function __TS__Promise.prototype.invokeCallbacks(self, callbacks, value)
        local callbacksLength = #callbacks
        local finallyCallbacks = self.finallyCallbacks
        local finallyCallbacksLength = #finallyCallbacks
        if callbacksLength ~= 0 then
            for i = 1, callbacksLength - 1 do
                callbacks[i](callbacks, value)
            end
            if finallyCallbacksLength == 0 then
                return callbacks[callbacksLength](callbacks, value)
            end
            callbacks[callbacksLength](callbacks, value)
        end
        if finallyCallbacksLength ~= 0 then
            for i = 1, finallyCallbacksLength - 1 do
                finallyCallbacks[i](finallyCallbacks)
            end
            return finallyCallbacks[finallyCallbacksLength](finallyCallbacks)
        end
    end
    function __TS__Promise.prototype.createPromiseResolvingCallback(self, f, resolve, reject)
        return function(____, value)
            local success, resultOrError = ____pcall(f, nil, value)
            if not success then
                return reject(nil, resultOrError)
            end
            return self:handleCallbackValue(resultOrError, resolve, reject)
        end
    end
    function __TS__Promise.prototype.handleCallbackValue(self, value, resolve, reject)
        if isPromiseLike(value) then
            local nextpromise = value
            if nextpromise.state == 1 then
                return resolve(nil, nextpromise.value)
            elseif nextpromise.state == 2 then
                return reject(nil, nextpromise.rejectionReason)
            else
                return nextpromise:addCallbacks(resolve, reject)
            end
        else
            return resolve(nil, value)
        end
    end
end

local __TS__AsyncAwaiter, __TS__Await
do
    local ____coroutine = _G.coroutine or ({})
    local cocreate = ____coroutine.create
    local coresume = ____coroutine.resume
    local costatus = ____coroutine.status
    local coyield = ____coroutine.yield
    function __TS__AsyncAwaiter(generator)
        return __TS__New(
            __TS__Promise,
            function(____, resolve, reject)
                local fulfilled, step, resolved, asyncCoroutine
                function fulfilled(self, value)
                    local success, resultOrError = coresume(asyncCoroutine, value)
                    if success then
                        return step(resultOrError)
                    end
                    return reject(nil, resultOrError)
                end
                function step(result)
                    if resolved then
                        return
                    end
                    if costatus(asyncCoroutine) == "dead" then
                        return resolve(nil, result)
                    end
                    return __TS__Promise.resolve(result):addCallbacks(fulfilled, reject)
                end
                resolved = false
                asyncCoroutine = cocreate(generator)
                local success, resultOrError = coresume(
                    asyncCoroutine,
                    function(____, v)
                        resolved = true
                        return __TS__Promise.resolve(v):addCallbacks(resolve, reject)
                    end
                )
                if success then
                    return step(resultOrError)
                else
                    return reject(nil, resultOrError)
                end
            end
        )
    end
    function __TS__Await(thing)
        return coyield(thing)
    end
end

local function __TS__StringIncludes(self, searchString, position)
    if not position then
        position = 1
    else
        position = position + 1
    end
    local index = string.find(self, searchString, position, true)
    return index ~= nil
end

local function __TS__ClassExtends(target, base)
    target.____super = base
    local staticMetatable = setmetatable({__index = base}, base)
    setmetatable(target, staticMetatable)
    local baseMetatable = getmetatable(base)
    if baseMetatable then
        if type(baseMetatable.__index) == "function" then
            staticMetatable.__index = baseMetatable.__index
        end
        if type(baseMetatable.__newindex) == "function" then
            staticMetatable.__newindex = baseMetatable.__newindex
        end
    end
    setmetatable(target.prototype, base.prototype)
    if type(base.prototype.__index) == "function" then
        target.prototype.__index = base.prototype.__index
    end
    if type(base.prototype.__newindex) == "function" then
        target.prototype.__newindex = base.prototype.__newindex
    end
    if type(base.prototype.__tostring) == "function" then
        target.prototype.__tostring = base.prototype.__tostring
    end
end

local Error, RangeError, ReferenceError, SyntaxError, TypeError, URIError
do
    local function getErrorStack(self, constructor)
        if debug == nil then
            return nil
        end
        local level = 1
        while true do
            local info = debug.getinfo(level, "f")
            level = level + 1
            if not info then
                level = 1
                break
            elseif info.func == constructor then
                break
            end
        end
        if __TS__StringIncludes(_VERSION, "Lua 5.0") then
            return debug.traceback(("[Level " .. tostring(level)) .. "]")
        elseif _VERSION == "Lua 5.1" then
            return string.sub(
                debug.traceback("", level),
                2
            )
        else
            return debug.traceback(nil, level)
        end
    end
    local function wrapErrorToString(self, getDescription)
        return function(self)
            local description = getDescription(self)
            local caller = debug.getinfo(3, "f")
            local isClassicLua = __TS__StringIncludes(_VERSION, "Lua 5.0")
            if isClassicLua or caller and caller.func ~= error then
                return description
            else
                return (description .. "\n") .. tostring(self.stack)
            end
        end
    end
    local function initErrorClass(self, Type, name)
        Type.name = name
        return setmetatable(
            Type,
            {__call = function(____, _self, message) return __TS__New(Type, message) end}
        )
    end
    local ____initErrorClass_1 = initErrorClass
    local ____class_0 = __TS__Class()
    ____class_0.name = ""
    function ____class_0.prototype.____constructor(self, message)
        if message == nil then
            message = ""
        end
        self.message = message
        self.name = "Error"
        self.stack = getErrorStack(nil, __TS__New)
        local metatable = getmetatable(self)
        if metatable and not metatable.__errorToStringPatched then
            metatable.__errorToStringPatched = true
            metatable.__tostring = wrapErrorToString(nil, metatable.__tostring)
        end
    end
    function ____class_0.prototype.__tostring(self)
        return self.message ~= "" and (self.name .. ": ") .. self.message or self.name
    end
    Error = ____initErrorClass_1(nil, ____class_0, "Error")
    local function createErrorClass(self, name)
        local ____initErrorClass_3 = initErrorClass
        local ____class_2 = __TS__Class()
        ____class_2.name = ____class_2.name
        __TS__ClassExtends(____class_2, Error)
        function ____class_2.prototype.____constructor(self, ...)
            ____class_2.____super.prototype.____constructor(self, ...)
            self.name = name
        end
        return ____initErrorClass_3(nil, ____class_2, name)
    end
    RangeError = createErrorClass(nil, "RangeError")
    ReferenceError = createErrorClass(nil, "ReferenceError")
    SyntaxError = createErrorClass(nil, "SyntaxError")
    TypeError = createErrorClass(nil, "TypeError")
    URIError = createErrorClass(nil, "URIError")
end

local __TS__Iterator
do
    local function iteratorGeneratorStep(self)
        local co = self.____coroutine
        local status, value = coroutine.resume(co)
        if not status then
            error(value, 0)
        end
        if coroutine.status(co) == "dead" then
            return
        end
        return true, value
    end
    local function iteratorIteratorStep(self)
        local result = self:next()
        if result.done then
            return
        end
        return true, result.value
    end
    local function iteratorStringStep(self, index)
        index = index + 1
        if index > #self then
            return
        end
        return index, string.sub(self, index, index)
    end
    function __TS__Iterator(iterable)
        if type(iterable) == "string" then
            return iteratorStringStep, iterable, 0
        elseif iterable.____coroutine ~= nil then
            return iteratorGeneratorStep, iterable
        elseif iterable[Symbol.iterator] then
            local iterator = iterable[Symbol.iterator](iterable)
            return iteratorIteratorStep, iterator
        else
            return ipairs(iterable)
        end
    end
end

local Set
do
    Set = __TS__Class()
    Set.name = "Set"
    function Set.prototype.____constructor(self, values)
        self[Symbol.toStringTag] = "Set"
        self.size = 0
        self.nextKey = {}
        self.previousKey = {}
        if values == nil then
            return
        end
        local iterable = values
        if iterable[Symbol.iterator] then
            local iterator = iterable[Symbol.iterator](iterable)
            while true do
                local result = iterator:next()
                if result.done then
                    break
                end
                self:add(result.value)
            end
        else
            local array = values
            for ____, value in ipairs(array) do
                self:add(value)
            end
        end
    end
    function Set.prototype.add(self, value)
        local isNewValue = not self:has(value)
        if isNewValue then
            self.size = self.size + 1
        end
        if self.firstKey == nil then
            self.firstKey = value
            self.lastKey = value
        elseif isNewValue then
            self.nextKey[self.lastKey] = value
            self.previousKey[value] = self.lastKey
            self.lastKey = value
        end
        return self
    end
    function Set.prototype.clear(self)
        self.nextKey = {}
        self.previousKey = {}
        self.firstKey = nil
        self.lastKey = nil
        self.size = 0
    end
    function Set.prototype.delete(self, value)
        local contains = self:has(value)
        if contains then
            self.size = self.size - 1
            local next = self.nextKey[value]
            local previous = self.previousKey[value]
            if next ~= nil and previous ~= nil then
                self.nextKey[previous] = next
                self.previousKey[next] = previous
            elseif next ~= nil then
                self.firstKey = next
                self.previousKey[next] = nil
            elseif previous ~= nil then
                self.lastKey = previous
                self.nextKey[previous] = nil
            else
                self.firstKey = nil
                self.lastKey = nil
            end
            self.nextKey[value] = nil
            self.previousKey[value] = nil
        end
        return contains
    end
    function Set.prototype.forEach(self, callback)
        for ____, key in __TS__Iterator(self:keys()) do
            callback(nil, key, key, self)
        end
    end
    function Set.prototype.has(self, value)
        return self.nextKey[value] ~= nil or self.lastKey == value
    end
    Set.prototype[Symbol.iterator] = function(self)
        return self:values()
    end
    function Set.prototype.entries(self)
        local nextKey = self.nextKey
        local key = self.firstKey
        return {
            [Symbol.iterator] = function(self)
                return self
            end,
            next = function(self)
                local result = {done = not key, value = {key, key}}
                key = nextKey[key]
                return result
            end
        }
    end
    function Set.prototype.keys(self)
        local nextKey = self.nextKey
        local key = self.firstKey
        return {
            [Symbol.iterator] = function(self)
                return self
            end,
            next = function(self)
                local result = {done = not key, value = key}
                key = nextKey[key]
                return result
            end
        }
    end
    function Set.prototype.values(self)
        local nextKey = self.nextKey
        local key = self.firstKey
        return {
            [Symbol.iterator] = function(self)
                return self
            end,
            next = function(self)
                local result = {done = not key, value = key}
                key = nextKey[key]
                return result
            end
        }
    end
    function Set.prototype.union(self, other)
        local result = __TS__New(Set, self)
        for ____, item in __TS__Iterator(other) do
            result:add(item)
        end
        return result
    end
    function Set.prototype.intersection(self, other)
        local result = __TS__New(Set)
        for ____, item in __TS__Iterator(self) do
            if other:has(item) then
                result:add(item)
            end
        end
        return result
    end
    function Set.prototype.difference(self, other)
        local result = __TS__New(Set, self)
        for ____, item in __TS__Iterator(other) do
            result:delete(item)
        end
        return result
    end
    function Set.prototype.symmetricDifference(self, other)
        local result = __TS__New(Set, self)
        for ____, item in __TS__Iterator(other) do
            if self:has(item) then
                result:delete(item)
            else
                result:add(item)
            end
        end
        return result
    end
    function Set.prototype.isSubsetOf(self, other)
        for ____, item in __TS__Iterator(self) do
            if not other:has(item) then
                return false
            end
        end
        return true
    end
    function Set.prototype.isSupersetOf(self, other)
        for ____, item in __TS__Iterator(other) do
            if not self:has(item) then
                return false
            end
        end
        return true
    end
    function Set.prototype.isDisjointFrom(self, other)
        for ____, item in __TS__Iterator(self) do
            if other:has(item) then
                return false
            end
        end
        return true
    end
    Set[Symbol.species] = Set
end

local function __TS__ArrayMap(self, callbackfn, thisArg)
    local result = {}
    for i = 1, #self do
        result[i] = callbackfn(thisArg, self[i], i - 1, self)
    end
    return result
end

local function __TS__StringTrim(self)
    local result = string.gsub(self, "^[%s ﻿]*(.-)[%s ﻿]*$", "%1")
    return result
end

local __TS__StringSplit
do
    local sub = string.sub
    local find = string.find
    function __TS__StringSplit(source, separator, limit)
        if limit == nil then
            limit = 4294967295
        end
        if limit == 0 then
            return {}
        end
        local result = {}
        local resultIndex = 1
        if separator == nil or separator == "" then
            for i = 1, #source do
                result[resultIndex] = sub(source, i, i)
                resultIndex = resultIndex + 1
            end
        else
            local currentPos = 1
            while resultIndex <= limit do
                local startPos, endPos = find(source, separator, currentPos, true)
                if not startPos then
                    break
                end
                result[resultIndex] = sub(source, currentPos, startPos - 1)
                resultIndex = resultIndex + 1
                currentPos = endPos + 1
            end
            if resultIndex <= limit then
                result[resultIndex] = sub(source, currentPos)
            end
        end
        return result
    end
end

local function __TS__ArrayFilter(self, callbackfn, thisArg)
    local result = {}
    local len = 0
    for i = 1, #self do
        if callbackfn(thisArg, self[i], i - 1, self) then
            len = len + 1
            result[len] = self[i]
        end
    end
    return result
end

local function __TS__ArrayForEach(self, callbackFn, thisArg)
    for i = 1, #self do
        callbackFn(thisArg, self[i], i - 1, self)
    end
end

local __TS__ArrayFrom
do
    local function arrayLikeStep(self, index)
        index = index + 1
        if index > self.length then
            return
        end
        return index, self[index]
    end
    local function arrayLikeIterator(arr)
        if type(arr.length) == "number" then
            return arrayLikeStep, arr, 0
        end
        return __TS__Iterator(arr)
    end
    function __TS__ArrayFrom(arrayLike, mapFn, thisArg)
        local result = {}
        if mapFn == nil then
            for ____, v in arrayLikeIterator(arrayLike) do
                result[#result + 1] = v
            end
        else
            local i = 0
            for ____, v in arrayLikeIterator(arrayLike) do
                local ____mapFn_3 = mapFn
                local ____thisArg_1 = thisArg
                local ____v_2 = v
                local ____i_0 = i
                i = ____i_0 + 1
                result[#result + 1] = ____mapFn_3(____thisArg_1, ____v_2, ____i_0)
            end
        end
        return result
    end
end

local function __TS__ArrayFind(self, predicate, thisArg)
    for i = 1, #self do
        local elem = self[i]
        if predicate(thisArg, elem, i - 1, self) then
            return elem
        end
    end
    return nil
end

local function __TS__CountVarargs(...)
    return select("#", ...)
end

local function __TS__SparseArrayNew(...)
    local sparseArray = {...}
    sparseArray.sparseLength = __TS__CountVarargs(...)
    return sparseArray
end

local function __TS__SparseArrayPush(sparseArray, ...)
    local args = {...}
    local argsLen = __TS__CountVarargs(...)
    local listLen = sparseArray.sparseLength
    for i = 1, argsLen do
        sparseArray[listLen + i] = args[i]
    end
    sparseArray.sparseLength = listLen + argsLen
end

local function __TS__SparseArraySpread(sparseArray)
    local _unpack = unpack or table.unpack
    return _unpack(sparseArray, 1, sparseArray.sparseLength)
end

local function __TS__ArrayReverse(self)
    local i = 1
    local j = #self
    while i < j do
        local temp = self[j]
        self[j] = self[i]
        self[i] = temp
        i = i + 1
        j = j - 1
    end
    return self
end

local function __TS__ObjectAssign(target, ...)
    local sources = {...}
    for i = 1, #sources do
        local source = sources[i]
        for key in pairs(source) do
            target[key] = source[key]
        end
    end
    return target
end

local function __TS__StringStartsWith(self, searchString, position)
    if position == nil or position < 0 then
        position = 0
    end
    return string.sub(self, position + 1, #searchString + position) == searchString
end

local function __TS__StringTrimEnd(self)
    local result = string.gsub(self, "[%s ﻿]*$", "")
    return result
end

local function __TS__ArraySlice(self, first, last)
    local len = #self
    first = first or 0
    if first < 0 then
        first = len + first
        if first < 0 then
            first = 0
        end
    else
        if first > len then
            first = len
        end
    end
    last = last or len
    if last < 0 then
        last = len + last
        if last < 0 then
            last = 0
        end
    else
        if last > len then
            last = len
        end
    end
    local out = {}
    first = first + 1
    last = last + 1
    local n = 1
    while first < last do
        out[n] = self[first]
        first = first + 1
        n = n + 1
    end
    return out
end

local function __TS__ArrayIncludes(self, searchElement, fromIndex)
    if fromIndex == nil then
        fromIndex = 0
    end
    local len = #self
    local k = fromIndex
    if fromIndex < 0 then
        k = len + fromIndex
    end
    if k < 0 then
        k = 0
    end
    for i = k + 1, len do
        if self[i] == searchElement then
            return true
        end
    end
    return false
end

return {
  __TS__NumberToString = __TS__NumberToString,
  __TS__Class = __TS__Class,
  __TS__ObjectEntries = __TS__ObjectEntries,
  __TS__Promise = __TS__Promise,
  __TS__New = __TS__New,
  __TS__AsyncAwaiter = __TS__AsyncAwaiter,
  __TS__Await = __TS__Await,
  Error = Error,
  RangeError = RangeError,
  ReferenceError = ReferenceError,
  SyntaxError = SyntaxError,
  TypeError = TypeError,
  URIError = URIError,
  __TS__InstanceOf = __TS__InstanceOf,
  Set = Set,
  __TS__ArrayMap = __TS__ArrayMap,
  __TS__StringTrim = __TS__StringTrim,
  __TS__StringSplit = __TS__StringSplit,
  __TS__ArrayFilter = __TS__ArrayFilter,
  __TS__ArrayForEach = __TS__ArrayForEach,
  __TS__Iterator = __TS__Iterator,
  __TS__ArrayFrom = __TS__ArrayFrom,
  __TS__ClassExtends = __TS__ClassExtends,
  __TS__ArrayFind = __TS__ArrayFind,
  __TS__SparseArrayNew = __TS__SparseArrayNew,
  __TS__SparseArrayPush = __TS__SparseArrayPush,
  __TS__SparseArraySpread = __TS__SparseArraySpread,
  __TS__ArrayReverse = __TS__ArrayReverse,
  __TS__ObjectAssign = __TS__ObjectAssign,
  __TS__StringStartsWith = __TS__StringStartsWith,
  __TS__StringTrimEnd = __TS__StringTrimEnd,
  __TS__ArraySlice = __TS__ArraySlice,
  __TS__ArrayIncludes = __TS__ArrayIncludes
}
 end,
["src.utils.index"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__NumberToString = ____lualib.__TS__NumberToString
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local __TS__Promise = ____lualib.__TS__Promise
local __TS__New = ____lualib.__TS__New
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local ____exports = {}
local ____fs = require("src.lua.fs.fs")
local read = ____fs.read
local write = ____fs.write
local ____json = require("src.lua.json.json")
local decode = ____json.decode
local encode = ____json.encode
function ____exports.randomId(self, length)
    local digits = {}
    do
        local i = 0
        while i < length do
            digits[#digits + 1] = __TS__NumberToString(
                math.floor(math.random() * 16),
                16
            )
            i = i + 1
        end
    end
    return table.concat(digits, "")
end
function ____exports.log(self, ...)
    c2.log(c2.LogLevel.Debug, ...)
end
function ____exports.message(self, msg)
    return "[AniList] " .. msg
end
____exports.JSON = {stringify = encode, parse = decode}
____exports.HTTPResponse = __TS__Class()
local HTTPResponse = ____exports.HTTPResponse
HTTPResponse.name = "HTTPResponse"
function HTTPResponse.prototype.____constructor(self, data, ____error, status)
    do
        do
            local ____data_0 = data
            self.data = ____data_0
            local ____error_1 = ____error
            self.error = ____error_1
        end
        local ____status_2 = status
        self.status = ____status_2
    end
end
function ____exports.fetch(self, url, options)
    if options == nil then
        options = {method = c2.HTTPMethod.Get}
    end
    return __TS__AsyncAwaiter(function(____awaiter_resolve)
        local req = c2.HTTPRequest.create(options.method, url)
        for ____, ____value in ipairs(__TS__ObjectEntries(options.headers or ({}))) do
            local k = ____value[1]
            local v = ____value[2]
            req:set_header(k, v)
        end
        if options.timeout then
            req:set_timeout(options.timeout)
        end
        if options.body then
            req:set_payload(options.body)
        end
        return ____awaiter_resolve(
            nil,
            __TS__New(
                __TS__Promise,
                function(____, res)
                    req:on_error(function(response) return res(
                        nil,
                        {
                            data = response:data(),
                            error = response:error(),
                            status = response:status()
                        }
                    ) end)
                    req:on_success(function(response) return res(
                        nil,
                        {
                            data = response:data(),
                            error = response:error(),
                            status = response:status()
                        }
                    ) end)
                    req:execute()
                end
            )
        )
    end)
end
____exports.fs = {read = read, write = write}
return ____exports
 end,
["src.lua.json.json"] = function(...) 
--
-- json.lua
--
-- Copyright (c) 2020 rxi
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of
-- this software and associated documentation files (the "Software"), to deal in
-- the Software without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do
-- so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--

local error = require("src.lua.error")
local json = { _version = "0.1.2" }

-------------------------------------------------------------------------------
-- Encode
-------------------------------------------------------------------------------

local encode

local escape_char_map = {
    ["\\"] = "\\",
    ["\""] = "\"",
    ["\b"] = "b",
    ["\f"] = "f",
    ["\n"] = "n",
    ["\r"] = "r",
    ["\t"] = "t",
}

local escape_char_map_inv = { ["/"] = "/" }
for k, v in pairs(escape_char_map) do
    escape_char_map_inv[v] = k
end


local function escape_char(c)
    return "\\" .. (escape_char_map[c] or string.format("u%04x", c:byte()))
end


local function encode_nil(val)
    return "null"
end


local function encode_table(val, stack)
    local res = {}
    stack = stack or {}

    -- Circular reference?
    if stack[val] then error("circular reference") end

    stack[val] = true

    if rawget(val, 1) ~= nil or next(val) == nil then
        -- Treat as array -- check keys are valid and it is not sparse
        local n = 0
        for k in pairs(val) do
            if type(k) ~= "number" then
                error("invalid table: mixed or invalid key types")
            end
            n = n + 1
        end
        if n ~= #val then
            error("invalid table: sparse array")
        end
        -- Encode
        for i, v in ipairs(val) do
            table.insert(res, encode(v, stack))
        end
        stack[val] = nil
        return "[" .. table.concat(res, ",") .. "]"
    else
        -- Treat as an object
        for k, v in pairs(val) do
            if type(k) ~= "string" then
                error("invalid table: mixed or invalid key types")
            end
            table.insert(res, encode(k, stack) .. ":" .. encode(v, stack))
        end
        stack[val] = nil
        return "{" .. table.concat(res, ",") .. "}"
    end
end


local function encode_string(val)
    return '"' .. val:gsub('[%z\1-\31\\"]', escape_char) .. '"'
end


local function encode_number(val)
    -- Check for NaN, -inf and inf
    if val ~= val or val <= -math.huge or val >= math.huge then
        error("unexpected number value '" .. tostring(val) .. "'")
    end
    return string.format("%.14g", val)
end


local type_func_map = {
    ["nil"] = encode_nil,
    ["table"] = encode_table,
    ["string"] = encode_string,
    ["number"] = encode_number,
    ["boolean"] = tostring,
}


encode = function(val, stack)
    local t = type(val)
    local f = type_func_map[t]
    if f then
        return f(val, stack)
    end
    error("unexpected type '" .. t .. "'")
end


function json:encode(val)
    return (encode(val))
end

-------------------------------------------------------------------------------
-- Decode
-------------------------------------------------------------------------------

local parse

local function create_set(...)
    local res = {}
    for i = 1, select("#", ...) do
        res[select(i, ...)] = true
    end
    return res
end

local space_chars  = create_set(" ", "\t", "\r", "\n")
local delim_chars  = create_set(" ", "\t", "\r", "\n", "]", "}", ",")
local escape_chars = create_set("\\", "/", '"', "b", "f", "n", "r", "t", "u")
local literals     = create_set("true", "false", "null")

local literal_map  = {
    ["true"] = true,
    ["false"] = false,
    ["null"] = nil,
}


local function next_char(str, idx, set, negate)
    for i = idx, #str do
        if set[str:sub(i, i)] ~= negate then
            return i
        end
    end
    return #str + 1
end


local function decode_error(str, idx, msg)
    local line_count = 1
    local col_count = 1
    for i = 1, idx - 1 do
        col_count = col_count + 1
        if str:sub(i, i) == "\n" then
            line_count = line_count + 1
            col_count = 1
        end
    end
    error(string.format("%s at line %d col %d", msg, line_count, col_count))
end


local function codepoint_to_utf8(n)
    -- http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=iws-appendixa
    local f = math.floor
    if n <= 0x7f then
        return string.char(n)
    elseif n <= 0x7ff then
        return string.char(f(n / 64) + 192, n % 64 + 128)
    elseif n <= 0xffff then
        return string.char(f(n / 4096) + 224, f(n % 4096 / 64) + 128, n % 64 + 128)
    elseif n <= 0x10ffff then
        return string.char(f(n / 262144) + 240, f(n % 262144 / 4096) + 128,
            f(n % 4096 / 64) + 128, n % 64 + 128)
    end
    error(string.format("invalid unicode codepoint '%x'", n))
end


local function parse_unicode_escape(s)
    local n1 = tonumber(s:sub(1, 4), 16)
    local n2 = tonumber(s:sub(7, 10), 16)
    -- Surrogate pair?
    if n2 then
        return codepoint_to_utf8((n1 - 0xd800) * 0x400 + (n2 - 0xdc00) + 0x10000)
    else
        return codepoint_to_utf8(n1)
    end
end


local function parse_string(str, i)
    local res = ""
    local j = i + 1
    local k = j

    while j <= #str do
        local x = str:byte(j)

        if x < 32 then
            decode_error(str, j, "control character in string")
        elseif x == 92 then -- `\`: Escape
            res = res .. str:sub(k, j - 1)
            j = j + 1
            local c = str:sub(j, j)
            if c == "u" then
                local hex = str:match("^[dD][89aAbB]%x%x\\u%x%x%x%x", j + 1)
                    or str:match("^%x%x%x%x", j + 1)
                    or decode_error(str, j - 1, "invalid unicode escape in string")
                res = res .. parse_unicode_escape(hex)
                j = j + #hex
            else
                if not escape_chars[c] then
                    decode_error(str, j - 1, "invalid escape char '" .. c .. "' in string")
                end
                res = res .. escape_char_map_inv[c]
            end
            k = j + 1
        elseif x == 34 then -- `"`: End of string
            res = res .. str:sub(k, j - 1)
            return res, j + 1
        end

        j = j + 1
    end

    decode_error(str, i, "expected closing quote for string")
end


local function parse_number(str, i)
    local x = next_char(str, i, delim_chars)
    local s = str:sub(i, x - 1)
    local n = tonumber(s)
    if not n then
        decode_error(str, i, "invalid number '" .. s .. "'")
    end
    return n, x
end


local function parse_literal(str, i)
    local x = next_char(str, i, delim_chars)
    local word = str:sub(i, x - 1)
    if not literals[word] then
        decode_error(str, i, "invalid literal '" .. word .. "'")
    end
    return literal_map[word], x
end


local function parse_array(str, i)
    local res = {}
    local n = 1
    i = i + 1
    while 1 do
        local x
        i = next_char(str, i, space_chars, true)
        -- Empty / end of array?
        if str:sub(i, i) == "]" then
            i = i + 1
            break
        end
        -- Read token
        x, i = parse(str, i)
        res[n] = x
        n = n + 1
        -- Next token
        i = next_char(str, i, space_chars, true)
        local chr = str:sub(i, i)
        i = i + 1
        if chr == "]" then break end
        if chr ~= "," then decode_error(str, i, "expected ']' or ','") end
    end
    return res, i
end


local function parse_object(str, i)
    local res = {}
    i = i + 1
    while 1 do
        local key, val
        i = next_char(str, i, space_chars, true)
        -- Empty / end of object?
        if str:sub(i, i) == "}" then
            i = i + 1
            break
        end
        -- Read key
        if str:sub(i, i) ~= '"' then
            decode_error(str, i, "expected string for key")
        end
        key, i = parse(str, i)
        -- Read ':' delimiter
        i = next_char(str, i, space_chars, true)
        if str:sub(i, i) ~= ":" then
            decode_error(str, i, "expected ':' after key")
        end
        i = next_char(str, i + 1, space_chars, true)
        -- Read value
        val, i = parse(str, i)
        -- Set
        res[key] = val
        -- Next token
        i = next_char(str, i, space_chars, true)
        local chr = str:sub(i, i)
        i = i + 1
        if chr == "}" then break end
        if chr ~= "," then decode_error(str, i, "expected '}' or ','") end
    end
    return res, i
end


local char_func_map = {
    ['"'] = parse_string,
    ["0"] = parse_number,
    ["1"] = parse_number,
    ["2"] = parse_number,
    ["3"] = parse_number,
    ["4"] = parse_number,
    ["5"] = parse_number,
    ["6"] = parse_number,
    ["7"] = parse_number,
    ["8"] = parse_number,
    ["9"] = parse_number,
    ["-"] = parse_number,
    ["t"] = parse_literal,
    ["f"] = parse_literal,
    ["n"] = parse_literal,
    ["["] = parse_array,
    ["{"] = parse_object,
}


parse = function(str, idx)
    local chr = str:sub(idx, idx)
    local f = char_func_map[chr]
    if f then
        return f(str, idx)
    end
    decode_error(str, idx, "unexpected character '" .. chr .. "'")
end


function json:decode(str)
    if type(str) ~= "string" then
        error("expected argument of type string, got " .. type(str))
    end
    local res, idx = parse(str, next_char(str, 1, space_chars, true))
    idx = next_char(str, idx, space_chars, true)
    if idx <= #str then
        decode_error(str, idx, "trailing garbage")
    end
    return res
end

return json
 end,
["src.lua.fs.fs"] = function(...) 
local _ = {}

local error = require("src.lua.error")
---@param filename string
---@return string | nil
function _:read(filename)
    local file = io.open(filename, "r+")
    if not file then
        error("no file")
    end

    local data = file:read("a")
    file:close();
    return data
end

---@param filename string
---@param data string
function _:write(filename, data)
    local file = io.open(filename, "w")
    if not file then
        error("cannot open file")
    end

    local wrote = file:write(data) ~= nil
    file:close()
    if not wrote then
        error("failed to write to file")
    end
end

return _
 end,
["src.utils.anilist"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local Error = ____lualib.Error
local RangeError = ____lualib.RangeError
local ReferenceError = ____lualib.ReferenceError
local SyntaxError = ____lualib.SyntaxError
local TypeError = ____lualib.TypeError
local URIError = ____lualib.URIError
local __TS__New = ____lualib.__TS__New
local __TS__InstanceOf = ____lualib.__TS__InstanceOf
local Set = ____lualib.Set
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local ____exports = {}
local _____2E = require("src.utils.index")
local fetch = _____2E.fetch
local fs = _____2E.fs
local JSON = _____2E.JSON
local log = _____2E.log
local GQL_QUERY = "\nquery {\n  Page(page: 1, perPage: 10) {\n    pageInfo {\n      currentPage\n    }\n    activities(\n      isFollowing: true\n      type: MEDIA_LIST\n      hasRepliesOrTypeText: false\n      sort: ID_DESC\n    ) {\n      ... on ListActivity {\n        id\n        type\n        status\n        progress\n        createdAt\n        user {\n          id\n          name\n        }\n        media {\n          id\n          title {\n            userPreferred\n          }\n        }\n      }\n    }\n  }\n}\n"
____exports.ActivityItem = {}
function ____exports.getActivities(self)
    return __TS__AsyncAwaiter(function(____awaiter_resolve)
        local token
        local ____try = __TS__AsyncAwaiter(function()
            token = fs:read("token")
        end)
        __TS__Await(____try.catch(
            ____try,
            function(____, err)
                error(
                    __TS__New(Error, "Plugin not authenticed with Anilist. Generate a token with /anilist token get & set your token with /anilist token set"),
                    0
                )
            end
        ))
        local ____try = __TS__AsyncAwaiter(function()
            local res = __TS__Await(fetch(
                nil,
                "https://graphql.anilist.co",
                {
                    method = c2.HTTPMethod.Post,
                    headers = {Authorization = "Bearer " .. token, ["Content-Type"] = "application/json", Accepts = "application/json"},
                    timeout = 5000,
                    body = JSON:stringify({query = GQL_QUERY})
                }
            ))
            if res.status ~= 200 then
                error(
                    __TS__New(
                        Error,
                        ("Unsuccessful response fron AniList API (" .. tostring(res.status)) .. ")"
                    ),
                    0
                )
            end
            local raw = JSON:parse(res.data)
            return ____awaiter_resolve(nil, raw.data.Page.activities)
        end)
        __TS__Await(____try.catch(
            ____try,
            function(____, err)
                log(nil, "fetch err")
                log(
                    nil,
                    JSON:stringify(err)
                )
                if __TS__InstanceOf(err, c2.HTTPResponse) then
                    log(nil, "inner")
                    log(
                        nil,
                        err:data()
                    )
                    log(
                        nil,
                        err:error()
                    )
                    log(
                        nil,
                        err:status()
                    )
                end
                error(err, 0)
            end
        ))
    end)
end
function ____exports.newAcitivies(self, old, curr)
    local out = {}
    local oldIds = __TS__New(
        Set,
        __TS__ArrayMap(
            old,
            function(____, a) return a.id end
        )
    )
    for ____, activity in ipairs(curr) do
        if oldIds:has(activity.id) then
            break
        end
        out[#out + 1] = activity
    end
    return out
end
return ____exports
 end,
["src.utils.broadcast"] = function(...) 
local ____lualib = require("lualib_bundle")
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArrayForEach = ____lualib.__TS__ArrayForEach
local __TS__Iterator = ____lualib.__TS__Iterator
local __TS__ArrayFrom = ____lualib.__TS__ArrayFrom
local ____exports = {}
local _____2E = require("src.utils.index")
local fs = _____2E.fs
local message = _____2E.message
____exports.broadcastChannels = __TS__New(Set)
local function getBroadcastChannels(self)
    local channels = __TS__New(Set)
    local raw = fs:read("channels")
    __TS__ArrayForEach(
        __TS__ArrayFilter(
            __TS__ArrayMap(
                __TS__StringSplit(raw, "\n"),
                function(____, c) return __TS__StringTrim(c) end
            ),
            function(____, c) return c ~= "" end
        ),
        function(____, c)
            local _channel = c2.Channel.by_name(c)
            if not _channel then
                return
            end
            channels:add(_channel)
        end
    )
    return channels
end
function ____exports.syncBroadcastChannels(self)
    local channels = __TS__New(Set)
    do
        pcall(function()
            channels = channels:union(getBroadcastChannels(nil))
        end)
    end
    ____exports.broadcastChannels:clear()
    for ____, channel in __TS__Iterator(channels) do
        ____exports.broadcastChannels:add(channel)
    end
end
local function flushBroadcastChannels(self)
    fs:write(
        "channels",
        table.concat(
            __TS__ArrayMap(
                __TS__ArrayFrom(____exports.broadcastChannels),
                function(____, c) return c:get_name() end
            ),
            "\n"
        )
    )
end
function ____exports.addBroadcastChannel(self, channelName)
    local channel = c2.Channel.by_name(channelName)
    if not channel then
        return false
    end
    ____exports.broadcastChannels:add(channel)
    do
        local function ____catch(err)
            ____exports.broadcastChannels:delete(channel)
            return true, false
        end
        local ____try, ____hasReturned, ____returnValue = pcall(function()
            flushBroadcastChannels(nil)
        end)
        if not ____try then
            ____hasReturned, ____returnValue = ____catch(____hasReturned)
        end
        if ____hasReturned then
            return ____returnValue
        end
    end
    return true
end
function ____exports.removeBroadcastChannel(self, channelName)
    local channel
    for ____, _channel in __TS__Iterator(____exports.broadcastChannels) do
        if _channel:get_name() == channelName then
            channel = _channel
        end
    end
    if not channel then
        return
    end
    ____exports.broadcastChannels:delete(channel)
    do
        local function ____catch(err)
            ____exports.broadcastChannels:add(channel)
        end
        local ____try, ____hasReturned = pcall(function()
            flushBroadcastChannels(nil)
        end)
        if not ____try then
            ____catch(____hasReturned)
        end
    end
end
function ____exports.broadcast(self, _message)
    for ____, channel in __TS__Iterator(____exports.broadcastChannels) do
        channel:add_system_message(message(nil, _message))
    end
end
return ____exports
 end,
["src.utils.command"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local Error = ____lualib.Error
local RangeError = ____lualib.RangeError
local ReferenceError = ____lualib.ReferenceError
local SyntaxError = ____lualib.SyntaxError
local TypeError = ____lualib.TypeError
local URIError = ____lualib.URIError
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__New = ____lualib.__TS__New
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local ____exports = {}
local _____2E = require("src.utils.index")
local JSON = _____2E.JSON
local log = _____2E.log
____exports.CommandError = __TS__Class()
local CommandError = ____exports.CommandError
CommandError.name = "CommandError"
__TS__ClassExtends(CommandError, Error)
function CommandError.prototype.____constructor(self, message)
    Error.prototype.____constructor(self, message)
end
____exports.Command = __TS__Class()
local Command = ____exports.Command
Command.name = "Command"
function Command.prototype.____constructor(self, params)
    self.params = params
end
function Command.prototype.run(self, ctx, args)
    return __TS__AsyncAwaiter(function(____awaiter_resolve)
        if self.params.subcommands ~= nil then
            if #args == 0 then
                error(
                    __TS__New(
                        ____exports.CommandError,
                        (self:usage() .. " <command> | Missing command. Available commands: ") .. table.concat(
                            self:availableCommands(),
                            ", "
                        )
                    ),
                    0
                )
            end
            local subcommand = __TS__ArrayFind(
                self.params:subcommands(self),
                function(____, c) return c.params.command == args[1] end
            )
            if not subcommand then
                error(
                    __TS__New(____exports.CommandError, "Unknown command: " .. args[1]),
                    0
                )
            end
            local _args = {table.unpack(args)}
            table.remove(_args, 1)
            __TS__Await(subcommand:run(ctx, _args))
        else
            local keys = self.params.args or ({})
            local vals = {table.unpack(args)}
            if #keys ~= #vals then
                log(nil, "args length mismatch")
                log(
                    nil,
                    JSON:stringify(self:getCommandChain())
                )
                error(
                    __TS__New(
                        ____exports.CommandError,
                        self:usage()
                    ),
                    0
                )
            end
            local _args = {}
            do
                local i = 0
                while i < #keys do
                    _args[keys[i + 1]] = vals[i + 1]
                    i = i + 1
                end
            end
            __TS__Await(self.params:action(ctx, _args))
        end
    end)
end
function Command.prototype.getCommandChain(self)
    if not self.params.parent then
        return {self.params.command}
    else
        local ____array_0 = __TS__SparseArrayNew(table.unpack(self.params.parent:getCommandChain()))
        __TS__SparseArrayPush(____array_0, self.params.command)
        return {__TS__SparseArraySpread(____array_0)}
    end
end
function Command.prototype.availableCommands(self)
    if self.params.subcommands ~= nil then
        return __TS__ArrayMap(
            self.params:subcommands(self),
            function(____, c) return c.params.command end
        )
    else
        error(
            __TS__New(Error, "Command has no subcommands"),
            0
        )
    end
end
function Command.prototype.usage(self)
    local usage = "/"
    local chain = self:getCommandChain()
    usage = usage .. table.concat(chain, " ")
    if self.params.args ~= nil and self.params.args then
        usage = usage .. " "
        usage = usage .. table.concat(
            __TS__ArrayMap(
                self.params.args,
                function(____, a) return ("<" .. a) .. ">" end
            ),
            " "
        )
    end
    return usage
end
return ____exports
 end,
["src.utils.interval"] = function(...) 
local ____lualib = require("lualib_bundle")
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local _____2E = require("src.utils.index")
local randomId = _____2E.randomId
local intervals = __TS__New(Set)
function ____exports.setInterval(self, fn, ms)
    local id
    while not id or intervals:has(id) do
        id = randomId(nil, 16)
    end
    intervals:add(id)
    local cb
    cb = function()
        if not intervals:has(id) then
            return
        end
        fn(nil)
        c2.later(
            function()
                cb(nil)
            end,
            ms
        )
    end
    c2.later(
        function()
            cb(nil)
        end,
        ms
    )
    return id
end
function ____exports.clearInterval(self, id)
    intervals:delete(id)
end
return ____exports
 end,
["src.index"] = function(...) 
local ____lualib = require("lualib_bundle")
local Set = ____lualib.Set
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local __TS__ArrayReverse = ____lualib.__TS__ArrayReverse
local __TS__New = ____lualib.__TS__New
local __TS__ArrayFrom = ____lualib.__TS__ArrayFrom
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__InstanceOf = ____lualib.__TS__InstanceOf
local __TS__StringStartsWith = ____lualib.__TS__StringStartsWith
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrimEnd = ____lualib.__TS__StringTrimEnd
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local Error = ____lualib.Error
local RangeError = ____lualib.RangeError
local ReferenceError = ____lualib.ReferenceError
local SyntaxError = ____lualib.SyntaxError
local TypeError = ____lualib.TypeError
local URIError = ____lualib.URIError
local ____exports = {}
local ____utils = require("src.utils.index")
local fs = ____utils.fs
local log = ____utils.log
local JSON = ____utils.JSON
local message = ____utils.message
local ____anilist = require("src.utils.anilist")
local getActivity = ____anilist.getActivities
local newAcitivity = ____anilist.newAcitivies
local ____broadcast = require("src.utils.broadcast")
local addBroadcastChannel = ____broadcast.addBroadcastChannel
local broadcast = ____broadcast.broadcast
local broadcastChannels = ____broadcast.broadcastChannels
local removeBroadcastChannel = ____broadcast.removeBroadcastChannel
local syncBroadcastChannels = ____broadcast.syncBroadcastChannels
local ____command = require("src.utils.command")
local Command = ____command.Command
local CommandError = ____command.CommandError
local ____interval = require("src.utils.interval")
local clearInterval = ____interval.clearInterval
local setInterval = ____interval.setInterval
local currentActivity
local interval
local starting = false
local function startup(self)
    return __TS__AsyncAwaiter(function(____awaiter_resolve)
        starting = true
        local ____try = __TS__AsyncAwaiter(function()
            log(nil, "Loading activities...")
            currentActivity = __TS__Await(getActivity(nil))
            log(nil, "Loaded activities")
            if interval then
                clearInterval(nil, interval)
            end
            interval = setInterval(
                nil,
                function()
                    return __TS__AsyncAwaiter(function(____awaiter_resolve)
                        local ____try = __TS__AsyncAwaiter(function()
                            local newAct = __TS__Await(getActivity(nil))
                            local updates = newAcitivity(nil, currentActivity, newAct)
                            currentActivity = newAct
                            __TS__ArrayReverse(updates)
                            for ____, activity in ipairs(updates) do
                                local msgParts = {}
                                msgParts[#msgParts + 1] = activity.user.name
                                msgParts[#msgParts + 1] = activity.status
                                if activity.status == "read chapter" or activity.status == "watched episode" then
                                    msgParts[#msgParts + 1] = activity.progress
                                    msgParts[#msgParts + 1] = "of"
                                end
                                msgParts[#msgParts + 1] = activity.media.title.userPreferred
                                local msg = table.concat(msgParts, " ")
                                broadcast(nil, msg)
                            end
                        end)
                        __TS__Await(____try.catch(
                            ____try,
                            function(____, err)
                                log(
                                    nil,
                                    JSON:stringify(err)
                                )
                                broadcast(nil, err.message)
                                if interval then
                                    clearInterval(nil, interval)
                                end
                            end
                        ))
                    end)
                end,
                30000
            )
            broadcast(nil, "Loaded")
        end)
        ____try.finally(
            ____try,
            function()
                starting = false
            end
        )
        __TS__Await(____try)
    end)
end
local function registerCommand(self)
    local command = __TS__New(
        Command,
        {
            command = "anilist",
            subcommands = function(____, parent) return {
                __TS__New(
                    Command,
                    {
                        command = "token",
                        parent = parent,
                        subcommands = function(____, parent) return {
                            __TS__New(
                                Command,
                                {
                                    parent = parent,
                                    command = "get",
                                    action = function(____, ctx)
                                        ctx:reply("Generate authentication token at: https://anilist.co/api/v2/oauth/authorize?client_id=26560&response_type=token")
                                    end
                                }
                            ),
                            __TS__New(
                                Command,
                                {
                                    parent = parent,
                                    command = "set",
                                    args = {"token"},
                                    action = function(____, ctx, ____bindingPattern0)
                                        local token
                                        token = ____bindingPattern0.token
                                        return __TS__AsyncAwaiter(function(____awaiter_resolve)
                                            fs:write("token", token)
                                            ctx:reply("Token set!")
                                            __TS__Await(startup(nil))
                                        end)
                                    end
                                }
                            )
                        } end
                    }
                ),
                __TS__New(
                    Command,
                    {
                        parent = parent,
                        command = "broadcast",
                        subcommands = function(____, parent) return {
                            __TS__New(
                                Command,
                                {
                                    parent = parent,
                                    command = "add",
                                    args = {"channel"},
                                    action = function(____, ctx, ____bindingPattern0)
                                        local channel
                                        channel = ____bindingPattern0.channel
                                        local added = addBroadcastChannel(nil, channel)
                                        if added then
                                            ctx:reply(("Added " .. channel) .. " to broadcast list")
                                        else
                                            ctx:reply("Unable to add channel. Make sure you have the channel opened in Chatterino")
                                        end
                                    end
                                }
                            ),
                            __TS__New(
                                Command,
                                {
                                    parent = parent,
                                    command = "remove",
                                    args = {"channel"},
                                    action = function(____, ctx, ____bindingPattern0)
                                        local channel
                                        channel = ____bindingPattern0.channel
                                        removeBroadcastChannel(nil, channel)
                                        ctx:reply(("Removed " .. channel) .. " from broadcast list")
                                    end
                                }
                            ),
                            __TS__New(
                                Command,
                                {
                                    parent = parent,
                                    command = "list",
                                    action = function(____, ctx)
                                        ctx:reply("Broadcast channels: " .. table.concat(
                                            __TS__ArrayMap(
                                                __TS__ArrayFrom(broadcastChannels),
                                                function(____, c) return c:get_name() end
                                            ),
                                            ", "
                                        ))
                                    end
                                }
                            )
                        } end
                    }
                ),
                __TS__New(
                    Command,
                    {
                        parent = parent,
                        command = "status",
                        action = function(____, ctx)
                            return __TS__AsyncAwaiter(function(____awaiter_resolve)
                                local ____try = __TS__AsyncAwaiter(function()
                                    __TS__Await(getActivity(nil))
                                    ctx:reply("Successfully fetched AniList activity!")
                                end)
                                __TS__Await(____try.catch(
                                    ____try,
                                    function(____, err)
                                        ctx:reply(err.message)
                                    end
                                ))
                            end)
                        end
                    }
                ),
                __TS__New(
                    Command,
                    {
                        parent = parent,
                        command = "commands",
                        action = function(____, ctx)
                            ctx:reply("Available commands: " .. table.concat(
                                parent:availableCommands(),
                                ", "
                            ))
                        end
                    }
                )
            } end
        }
    )
    c2.register_command(
        "/anilist",
        function(ctx)
            local function reply(self, _message)
                ctx.channel:add_system_message(message(nil, _message))
            end
            if starting then
                reply(nil, "Plugin starting up...")
                return
            end
            local args = ctx.words
            table.remove(args, 1)
            local _ctx = __TS__ObjectAssign({}, ctx, {reply = reply})
            command:run(_ctx, args):catch(function(____, err)
                log(
                    nil,
                    JSON:stringify(err)
                )
                if __TS__InstanceOf(err, CommandError) then
                    reply(nil, "Command error: " .. err.message)
                else
                    log(nil, "unexpected error:")
                    log(
                        nil,
                        JSON:stringify(err)
                    )
                    reply(nil, "Unexpected error: " .. err.message)
                end
            end)
        end
    )
    c2.register_callback(
        c2.EventType.CompletionRequested,
        function(event)
            if not command then
                log(nil, "no command")
                return {hide_others = false, values = {}}
            end
            if event.is_first_word and __TS__StringStartsWith("/" .. command.params.command, event.query) then
                return {values = {("/" .. command.params.command) .. " "}, hide_others = false}
            end
            if __TS__StringSplit(event.full_text_content, " ")[1] ~= "/" .. command.params.command then
                return {hide_others = false, values = {}}
            end
            local chain = __TS__ArraySlice(
                __TS__StringSplit(
                    string.sub(
                        __TS__StringTrimEnd(event.full_text_content),
                        2
                    ),
                    " "
                ),
                1,
                -1
            )
            local curr = command
            for ____, _command in ipairs(chain) do
                local availableCommands
                do
                    local function ____catch(err)
                        return true, {values = {}, hide_others = false}
                    end
                    local ____try, ____hasReturned, ____returnValue = pcall(function()
                        availableCommands = curr:availableCommands()
                    end)
                    if not ____try then
                        ____hasReturned, ____returnValue = ____catch(____hasReturned)
                    end
                    if ____hasReturned then
                        return ____returnValue
                    end
                end
                if __TS__ArrayIncludes(availableCommands, _command) then
                    if curr.params.subcommands ~= nil then
                        local c = __TS__ArrayFind(
                            curr.params:subcommands(curr),
                            function(____, c) return c.params.command == _command end
                        )
                        if not c then
                            error(
                                __TS__New(Error, "assert failed"),
                                0
                            )
                        end
                        curr = c
                    else
                        error(
                            __TS__New(Error, "assert failed"),
                            0
                        )
                    end
                else
                    return {values = {}, hide_others = false}
                end
            end
            do
                local function ____catch(err)
                    log(nil, "no more subcommands to complete")
                end
                local ____try, ____hasReturned, ____returnValue = pcall(function()
                    for ____, _command in ipairs(curr:availableCommands()) do
                        if __TS__StringStartsWith(_command, event.query) then
                            return true, {values = {_command .. " "}, hide_others = false}
                        end
                    end
                end)
                if not ____try then
                    ____hasReturned, ____returnValue = ____catch(____hasReturned)
                end
                if ____hasReturned then
                    return ____returnValue
                end
            end
            return {values = {}, hide_others = false}
        end
    )
end
syncBroadcastChannels(nil)
registerCommand(nil)
startup(nil):catch(function(____, err)
    log(
        nil,
        JSON:stringify(err)
    )
    broadcast(nil, "Error: " .. err.message)
end)
return ____exports
 end,
}
return require("src.index", ...)
