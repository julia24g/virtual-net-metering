pragma solidity ^0.8.0;


/**
 * @title LinkedList
 * @dev Data structure
 * @author Julia Groza
 */

import "./House.sol";

contract LinkedList {

    event ObjectCreated(uint256 id, House house);
    event ObjectsLinked(uint256 prev, uint256 next);
    event ObjectRemoved(uint256 id);
    event NewHead(uint256 id);

    struct Object{
        uint256 id;
        uint256 next;
        House house;
    }

    uint256 public head;
    uint256 public idCounter;
    mapping (uint256 => Object) public objects;

    /**
     * @dev Creates an empty list.
     */
    constructor() public {
        head = 0;
        idCounter = 1;
    }

    /**
     * @dev Retrieves the Object denoted by `_id`.
     */
    function get(uint256 _id)
        public
        virtual
        view
        returns (uint256, uint256, House)
    {
        Object memory object = objects[_id];
        return (object.id, object.next, object.house);
    }

    /**
     * @dev Given an Object, denoted by `_id`, returns the id of the Object that points to it, or 0 if `_id` refers to the Head.
     */
    function findPrevId(uint256 _id)
        public
        virtual
        view
        returns (uint256)
    {
        if (_id == head) return 0;
        Object memory prevObject = objects[head];
        while (prevObject.next != _id) {
            prevObject = objects[prevObject.next];
        }
        return prevObject.id;
    }

    /**
     * @dev Returns the id for the Tail.
     */
    function findTailId()
        public
        virtual
        view
        returns (uint256)
    {
        Object memory oldTailObject = objects[head];
        while (oldTailObject.next != 0) {
            oldTailObject = objects[oldTailObject.next];
        }
        return oldTailObject.id;
    }

    /**
     * @dev Return the id of the first Object matching `_house` in the data field.
     */
    function findIdForHouse(House _house)
        public
        virtual
        view
        returns (uint256)
    {
        Object memory object = objects[head];
        while (object.house != _house) {
            object = objects[object.next];
        }
        return object.id;
    }

    /**
     * @dev Insert a new Object as the new Head with `_house` in the data field.
     */
    function addHead(House _house)
        public
        virtual
    {
        uint256 objectId = _createObject(_house);
        _link(objectId, head);
        _setHead(objectId);
    }

    /**
     * @dev Insert a new Object as the new Tail with `_house` in the data field.
     */
    function addTail(House _house)
        public
        virtual
    {
        if (head == 0) {
            addHead(_house);
        }
        else {
            uint256 oldTailId = findTailId();
            uint256 newTailId = _createObject(_house);
            _link(oldTailId, newTailId);
        }
    }

    /**
     * @dev Remove the Object denoted by `_id` from the List.
     */
    function remove(uint256 _id)
        public
        virtual
    {
        Object memory removeObject = objects[_id];
        if (head == _id) {
            _setHead(removeObject.next);
        }
        else {
            uint256 prevObjectId = findPrevId(_id);
            _link(prevObjectId, removeObject.next);
        }
        delete objects[removeObject.id];
        emit ObjectRemoved(_id);
    }

    /**
     * @dev Insert a new Object after the Object denoted by `_id` with `_house` in the data field.
     */
    function insertAfter(uint256 _prevId, House _house)
        public
        virtual
    {
        Object memory prevObject = objects[_prevId];
        uint256 newObjectId = _createObject(_house);
        _link(newObjectId, prevObject.next);
        _link(prevObject.id, newObjectId);
    }

    /**
     * @dev Insert a new Object before the Object denoted by `_id` with `_house` in the data field.
     */
    function insertBefore(uint256 _nextId, House _house)
        public
        virtual
    {
        if (_nextId == head) {
            addHead(_house);
        }
        else {
            uint256 prevId = findPrevId(_nextId);
            insertAfter(prevId, _house);
        }
    }

    /**
     * @dev Internal function to update the Head pointer.
     */
    function _setHead(uint256 _id)
        internal
    {
        head = _id;
        emit NewHead(_id);
    }

    /**
     * @dev Internal function to create an unlinked Object.
     */
    function _createObject(House _house)
        internal
        returns (uint256)
    {
        uint256 newId = idCounter;
        idCounter += 1;
        Object memory object = Object(newId, 0, _house);
        objects[object.id] = object;
        emit ObjectCreated(
            object.id,
            object.house
        );
        return object.id;
    }

    /**
     * @dev Internal function to link an Object to another.
     */
    function _link(uint256 _prevId, uint256 _nextId)
        internal
    {
        objects[_prevId].next = _nextId;
        emit ObjectsLinked(_prevId, _nextId);
    }
}