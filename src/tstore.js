import isEmpty from 'lodash/isEmpty'
import cloneDeep from 'lodash/cloneDeep'
import uniqBy from 'lodash/uniqBy'
import pushid from 'pushid'
import format from 'date-fns/format'

const DATE_FMT = 'YYYY-MM-DD HH:mm:ss'

function yearMonth(date) {
    return date.slice(0, 7)
}

function ymSplit(ym) {
    return [ym.slice(0, 4), ym.slice(5, 7)]
}

function scanYmState(state, result, mult) {
    for(let acc in state) {
        for(let cur in state[acc]) {
            result[acc] || (result[acc] = {})
            result[acc][cur] || (result[acc][cur] = 0)
            result[acc][cur] += state[acc][cur] * mult
        }
    }
    return result
}

function ttype(src, dest, amount) {
    let st = src[0] == ':'
    let dt = dest[0] == ':'

    if (st & dt) {
        return 'transfer'
    } else if (st) {
        if (amount > 0) {
            return 'expense'
        } else {
            return 'income'
        }
    } else if (dt) {
        if (amount > 0) {
            return 'income'
        } else {
            return 'expense'
        }
    }

    return 'unknown'
}

export function makeTransaction(src, dest, amount, currency, date=null, groups=null) {
    date = date || format(new Date(), DATE_FMT)
    return {id: pushid(), src, dest, amount: Math.round(amount), currency, date, groups}
}

export class AccountState {
    constructor(state) {
        this.state = state || {'0000-00': {}}
    }

    _addToYm(account, amount, ym, currency) {
        let ymState = this.state[ym]
        let accState = ymState[account] || (ymState[account] = {})
        accState[currency] || (accState[currency] = 0)
        accState[currency] += amount

        if (accState[currency] == 0) {
            delete accState[currency]
        }

        if (isEmpty(accState)) {
            delete ymState[account]
        }
    }

    _prevYm(ym) {
        let maxYm = null;
        for(let fym in this.state) {
            if (fym < ym && (!maxYm || fym > maxYm)) {
                maxYm = fym
            }
        }
        return maxYm
    }

    _fillYm(ym) {
        if (ym in this.state) {
            return
        }
        this.state[ym] = cloneDeep(this.state[this._prevYm(ym)])
    }

    _add(account, amount, ym, currency) {
        this._fillYm(ym)
        this._addToYm(account, amount, ym, currency)
        for(let fym in this.state) {
            if (fym > ym) {
                this._addToYm(account, amount, fym, currency)
            }
        }
    }

    add(transaction) {
        let ym = yearMonth(transaction.date)
        if (transaction.src[0] == ':') {
            this._add(transaction.src, -transaction.amount, ym, transaction.currency)
        }
        if (transaction.dest[0] == ':') {
            this._add(transaction.dest, transaction.amount, ym, transaction.currency)
        }
    }

    diff(ym) {
        let cur = this.state[ym] || {}
        let prev = this.state[this._prevYm(ym)]
        if (prev === undefined) {
            return cloneDeep(cur)
        }
        let result = scanYmState(cur, {}, 1)
        scanYmState(prev, result, -1)
        return result
    }
}
