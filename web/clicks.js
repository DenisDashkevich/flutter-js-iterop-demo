
// use custom event emitter instead of browsers native 
// EventTarget because dart monkey patches this class.
class EventEmitter {
    constructor() {
        this._storage = new Map();
    }

    addEventListener(type, handler) {
        if (this._storage.has(type)) {
            this._storage.get(type).push(handler);
        } else {
            this._storage.set(type, [handler]);
        }
    }

    removeEventListener(type, handler) {
        if (this._storage.has(type)) {
            this._storage.set(type, this._storage.get(type).filter((fn) => fn != handler));
            return true;
        }

        return false;
    }

    dispatchEvent(event) {
        if (this._storage.has(event.type)) {
            this._storage.get(event.type).forEach(handler => handler(event));
            return true;
        }

        return false;
    }
}

class DartClickManager extends EventEmitter {
    constructor() {
        super();

        window.addEventListener('click', (e) => {
            const coordinatesChangedEvent = new DartClickManagerCoordinatesChangedEvent(
                e.clientX,
                e.clientY);

            this.dispatchEvent(coordinatesChangedEvent);
        });

        window._clickManager = this;
    }
}

const DartClickManagerEventType = {
    CoordinatesChanged: 'CoordinatesChanged',
};

class DartClickManagerEvent {
    constructor(type) {
        this.type = type;
    }
}

class DartClickManagerCoordinatesChangedEvent extends DartClickManagerEvent {
    constructor(x, y) {
        super(DartClickManagerEventType.CoordinatesChanged);

        this.x = x;
        this.y = y;
    }
}

window.ClicksNamespace = {
    DartClickManager,
    DartClickManagerEventType,
    DartClickManagerEvent,
    DartClickManagerCoordinatesChangedEvent,
}