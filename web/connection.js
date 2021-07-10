class DartConnectionManager {
    constructor(options) {
        navigator.connection.addEventListener('change', () => {
            options.connectionChangeHandler();
        });
    }

    get currentEffectiveType() {
        return window.navigator.connection.effectiveType || 'none';
    }

    get currentDownlink() {
        return window.navigator.connection.downlink || 0.0;
    }
}

window.ConnectionNamespace = {
    DartConnectionManager,
};