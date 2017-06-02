export function resolveStyles(selector, styles, cache) {
    let result = cache[selector];
    if (result !== undefined) {
        return result;
    }

    let [head, tail] = selector.split('[');
    tail = tail ? '[' + tail : '';
    let [tag, ...classes] = head.split('.');
    let resolved = classes.map((cls) => styles[cls] || cls).join('.');
    if (resolved) resolved = '.' + resolved;
    return tag + resolved + tail;
}

export function styled(m, styles) {
    var cache = {};
    return (selector, ...args) => {
        let resolvedSelector = resolveStyles(selector, styles, cache);
        return m(resolvedSelector, ...args);
    }
}
