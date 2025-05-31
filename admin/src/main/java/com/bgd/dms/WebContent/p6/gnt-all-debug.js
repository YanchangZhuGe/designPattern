/*

Ext Gantt 2.1.0
Copyright(c) 2009-2012 Bryntum AB
http://bryntum.com/contact
http://bryntum.com/license

*/
/**
 * @class Sch.util.Patch
 * @static
 * Utility class for Ext JS patches
 */
Ext.define('Sch.util.Patch', {
    /**
     * @cfg {String} target The class name to override
     */
    target      : null,

    /**
     * @cfg {String} minVersion The minimum Ext JS version for which this override is applicable. E.g. "4.0.5"
     */
    minVersion  : null,
    
    /**
     * @cfg {String} maxVersion The minimum Ext JS version for which this override is applicable. E.g. "4.0.7"
     */
    maxVersion  : null,

    /**
     * @cfg {String} reportUrl A url to the forum post describing the bug/issue in greater detail
     */
    reportUrl   : null,
    
    /**
     * @cfg {String} description A brief description of why this override is required
     */
    description : null,
    
    /**
     * @cfg {Function} applyFn A function that will apply the patch(es) manually, instead of using 'overrides';
     */
    applyFn : null,

    /**
     * @cfg {Boolean} ieOnly true if patch is only applicable to IE
     */
    ieOnly : false,

    onClassExtended: function(cls, data) {
        
        if (Sch.disableOverrides) {
            return;
        }

        if (data.ieOnly && !Ext.isIE) {
            return;
        }

        if (data.applyFn) {
            data.applyFn();
        } else if ((!data.minVersion || Ext.versions.extjs.equals(data.minVersion) || Ext.versions.extjs.isGreaterThan(data.minVersion)) && 
                   (!data.maxVersion || Ext.versions.extjs.equals(data.maxVersion) || Ext.versions.extjs.isLessThan(data.maxVersion))) {
                
            data.requires[0].override(data.overrides);
        }
    }
});

Ext.define('Sch.patches.LoadMask', {
    extend      : "Sch.util.Patch",
    requires    : [ 'Ext.view.AbstractView' ],
    
    minVersion  : "4.1.0b3",
    
    reportURL   : 'http://www.sencha.com/forum/showthread.php?187700-4.1.0-B3-Ext.AbstractView-no-longer-binds-its-store-to-load-mask',
    description : 'In Ext4.1 loadmask no longer bind the store',

    overrides   : {
        // @NICK REVIEW, breaks on incremental node loading
//        bindStore : function (store, initial) {
//                
//            this.callParent(arguments);
//            
//            if (!this.loadMask || !this.loadMask.bindStore) {
//                return;
//            }
//            
//            if (store && Ext.Array.contains(store.alias, 'store.node')) {
//                store = this.ownerCt.store;
//            }
//            
//            this.loadMask.bindStore(store);
//        }
    }
});

// adds "providedStore" config option, which allows to have the same NodeStore both in the locked and normal parts of the grid
// code copied from 4.1.0 need to keep in sync
Ext.define('Sch.patches.TreeView', {
    extend      : "Sch.util.Patch",
    requires    : ['Ext.tree.View'],

    applyFn : function() { 
        Ext.tree.View.addMembers({
    
            providedStore       : null,

            initComponent: function() {
                var me = this,
                    treeStore = me.panel.getStore();

                if (me.initialConfig.animate === undefined) {
                    me.animate = Ext.enableFx;
                }

                // BEGIN OF MODIFICATIONS
                me.store = me.providedStore || new Ext.data.NodeStore({
                    treeStore: treeStore,
                    recursive: true,
                    rootVisible: me.rootVisible
                });
        
                me.store.on({
                    beforeexpand: me.onBeforeExpand,
                    expand: me.onExpand,
                    beforecollapse: me.onBeforeCollapse,
                    collapse: me.onCollapse,
                    write: me.onStoreWrite,
                    datachanged: me.onStoreDataChanged,
                    scope: me
                });

                if (me.node && !me.store.node) {
                    me.setRootNode(me.node);
                }
                // EOF MODIFICATIONS
        
                me.animQueue = {};
                me.animWraps = {};
                me.addEvents(
                    /**
                     * @event afteritemexpand
                     * Fires after an item has been visually expanded and is visible in the tree. 
                     * @param {Ext.data.NodeInterface} node         The node that was expanded
                     * @param {Number} index                        The index of the node
                     * @param {HTMLElement} item                    The HTML element for the node that was expanded
                     */
                    'afteritemexpand',
                    /**
                     * @event afteritemcollapse
                     * Fires after an item has been visually collapsed and is no longer visible in the tree. 
                     * @param {Ext.data.NodeInterface} node         The node that was collapsed
                     * @param {Number} index                        The index of the node
                     * @param {HTMLElement} item                    The HTML element for the node that was collapsed
                     */
                    'afteritemcollapse'
                );
                me.callParent(arguments);
                me.on({
                    element: 'el',
                    scope: me,
                    delegate: me.expanderSelector,
                    mouseover: me.onExpanderMouseOver,
                    mouseout: me.onExpanderMouseOut
                });
                me.on({
                    element: 'el',
                    scope: me,
                    delegate: me.checkboxSelector,
                    click: me.onCheckboxChange
                });
            }
        });
    }
});
Ext.define('Sch.patches.DataOperation', {
    extend: "Sch.util.Patch",
    requires: ['Ext.data.Operation'],

    reportURL: 'http://www.sencha.com/forum/showthread.php?198894-4.1-Ext.data.TreeStore-CRUD-regression.',
    description: 'In Ext 4.1.0 newly created records do not get the Id returned by server applied',

    overrides: {
        commitRecords: function (serverRecords) {
            var me = this,
            mc, index, clientRecords, serverRec, clientRec, i, len;

            if (!me.actionSkipSyncRe.test(me.action)) {
                clientRecords = me.records;

                if (clientRecords && clientRecords.length) {
                    if (clientRecords.length > 1) {
                        // If this operation has multiple records, client records need to be matched up with server records
                        // so that any data returned from the server can be updated in the client records. If we don't have
                        // a clientIdProperty specified on the model and we've done a create, just assume the data is returned in order.
                        // If it's an update, the records should already have an id which should match what the server returns.
                        if (me.action == 'update' || clientRecords[0].clientIdProperty) {
                            mc = new Ext.util.MixedCollection();
                            mc.addAll(serverRecords);

                            for (index = clientRecords.length; index--; ) {
                                clientRec = clientRecords[index];
                                serverRec = mc.findBy(me.matchClientRec, clientRec);

                                // Replace client record data with server record data
                                clientRec.copyFrom(serverRec);
                            }
                        } else {
                            for (i = 0, len = clientRecords.length; i < len; ++i) {
                                clientRec = clientRecords[i];
                                serverRec = serverRecords[i];
                                if (clientRec && serverRec) {
                                    me.updateRecord(clientRec, serverRec);
                                }
                            }
                        }
                    } else {
                        // operation only has one record, so just match the first client record up with the first server record
                        this.updateRecord(clientRecords[0], serverRecords[0]);
                    }

                    if (me.actionCommitRecordsRe.test(me.action)) {
                        for (index = clientRecords.length; index--; ) {
                            clientRecords[index].commit();
                        }
                    }
                }
            }
        },

        updateRecord: function (clientRec, serverRec) {
            // if the client record is not a phantom, make sure the ids match before replacing the client data with server data.
            if (serverRec && (clientRec.phantom || clientRec.getId() === serverRec.getId())) {
                clientRec.copyFrom(serverRec);
            }
        }
    }
});
Ext.define('Sch.patches.TreeStore', {
    extend  : "Sch.util.Patch",
    requires : ['Ext.data.TreeStore'],
    description : 'http://www.sencha.com/forum/showthread.php?208602-Model-s-Id-field-not-defined-after-sync-in-TreeStore-%28CRUD%29',

    overrides : {
        onCreateRecords: function(records) {
            this.callParent(arguments);
        
            var i = 0,
                len = records.length,
                tree = this.tree,
                node;

            for (; i < len; ++i) {
                node = records[i];
                tree.onNodeIdChanged(node, null, node.getId());
            }
        },

        setRootNode: function (root, /* private */preventLoad) {
            var me = this,
            model = me.model,
            idProperty = model.prototype.idProperty;
            
            root = root || {};
            if (!root.isModel) {
                // create a default rootNode and create internal data struct.
                Ext.applyIf(root, {
                    text: 'Root',
                    allowDrag: false
                });
                if (root[idProperty] === undefined) {
                    root[idProperty] = me.defaultRootId;
                }
                Ext.data.NodeInterface.decorate(model);
                root = Ext.ModelManager.create(root, model);
            } else if (root.isModel && !root.isNode) {
                Ext.data.NodeInterface.decorate(model);
            }


            // Because we have decorated the model with new fields,
            // we need to build new extactor functions on the reader.
            me.getProxy().getReader().buildExtractors(true);

            // When we add the root to the tree, it will automaticaly get the NodeInterface
            me.tree.setRootNode(root);

            // If the user has set expanded: true on the root, we want to call the expand function
            if (preventLoad !== true && !root.isLoaded() && (me.autoLoad === true || root.isExpanded())) {
                me.load({
                    node: root
                });
            }

            return root;
        }
    }
});

/**
 * @class Sch.util.Date
 * @static
 * Static utility class for Date manipulation
 */
Ext.define('Sch.util.Date', {
    requires: 'Ext.Date',
    singleton: true,

    constructor: function () {
        var ED = Ext.Date;
        var unitHash = {
            /**
            * Date interval constant
            * @static
            * @type String
            */
            MILLI: ED.MILLI,

            /**
            * Date interval constant
            * @static
            * @type String
            */
            SECOND: ED.SECOND,

            /**
            * Date interval constant
            * @static
            * @type String
            */
            MINUTE: ED.MINUTE,

            /** Date interval constant
            * @static
            * @type String
            */
            HOUR: ED.HOUR,

            /**
            * Date interval constant
            * @static
            * @type String
            */
            DAY: ED.DAY,

            /**
            * Date interval constant
            * @static
            * @type String
            */
            WEEK: "w",

            /**
            * Date interval constant
            * @static
            * @type String
            */
            MONTH: ED.MONTH,

            /**
            * Date interval constant
            * @static
            * @type String
            */
            QUARTER: "q",

            /**
            * Date interval constant
            * @static
            * @type String
            */
            YEAR: ED.YEAR
        };
        Ext.apply(this, unitHash);

        var me = this;
        this.units = [me.MILLI, me.SECOND, me.MINUTE, me.HOUR, me.DAY, me.WEEK, me.MONTH, me.QUARTER, me.YEAR];
        
        // Make it possible to lookup readable date names from both 'DAY' and 'd' etc.
        for (var o in unitHash) {
            if (unitHash.hasOwnProperty(o)) {
                me.unitNames[unitHash[o]] = me.unitNames[o];
            }
        }
    },

    /**
    * Checks if this date is >= start and < end.
    * @param {Date} date The source date
    * @param {Date} start Start date
    * @param {Date} end End date
    * @return {Boolean} true if this date falls on or between the given start and end dates.
    * @static
    */
    betweenLesser: function (date, start, end) {
        var t = date.getTime();
        return start.getTime() <= t && t < end.getTime();
    },

    /**
    * Constrains the date within a min and a max date
    * @param {Date} date The date to constrain
    * @param {Date} min Min date
    * @param {Date} max Max date
    * @return {Boolean} The constrained date
    * @static
    */
    constrain: function (date, min, max) {
        return this.min(this.max(date, min), max);
    },

    /**
    * Returns 1 if first param is a greater unit than second param, -1 if the opposite is true or 0 if they're equal
    * @static
    * 
    * @param {String} unit1 The 1st unit
    * @param {String} unit2 The 2nd unit
    */ 
    compareUnits: function (u1, u2) {
        var ind1 = Ext.Array.indexOf(this.units, u1),
            ind2 = Ext.Array.indexOf(this.units, u2);

        return ind1 > ind2 ? 1 : (ind1 < ind2 ? -1 : 0);
    },

    /**
    * Adds a date unit and interval 
    * @param {Date} date The source date 
    * @param {String} unit The date unit to add
    * @param {Int} value The number of units to add to the date
    * @return {Date} The new date
    * @static
    */
    add: function (date, unit, value) {
        var d = Ext.Date.clone(date);
        if (!unit || value === 0) return d;

        switch (unit.toLowerCase()) {
            case this.MILLI:
                d = new Date(date.getTime() + value);
                break;
            case this.SECOND:
                d = new Date(date.getTime() + (value * 1000));
                break;
            case this.MINUTE:
                d = new Date(date.getTime() + (value * 60000));
                break;
            case this.HOUR:
                d = new Date(date.getTime() + (value * 3600000));
                break;
            case this.DAY:
                d.setDate(date.getDate() + value);
                break;
            case this.WEEK:
                d.setDate(date.getDate() + value * 7);
                break;
            case this.MONTH:
                var day = date.getDate();
                if (day > 28) {
                    day = Math.min(day, Ext.Date.getLastDateOfMonth(this.add(Ext.Date.getFirstDateOfMonth(date), this.MONTH, value)).getDate());
                }
                d.setDate(day);
                d.setMonth(d.getMonth() + value);
                break;
            case this.QUARTER:
                d = this.add(date, this.MONTH, value * 3);
                break;
            case this.YEAR:
                d.setFullYear(date.getFullYear() + value);
                break;
        }
        return d;
    },

    
    getMeasuringUnit: function (unit) {
        if (unit === this.WEEK) {
            return this.DAY;
        }
        return unit;
    },

    
    /**
     * Returns a duration of the timeframe in the given units.   
     * @static
     * @param {Date} start The start date of the timeframe
     * @param {Date} end The end date of the timeframe
     * @param {String} unit Duration unit
     * @return {Number} The duration in the units 
     */
    getDurationInUnit: function (start, end, unit) {
        var units;

        switch (unit) {
            case this.QUARTER:
                units = Math.round(this.getDurationInMonths(start, end) / 3);
                break;

            case this.MONTH:
                units = Math.round(this.getDurationInMonths(start, end));
                break;

            case this.WEEK:
                units = Math.round(this.getDurationInDays(start, end)) / 7;
                break;

            case this.DAY:
                units = Math.round(this.getDurationInDays(start, end));
                break;

            case this.HOUR:
                units = Math.round(this.getDurationInHours(start, end));
                break;

            case this.MINUTE:
                units = Math.round(this.getDurationInMinutes(start, end));
                break;

            case this.SECOND:
                units = Math.round(this.getDurationInSeconds(start, end));
                break;

            case this.MILLI:
                units = Math.round(this.getDurationInMilliseconds(start, end));
                break;
        }

        return units;
    },

    
    getUnitToBaseUnitRatio: function (baseUnit, unit) {
        if (baseUnit === unit) {
            return 1;
        }

        switch (baseUnit) {
            case this.YEAR:
                switch (unit) {
                    case this.QUARTER:
                        return 1 / 4;

                    case this.MONTH:
                        return 1 / 12;
                }
                break;

            case this.QUARTER:
                switch (unit) {
                    case this.YEAR:
                        return 4;

                    case this.MONTH:
                        return 1 / 3;
                }
                break;

            case this.MONTH:
                switch (unit) {
                    case this.YEAR:
                        return 12;

                    case this.QUARTER:
                        return 3;
                }
                break;

            case this.WEEK:
                switch (unit) {
                    case this.DAY:
                        return 1 / 7;

                    case this.HOUR:
                        return 1 / 168;
                }
                break;

            case this.DAY:
                switch (unit) {
                    case this.WEEK:
                        return 7;

                    case this.HOUR:
                        return 1 / 24;

                    case this.MINUTE:
                        return 1 / 1440;
                }
                break;

            case this.HOUR:
                switch (unit) {
                    case this.DAY:
                        return 24;

                    case this.MINUTE:
                        return 1 / 60;
                }
                break;

            case this.MINUTE:
                switch (unit) {
                    case this.HOUR:
                        return 60;

                    case this.SECOND:
                        return 1 / 60;

                    case this.MILLI:
                        return 1 / 60000;
                }
                break;

            case this.SECOND:
                switch (unit) {
                    case this.MILLI:
                        return 1 / 1000;
                }
                break;
                
                
            case this.MILLI:
                switch (unit) {
                    case this.SECOND:
                        return 1000;
                }
                break;
                
        }

        return -1;
    },

    /**
    * Returns the number of Milliseconds between the two dates
    * @param {Date} start Start date
    * @param {Date} end End date
    * @return {Int} true number of minutes between the two dates
    * @static
    */
    getDurationInMilliseconds: function (start, end) {
        return (end - start);
    },

    /**
    * Returns the number of Seconds between the two dates
    * @param {Date} start Start date
    * @param {Date} end End date
    * @return {Int} true number of minutes between the two dates
    * @static
    */
    getDurationInSeconds: function (start, end) {
        return (end - start) / 1000;
    },

    /**
    * Returns the number of minutes between the two dates
    * @param {Date} start Start date
    * @param {Date} end End date
    * @return {Int} true number of minutes between the two dates
    * @static
    */
    getDurationInMinutes: function (start, end) {
        return (end - start) / 60000;
    },

    /**
    * Returns the number of hours between the two dates
    * @param {Date} start Start date
    * @param {Date} end End date
    * @return {Int} true number of hours between the two dates
    * @static
    */
    getDurationInHours: function (start, end) {
        return (end - start) / 3600000;
    },

    /**
    * Returns the number of whole days between the two dates
    * @param {Date} start Start date
    * @param {Date} end End date
    * @return {Int} true number of days between the two dates
    * @static
    */
    getDurationInDays: function (start, end) {
        return (end - start) / 86400000;
    },

    /**
    * Returns the number of business days between the two dates
    * @param {Date} start Start date
    * @param {Date} end End date
    * @return {Int} true number of business days between the two dates
    * @static
    */
    getDurationInBusinessDays: function (start, end) {
        var nbrDays = Math.round((end - start) / 86400000),
            nbrBusinessDays = 0,
            d;

        for (var i = 0; i < nbrDays; i++) {
            d = this.add(start, this.DAY, i).getDay();
            if (d !== 6 && d !== 0) {
                nbrBusinessDays++;
            }
        }
        return nbrBusinessDays;
    },

    /**
    * Returns the number of whole months between the two dates
    * @param {Date} start Start date
    * @param {Date} end End date
    * @return {Int} The number of whole months between the two dates
    * @static
    */
    getDurationInMonths: function (start, end) {
        return ((end.getFullYear() - start.getFullYear()) * 12) + (end.getMonth() - start.getMonth());
    },

    /**
    * Returns the number of years between the two dates
    * @param {Date} start Start date
    * @param {Date} end End date
    * @return {Int} The number of whole months between the two dates
    * @static
    */
    getDurationInYears: function (start, end) {
        return this.getDurationInMonths(start, end) / 12;
    },

    /**
    * Returns the lesser of the two dates
    * @param {Date} date 1
    * @param {Date} date 2
    * @return {Date} Returns the lesser of the two dates
    * @static
    */
    min: function (d1, d2) {
        return d1 < d2 ? d1 : d2;
    },

    /**
    * Returns the greater of the two dates
    * @param {Date} date 1
    * @param {Date} date 2
    * @return {Date} Returns the greater of the two dates
    * @static
    */
    max: function (d1, d2) {
        return d1 > d2 ? d1 : d2;
    },

    /**
    * Returns true if dates intersect
    * @param {Date} start 1
    * @param {Date} end 1
    * @param {Date} start 2
    * @param {Date} end 2
    * @return {Boolean} Returns true if dates intersect
    * @static
    */
    intersectSpans: function (date1Start, date1End, date2Start, date2End) {
        return this.betweenLesser(date1Start, date2Start, date2End) ||
               this.betweenLesser(date2Start, date1Start, date1End);
    },
    
    /**
     * Returns a name of the duration unit, matching its property on the Sch.util.Date class. 
     * So, for example:
     * 
     *      Sch.util.Date.getNameOfUnit(Sch.util.Date.DAY) == 'DAY' // true
     * 
     * @static
     * @param {String} unit Duration unit
     * @return {String} 
     */
    getNameOfUnit : function (unit) {
        
        switch (unit.toLowerCase()) {
            case this.YEAR      : return 'YEAR';
            case this.QUARTER   : return 'QUARTER';
            case this.MONTH     : return 'MONTH';
            case this.WEEK      : return 'WEEK';
            case this.DAY       : return 'DAY';
            case this.HOUR      : return 'HOUR';
            case this.MINUTE    : return 'MINUTE';
            case this.SECOND    : return 'SECOND';
            case this.MILLI     : return 'MILLI';
        }
        
        throw "Incorrect UnitName";
    },
    
    // Override this to localize the time unit names.
    unitNames : {
        YEAR        : { single : 'year',    plural : 'years',   abbrev : 'yr' },
        QUARTER     : { single : 'quarter', plural : 'quarters',abbrev : 'q' },
        MONTH       : { single : 'month',   plural : 'months',  abbrev : 'mon' },
        WEEK        : { single : 'week',    plural : 'weeks',   abbrev : 'w' },
        DAY         : { single : 'day',     plural : 'days',    abbrev : 'd' },
        HOUR        : { single : 'hour',    plural : 'hours',   abbrev : 'h' },
        MINUTE      : { single : 'minute',  plural : 'minutes', abbrev : 'min' },
        SECOND      : { single : 'second',  plural : 'seconds', abbrev : 's' },
        MILLI       : { single : 'ms',      plural : 'ms',      abbrev : 'ms' }
    },

    /**
     * Returns a human-readable name of the duration unit. For for example for `Sch.util.Date.DAY` it will return either
     * "day" or "days", depending from the `plural` argument
     * @static
     * @param {String} unit Duration unit
     * @param {Boolean} plural Whether to return a plural name or singular
     * @return {String} 
     */
    getReadableNameOfUnit : function (unit, plural) {
        return this.unitNames[unit][plural ? 'plural' : 'single'];
    },

    /**
     * Returns an abbreviated form of the name of the duration unit. 
     * @static
     * @param {String} unit Duration unit
     * @return {String} 
     */
    getShortNameOfUnit : function (unit) {
        return this.unitNames[unit.toUpperCase()].abbrev;
    },
    
    getUnitByName : function (name) {
        name    = name.toUpperCase();
        
        if (!this[ name ]) {
            Ext.Error.raise('Unknown unit name');
        }
        
        return this[ name ];
    },
    
    
    /**
     * Returns the beginning of the Nth next duration unit, after the provided `date`.
     * For example for the this call:
     *      Sch.util.Date.getNext(new Date('Jul 15, 2011'), Sch.util.Date.MONTH, 1)
     *      
     * will return the beginning of the August: Aug 1, 2011     
     *      
     * @static
     * @param {Date} date The date
     * @param {String} unit The duration unit
     * @param {Integer} increment How many duration units to skip
     * @param {Number} weekStartDay An index of 1st day in week. Only required when `unit` is `WEEK`. 0 for Sunday, 1 for Monday, 2 for Tuesday, and so on. 
     * @return {Date} The beginning of the next duration unit interval
     */
    getNext : function(date, unit, increment, weekStartDay) {
        var dt = Ext.Date.clone(date);
        
        increment = increment || 1;
        
        switch (unit) {
            case this.DAY: 
                Ext.Date.clearTime(dt);
                dt = this.add(dt, this.DAY, increment);
            break;

            case this.WEEK: 
                var day = dt.getDay();
                dt = this.add(dt, this.DAY, (7 * (increment - 1)) + (day < weekStartDay ? (weekStartDay - day) : (7 - day + weekStartDay)));
            break;

            case this.MONTH: 
                dt = this.add(dt, this.MONTH, increment);
                dt.setDate(1);
            break;

            case this.QUARTER:
                dt = this.add(dt, this.MONTH, ((increment - 1) * 3) + (3 - (dt.getMonth() % 3)));
            break;
            
            case this.YEAR:
                dt = new Date(dt.getFullYear() + increment, 0, 1);
            break;

            default:
                dt = this.add(date, unit, increment);
            break;
        }

        return dt;
    },

    getNumberOfMsFromTheStartOfDay : function (date) {
        return date - Ext.Date.clearTime(date, true) || 86400000;
    },
    
    getNumberOfMsTillTheEndOfDay : function (date) {
        return this.getStartOfNextDay(date, true) - date;
    },

    getStartOfNextDay : function (date, clone) {
        var nextDay     = this.add(Ext.Date.clearTime(date, clone), this.DAY, 1);
        
        // DST case
        if (nextDay.getDate() == date.getDate()) {
            var offsetNextDay   = this.add(Ext.Date.clearTime(date, clone), this.DAY, 2).getTimezoneOffset();
            var offsetDate      = date.getTimezoneOffset();
            
            nextDay             = this.add(nextDay, this.MINUTE, offsetDate - offsetNextDay);
        }
        
        return nextDay;
    },

    getEndOfPreviousDay : function (date) {
        var dateOnly    = Ext.Date.clearTime(date, true);
        
        // dates are different
        if (dateOnly - date) {
            return dateOnly;
        } else {
            return this.add(dateOnly, this.DAY, -1);
        }
    },

    /**
     * Returns true if the first time span completely 'covers' the second time span. E.g.
     * Sch.util.Date.timeSpanContains(new Date(2010, 1, 2), new Date(2010, 1, 5), new Date(2010, 1, 1), new Date(2010, 1, 3)) ==> true
     * Sch.util.Date.timeSpanContains(new Date(2010, 1, 2), new Date(2010, 1, 5), new Date(2010, 1, 1), new Date(2010, 1, 3)) ==> false
     * @static
     * @param {String} unit Duration unit
     * @return {String} 
     */
    timeSpanContains : function(spanStart, spanEnd, otherSpanStart, otherSpanEnd) {
        return (otherSpanStart - spanStart) >= 0 && (spanEnd - otherSpanEnd) >= 0;
    }
});

/*
 * @class Sch.util.DragTracker
 * @private
 * 
 * Simple drag tracker with an extra useful getRegion method
 */
Ext.define('Sch.util.DragTracker', {
    extend      : 'Ext.dd.DragTracker',
    
    /**
     * @cfg {Number} xStep
     * The number of horizontal pixels to snap to when dragging
     */
    xStep : 1,

    /**
     * @cfg {Number} yStep
     * The number of vertical pixels to snap to when dragging
     */
    yStep : 1,

    /**
     * Set the number of horizontal pixels to snap to when dragging
     * @param {Number} step
     */
    setXStep : function(step) {
        this.xStep = step;
    },

    /**
     * Set the number of vertical pixels to snap to when dragging
     * @param {Number} step
     */
    setYStep : function(step) {
        this.yStep = step;
    },

    getRegion : function() {
        var startXY   = this.startXY,
            currentXY = this.getXY(),
            minX      = Math.min(startXY[0], currentXY[0]),
            minY      = Math.min(startXY[1], currentXY[1]),
            width     = Math.abs(startXY[0] - currentXY[0]),
            height    = Math.abs(startXY[1] - currentXY[1]);
            
        return new Ext.util.Region(minY, minX + width, minY + height, minX);
    },

    onMouseDown: function(e, target){
        // If this is disabled, or the mousedown has been processed by an upstream DragTracker, return
        if (this.disabled ||e.dragTracked) {
            return;
        }

        var xy = e.getXY(),
            elX, elY,
            x = xy[0], 
            y = xy[1];
        // TODO handle if this.el is scrolled
        if (this.xStep > 1) {
            elX = this.el.getX();
            x -= elX;
            x = Math.round(x/this.xStep)*this.xStep;
            x += elX;
        }
        
        if (this.yStep > 1) {
            elY = this.el.getY();
            y -= elY;
            y = Math.round(y/this.yStep)*this.yStep;
            y += elY;
        }

        // This information should be available in mousedown listener and onBeforeStart implementations
        this.dragTarget = this.delegate ? target : this.handle.dom;
        this.startXY = this.lastXY = [x, y];
        this.startRegion = Ext.fly(this.dragTarget).getRegion();

        if (this.fireEvent('mousedown', this, e) === false ||
            this.fireEvent('beforedragstart', this, e) === false ||
            this.onBeforeStart(e) === false) {
            return;
        }

        // Track when the mouse is down so that mouseouts while the mouse is down are not processed.
        // The onMouseOut method will only ever be called after mouseup.
        this.mouseIsDown = true;

        // Flag for downstream DragTracker instances that the mouse is being tracked.
        e.dragTracked = true;

        if (this.preventDefault !== false) {
            e.preventDefault();
        }
        Ext.getDoc().on({
            scope: this,
            mouseup: this.onMouseUp,
            mousemove: this.onMouseMove,
            selectstart: this.stopSelect
        });
        if (this.autoStart) {
            this.timer =  Ext.defer(this.triggerStart, this.autoStart === true ? 1000 : this.autoStart, this, [e]);
        }
    },

    onMouseMove: function(e, target){
        
        if (this.active && Ext.isIE && !e.browserEvent.button) {
            e.preventDefault();
            this.onMouseUp(e);
            return;
        }

        e.preventDefault();
        var xy = e.getXY(),
            s = this.startXY;
        
        if (!this.active) {
            if (Math.max(Math.abs(s[0]-xy[0]), Math.abs(s[1]-xy[1])) > this.tolerance) {
                this.triggerStart(e);
            } else {
                return;
            }
        }

        var x = xy[0], 
            y = xy[1];
        
        // TODO handle if this.el is scrolled
        if (this.xStep > 1) {
            x -= this.startXY[0];
            x = Math.round(x/this.xStep)*this.xStep;
            x += this.startXY[0];
        }
        
        if (this.yStep > 1) {
            y -= this.startXY[1];
            y = Math.round(y/this.yStep)*this.yStep;
            y += this.startXY[1];
        }

        var snapping = this.xStep > 1 || this.yStep > 1;

        if (!snapping || x !== xy[0] || y !== xy[1]) {
            this.lastXY = [x,y];
        
            if (this.fireEvent('mousemove', this, e) === false) {
                this.onMouseUp(e);
            } else {
                this.onDrag(e);
                this.fireEvent('drag', this, e);
            }
        }
    }
});


/**
@class Sch.util.HeaderRenderers
@static
 
A utility class for providing helper methods used to render header cells. These helpers can be used to "emulate" fine grained views with higher resolution.

Normally, each unit in the time axis is represented with a separate column. This is a very flexible solution, as it allows you to customize the presentation
of each and every cell in the timeline. However, when the number of columns grows, the DOM footprint becomes larger and larger.
So in cases when the customization of an arbitrary cell is not required, you can use one of these lightweight renderers to only visualize the small time units in the header.

For example, see this screenshot: {@img scheduler/images/header-renderer2.png}

It might seem that it uses a single day resolution. However, it uses "weeks" for both bottom and middle rows and for bottom row it uses
the `dayLetter` header renderer (see the `weekAndDayLetter` view preset).

To use the helper, specify the it as the `renderer` property of the {@link Sch.preset.ViewPresetHeaderRow}, like this:

    headerConfig : {
         bottom         : {
            unit        : "WEEK",
            increment   : 1,
            renderer    : function() {
                return Sch.util.HeaderRenderers.dayLetter.apply(this, arguments);
            }
        },
        middle : {
            unit        : "WEEK",
            dateFormat  : 'D d M Y',
            align       : 'left'
        }
    }

Available helpers are:

- `quarterMinute` - outputs the quarter of the minute or hour: 00 / 15 / 30 / 45
- `dateNumber` - outputs the the number of day: {@img scheduler/images/dateNumber.png}
- `dayLetter` - outputs the single letter name for each day: {@img scheduler/images/header-renderer2.png}
- `dayStartEndHours` - outputs the start and end hours for each date {@img scheduler/images/header-renderer1.png}

There's also a special "meta" helper, which when being called, will return a usual helper, suitable for usage as `renderer`. Its called `dateCells` and accepths the following signature:

    dateCells : function(unit, increment, format) {}

So, for example a `dateNumber` helper can be received by using: `dateCells(Sch.util.Date.DAY, 1, 'd')`

*/ 
Ext.define("Sch.util.HeaderRenderers", {
    singleton : true,
    requires : [
        'Sch.util.Date',
        'Ext.XTemplate'
    ],
    constructor : function () {
        var dayTemplate = Ext.create("Ext.XTemplate", 
            '<table class="sch-nested-hdr-tbl ' + Ext.baseCSSPrefix + 'column-header-text' + '" cellpadding="0" cellspacing="0"><tr>' + 
                '<tpl for="."><td style="width:{[100/xcount]}%" class="{cls} sch-dayheadercell-{dayOfWeek}">{text}</td></tpl>' + 
            '</tr></table>'
        ).compile();
    
        var cellTemplate = Ext.create("Ext.XTemplate", 
            '<table class="sch-nested-hdr-tbl" cellpadding="0" cellspacing="0"><tr>' + 
                '<tpl for="."><td style="width:{[100/xcount]}%" class="{cls}">{text}</td></tpl>' + 
            '</tr></table>'
        ).compile();

        return {
            quarterMinute : function(start, end, cfg, i) {
                cfg.headerCls = 'sch-nested-hdr-pad';
                return '<table class="sch-nested-hdr-tbl" cellpadding="0" cellspacing="0"><tr><td>00</td><td>15</td><td>30</td><td>45</td></tr></table>';
            },

            dateCells : function(unit, increment, format) {
            
                return function(start, end, cfg) {
                    cfg.headerCls = 'sch-nested-hdr-nopad';
                
                    var vals = [],
                        dt = Ext.Date.clone(start);
                
                    while(dt < end) {
                        vals.push({
                            text : Ext.Date.format(dt, format)
                        });
                        dt = Sch.util.Date.add(dt, unit, increment);
                    }

                    vals[0].cls = 'sch-nested-hdr-cell-first';
                    vals[vals.length - 1].cls = 'sch-nested-hdr-cell-last';
                
                    return cellTemplate.apply(vals);
                };
            },

            dateNumber : function(start, end, cfg) {
                cfg.headerCls = 'sch-nested-hdr-nopad';
                var vals = [],
                    dt = Ext.Date.clone(start);
                
                while(dt < end) {
                    vals.push({
                        dayOfWeek : dt.getDay(),
                        text : dt.getDate()
                    });
                    dt = Sch.util.Date.add(dt, Sch.util.Date.DAY, 1);
                }
                
                return dayTemplate.apply(vals);
            },

            dayLetter : function(start, end, cfg) {
                cfg.headerCls = 'sch-nested-hdr-nopad';
                var vals = [],
                    dt = start;
                
                while(dt < end) {
                    vals.push({
                        dayOfWeek : dt.getDay(),
                        text : Ext.Date.dayNames[dt.getDay()].substr(0, 1)
                    });
                    dt = Sch.util.Date.add(dt, Sch.util.Date.DAY, 1);
                }
                vals[0].cls = 'sch-nested-hdr-cell-first';
                vals[vals.length - 1].cls = 'sch-nested-hdr-cell-last';
                
                return dayTemplate.apply(vals);
            },

            dayStartEndHours : function(start, end, cfg) {
                cfg.headerCls = 'sch-hdr-startend';
                return Ext.String.format('<span class="sch-hdr-start">{0}</span><span class="sch-hdr-end">{1}</span>', Ext.Date.format(start, 'G'), Ext.Date.format(end, 'G'));            
            }
        };
    }
});

/**

@class Sch.model.Customizable
@extends Ext.data.Model

This class represent a model with customizable field names. Customizable fields are defined in separate 
class config `customizableFields`. The format of definition is just the same as for usual fields:

    Ext.define('BaseModel', {
        extend      : 'Sch.model.Customizable',
        
        customizableFields  : [
            { name      : 'StartDate',  type    : 'date', dateFormat : 'c' },
            { name      : 'EndDate',    type    : 'date', dateFormat : 'c' }
        ],
        
        fields              : [
            'UsualField'
        ],
        
        getEndDate : function () {
            return "foo"
        }
    });

For each customizable field will be created getter and setter, using the camel-cased name of the field ("stable name"), 
prepended with "get/set" respectively. They will not overwrite any existing methods:

    var baseModel       = new BaseModel({
        StartDate   : new Date(2012, 1, 1),
        EndDate     : new Date(2012, 2, 3)
    });
    
    // using getter for "StartDate" field
    // returns date for "2012/02/01"
    var startDate   = baseModel.getStartDate();
    
    // using custom getter for "EndDate" field
    // returns "foo"
    var endDate     = baseModel.getEndDate();
    
You can change the name of the customizable fields in the subclasses of the model or completely re-define them. 
For that, add a special property to the class, name of this property should be formed as name of the field with lowercased first
letter, appended with "Field". The value of the property should contain the new name of the field.

    Ext.define('SubModel', {
        extend      : 'BaseModel',
        
        startDateField      : 'beginDate',
        endDateField        : 'finalizeDate',
        
        fields              : [
            { name      : 'beginDate',  type    : 'date', dateFormat : 'Y-m-d' },
        ]
    });
    
    var subModel       = new SubModel({
        beginDate       : new Date(2012, 1, 1),
        finalizeDate    : new Date(2012, 2, 3)
    });
    
    // name of getter is still the same
    var startDate   = subModel.getStartDate();

In the example above the `StartDate` field was completely re-defined to the `beginDate` field with different date format.
The `EndDate` has just changed its name to "finalizeDate". Note, that getters and setters are always named after "stable"
field name, not the customized one.

*/
Ext.define('Sch.model.Customizable', {
    extend      : 'Ext.data.Model',
    
    /**
     * @cfg {Array} customizableFields
     * 
     * The array of customizale fields definitions.
     */
    customizableFields      : null,
    
    onClassExtended : function (cls, data, hooks) {
        var onBeforeCreated = hooks.onBeforeCreated;

        hooks.onBeforeCreated = function (cls, data) {
            onBeforeCreated.call(this, cls, data);
            
            var proto                   = cls.prototype;

            if (!proto.customizableFields) {
                return;
            }

            // combining our customizable fields with ones from superclass
            // our fields goes after fields from superclass to overwrite them if some names match
            proto.customizableFields    = (cls.superclass.customizableFields || []).concat(proto.customizableFields);
            
            var customizableFields      = proto.customizableFields;
            
            // collect fields here, overwriting old ones with new
            var customizableFieldsByName    = {};
            
            Ext.Array.each(customizableFields, function (field) {
                // normalize to object 
                if (typeof field == 'string') field = { name : field };
                
                customizableFieldsByName[ field.name ] = field;
            });
            
            // already processed by the Ext.data.Model `onBeforeCreated`
            var fields                  = proto.fields;
            
            var toRemove                = [];
            
            fields.each(function (field) {
                if (field.isCustomizableField) toRemove.push(field);
            });
            
            fields.removeAll(toRemove);
            
            Ext.Object.each(customizableFieldsByName, function (name, customizableField) {
                // mark all customizable fields with special property, to be able remove them later
                customizableField.isCustomizableField     = true;
                
                var stableFieldName     = customizableField.name;
                
                var fieldProperty       = stableFieldName === 'Id' ? 'idProperty' : stableFieldName.charAt(0).toLowerCase() + stableFieldName.substr(1) + 'Field';
                var overrideFieldName   = proto[ fieldProperty ];
                
                var realFieldName       = overrideFieldName || stableFieldName;
                
                if (fields.containsKey(realFieldName)) {
                    // if user has re-defined some customizable field, mark it accordingly
                    // such fields weren't be inheritable though (won't replace the customizable field)
                    fields.getByKey(realFieldName).isCustomizableField = true;
                    
                    // add it to our customizable fields list on the last position, so in the subclasses
                    // it will overwrite other fields with this name
                    customizableFields.push(
                        new Ext.data.Field(
                            Ext.applyIf({ name : stableFieldName, isCustomizableField : true }, fields.getByKey(realFieldName))
                        )
                    );
                } else
                    // we create a new copy of the `customizableField` using possibly new name 
                    fields.add(new Ext.data.Field(Ext.applyIf({ name : realFieldName, isCustomizableField : true }, customizableField)));
                
                var capitalizedStableName  = Ext.String.capitalize(stableFieldName);
                
                // don't overwrite `getId` method
                if (capitalizedStableName != 'Id') {
                    var getter              = 'get' + capitalizedStableName;
                    var setter              = 'set' + capitalizedStableName;
                    
                    // overwrite old getters, pointing to a different field name
                    if (!proto[ getter ] || proto[ getter ].__getterFor__ && proto[ getter ].__getterFor__ != realFieldName) {
                        proto[ getter ] = function () {
                            return this.data[ realFieldName ];
                        };
                        
                        proto[ getter ].__getterFor__   = realFieldName;
                    }
                    
                    // same for setters
                    if (!proto[ setter ] || proto[ setter ].__setterFor__ && proto[ setter ].__setterFor__ != realFieldName) {
                        proto[ setter ] = function (value) {
                            return this.set(realFieldName, value);
                        };
                        
                        proto[ setter ].__setterFor__   = realFieldName;
                    }
                }
            });
        };
    },

    // Overridden to be able to track previous record field values
    set : function(fieldName, value) {
        if (arguments.length === 2) {
            this.previous = this.previous || {};
            var currentValue = this.get(fieldName);
        
            // Store previous field value
            if (currentValue !== value) {
                this.previous[fieldName] = currentValue;
            }
        }
        this.callParent(arguments);
    },

    // Overridden to be able to track previous record field values
    afterEdit : function() {
        this.callParent(arguments);
        
        // Reset the previous tracking object
        delete this.previous;
    },

    // Overridden to be able to track previous record field values
    reject : function () {
        var me = this,
            modified = me.modified,
            field;

        me.previous = me.previous || {};
        for (field in modified) {
            if (modified.hasOwnProperty(field)) {
                if (typeof modified[field] != "function") {
                    me.previous[field] = me.get(field);
                }
            }
        }
        me.callParent(arguments);
        
        // Reset the previous tracking object
        delete me.previous;
    }
});



Ext.define('Sch.patches.Model', {
    extend: "Sch.util.Patch",
    requires : 'Sch.model.Customizable',

    reportURL: 'http://www.sencha.com/forum/showthread.php?198250-4.1-Ext.data.Model-regression',
    description: 'In Ext 4.1 Models cannot be subclassed',

    applyFn: function () {
        try {
            Ext.define('Sch.foo', { extend: 'Ext.data.Model',        fields: ['a'] });
            Ext.define('Sch.foo.Sub', { extend: 'Sch.foo',    fields: ['a'] });
        } catch (e) {
            // PATCH
            Ext.data.Types.AUTO.convert = function (v) { return v; };
        }
    }
});

/**

@class Sch.model.Range
@extends Sch.model.Customizable

This class represent a simple date range. It is being used in various subclasses and plugins which operate on date ranges. 

Its a subclass of the {@link Sch.model.Customizable}, which is in turn subclass of {@link Ext.data.Model}.
Please refer to documentation of those classes to become familar with the base interface of this class. 

A range has the following fields:

- `StartDate`   - start date of the task in the ISO 8601 format
- `EndDate`     - end date of the task in the ISO 8601 format (not inclusive)
- `Name`        - an optional name of the range
- `Cls`         - an optional CSS class to be associated with the range. 

The name of any field can be customized in the subclass. Please refer to {@link Sch.model.Customizable} for details.

*/
Ext.define('Sch.model.Range', {
    extend      : 'Sch.model.Customizable',
    
    requires    : [
        'Sch.util.Date',
        'Sch.patches.DataOperation'
    ],

    /**
    * @cfg {String} startDateField The name of the field that defines the range start date. Defaults to "StartDate".
    */ 
    startDateField  : 'StartDate',
    
    /**
    * @cfg {String} endDateField The name of the field that defines the range end date. Defaults to "EndDate".
    */
    endDateField    : 'EndDate',

    /**
    * @cfg {String} nameField The name of the field that defines the range name. Defaults to "Name".
    */
    nameField       : 'Name',
    
    /**
    * @cfg {String} clsField The name of the field that holds the range "class" value (usually corresponds to a CSS class). Defaults to "Cls".
    */
    clsField        : 'Cls',
    
    customizableFields : [
        /**
         * @method getStartDate
         * 
         * Returns the range start date
         * 
         * @return {Date} The start date 
         */
        /**
         * @method setStartDate
         * 
         * Sets the range start date
         * 
         * @param {Date} date The new start date 
         */
        { name      : 'StartDate',  type    : 'date', dateFormat : 'c' },
        
        /**
         * @method getEndDate
         * 
         * Returns the range end date
         * 
         * @return {Date} The end date 
         */
    
    
        /**
         * @method setEndDate
         * 
         * Sets the range end date
         * 
         * @param {Date} date The new end date 
         */        
        { name      : 'EndDate',    type    : 'date', dateFormat : 'c' },
        
        /**
         * @method getCls
         * 
         * Gets the "class" of the range
         * 
         * @return {String} cls The "class" of the range 
         */        
        /**
         * @method setCls
         * 
         * Sets the "class" of the range
         * 
         * @param {String} cls The new class of the range 
         */        
        {   
            name            : 'Cls', type    : 'string'
        },

        /**
         * @method getName
         * 
         * Gets the name of the range
         * 
         * @return {String} name The "name" of the range 
         */        
        /**
         * @method setName
         * 
         * Sets the "name" of the range
         * 
         * @param {String} name The new name of the range 
         */        
        {   
            name            : 'Name', type    : 'string'
        }
    ],
    
    /**
     * Sets the event start and end dates
     * 
     * @param {Date} start The new start date 
     * @param {Date} end The new end date 
     */
    setStartEndDate : function(start, end) {
        this.beginEdit();
        this.set(this.startDateField, start);
        this.set(this.endDateField, end);
        this.endEdit();
    },
    
    /**
     * Returns an array of dates in this range. If the range starts/ends not at the beginning of day, the whole day will be included.
     * @return {Array[Date]}
     */
    getDates : function () {
        var dates   = [],
            endDate = this.getEndDate();
        
        for (var date = Ext.Date.clearTime(this.getStartDate(), true); date < endDate; date = Sch.util.Date.add(date, Sch.util.Date.DAY, 1)) {
            
            dates.push(date);
        }
        
        return dates;
    },
    
    
    /**
     * Iterates over the results from {@link #getDates}
     * @param {Function} func The function to call for each date
     * @param {Object} scope The scope to use for the function call
     */
    forEachDate : function (func, scope) {
        return Ext.each(this.getDates(), func, scope);
    },

    // Simple check if end date is greater than start date
    isValid : function() {
        var valid = this.callParent(arguments);

        if (valid) {
            var start = this.getStartDate(),
                end = this.getEndDate();

            valid = !start || !end || (end - start >= 0);
        }

        return valid;
    }
});
/**

@class Sch.model.Resource
@extends Sch.model.Customizable

This class represent a single Resource in the scheduler chart. Its a subclass of the {@link Sch.model.Customizable}, which is in turn subclass of {@link Ext.data.Model}.
Please refer to documentation of those classes to become familar with the base interface of the resource.

A Resource has only 2 mandatory fields - `Id` and `Name`. If you want to add more fields with meta data describing your resources then you should subclass this class:

    Ext.define('MyProject.model.Resource', {
        extend      : 'Sch.model.Resource',
        
        fields      : [
            // `Id` and `Name` fields are already provided by the superclass
            { name: 'Company',          type : 'string' }
        ],
        
        getCompany : function () {
            return this.get('Company');
        },
        ...
    });

If you want to use other names for the Id and Name fields you can configure them as seen below:

     Ext.define('MyProject.model.Resource', {
        extend      : 'Sch.model.Resource',
        
        nameField   : 'UserName',
        ...
    });
    
Please refer to {@link Sch.model.Customizable} for details.

*/
Ext.define('Sch.model.Resource', {
    extend      : 'Sch.model.Customizable',
    
    idProperty  : 'Id',

    /**
    * @cfg {String} nameField The name of the field that holds the resource name. Defaults to "Name".
    */
    nameField       : 'Name',

    customizableFields : [
        'Id',
        
        /**
         * @method getName
         * 
         * Returns the resource name
         * 
         * @return {String} The name of the resource
         */
        /**
         * @method setName
         * 
         * Sets the resource name
         * 
         * @param {String} The new name of the resource
         */        
        { name : 'Name', type : 'string' }
    ],

    getEventStore : function () {
        return this.stores[0] && this.stores[0].eventStore || this.parentNode && this.parentNode.getEventStore();
    },

    
    /**
     * Returns an array of events, associated with this resource 
     * @param {Sch.data.EventStore} eventStore (optional) The event store to get events for (if a resource is bound to multiple stores)
     * @return {Array[Sch.model.Event]}
     */
    getEvents : function(eventStore) {
        var events = [], 
            ev,   
            id = this.getId() || this.internalId;

        eventStore = eventStore || this.getEventStore();

        for (var i = 0, l = eventStore.getCount(); i < l; i++) {
            ev = eventStore.getAt(i);
            if (ev.data[ev.resourceIdField] === id) {
                events.push(ev);
            }
        }

        return events;
    }
});
/**
 * @class Sch.data.mixin.ResourceStore
 * This is a mixin for the ResourceStore functionality. It is consumed by the {@link Sch.data.ResourceStore} class ("usual" store) and {@link Sch.data.ResourceTreeStore} - tree store.
 * 
 */
Ext.define("Sch.data.mixin.ResourceStore", {
});
/**
@class Sch.data.ResourceStore
 
This is a class holding the collection the {@link Sch.model.Resource resources} to be rendered into a {@link Sch.panel.SchedulerGrid scheduler panel}. 
Its a subclass of "Ext.data.Store" - a store with linear data presentation.

*/
Ext.define("Sch.data.ResourceStore", {
    extend  : 'Ext.data.Store',
    model   : 'Sch.model.Resource',
    
    mixins  : [
        'Sch.data.mixin.ResourceStore'
    ]
});
/**
@class Sch.data.TimeAxis
@extends Ext.util.Observable

A class representing the time axis of the scheduler. The scheduler timescale is based on the ticks generated by this class.
This is a pure "data" (model) representation of the time axis and has no UI elements.
 
Time axis can be {@link #continuous} or not. In continuos time axis, each timespan start where the previous ended, in non-continuous - well, not.
Non-continuous time axis can be used when want to filter out certain days (like weekends) from the time axis.

To create a non-continuos time axis you have 2 options. First, you can create the time axis w/o unneeded timeframes from start.
To do that, subclass the time axis class and override the {@link #generateTicks} method. See the `noncontinuous-timeaxis` example.

Second, you can call the {@link #filterBy} method of the time axis, passing the function to it, which should return `true` if the time tick should be filtered out.
Calling the {@link #clearFilter} method will return you to full time axis.
 
*/
Ext.define("Sch.data.TimeAxis", {
    extend      : "Ext.util.Observable",
    
    requires    : [
        'Ext.data.JsonStore',
        'Sch.util.Date'
    ],
    
    
    reverse     : false,

    /**
    * @cfg {Boolean} continuous
    * Set to false if the timeline is not continuous, e.g. the next timespan does not start where the previous ended (for example skipping weekends etc).
    */
    continuous : true,

    autoAdjust : true,

    // private
    constructor : function(config) {
        Ext.apply(this, config);
        this.originalContinuous = this.continuous;

        this.addEvents(
            /**
            * @event beforereconfigure
            * Fires before the timeaxis is about to be reconfigured (e.g. new start/end date or unit/increment). Return false to abort the operation.
            * @param {Sch.data.TimeAxis} timeAxis The timeAxis object
            * @param {Date} startDate The new time axis start date
            * @param {Date} endDate The new time axis end date
            */
            'beforereconfigure',

            /**
            * @event reconfigure
            * Fires when the timeaxis has been reconfigured (e.g. new start/end date or unit/increment)
            * @param {Sch.data.TimeAxis} timeAxis The timeAxis object
            */
            'reconfigure'
        );
                
        this.tickStore = new Ext.data.JsonStore({
            // TODO Enable when needed for RTL support
//            sorters:{
//                property: 'start', 
//                direction: this.reverse ? "DESC" : "ASC"
//            },
            fields : ['start', 'end']
        });
        
        this.tickStore.on('datachanged', function() {
            this.fireEvent('reconfigure', this);
        }, this);

        this.callParent(arguments);
    },

    /**
    * Reconfigures the time axis based on the config object supplied and generates the new 'ticks'.
    * @param {Object} config
    * @private
    */
    reconfigure : function(config) {
        Ext.apply(this, config); 
        var tickStore = this.tickStore,
            ticks = this.generateTicks(this.start, this.end, this.unit, this.increment || 1, this.mainUnit);
        
        if (this.fireEvent('beforereconfigure', this, this.start, this.end) !== false) {
            // Suspending to be able to detect an invalid filter
            tickStore.suspendEvents(true);
            tickStore.loadData(ticks);
        
            if (tickStore.getCount() === 0) {
                Ext.Error.raise('Invalid time axis configuration or filter, please check your input data.');
            }
            tickStore.resumeEvents();
        }
    },

    /**
    * Changes the time axis timespan to the supplied start and end dates.
    * @param {Date} start The new start date
    * @param {Date} end The new end date
    */
    setTimeSpan : function(start, end) {
        this.reconfigure({
            start : start,
            end : end
        });
    },

    /**
     * [Experimental] Filter the time axis by a function. The passed function will be called with each tick in time axis. 
     * If the function returns true, the 'tick' is included otherwise it is filtered.
     * @param {Function} fn The function to be called, it will receive an object with start/end properties, and 'index' of the tick.
     * @param {Object} scope (optional) The scope (`this` reference) in which the function is executed. 
     */
    filterBy : function(fn, scope) {
        this.continuous = false;
        scope = scope || this;
        
        var tickStore = this.tickStore;

        tickStore.clearFilter(true);
        // Suspending to be able to detect an invalid filter
        tickStore.suspendEvents(true);
        tickStore.filter([{
            filterFn : function(t, index) {
                return fn.call(scope, t.data, index);
            }
        }]);
        
        if (tickStore.getCount() === 0) {
            Ext.Error.raise('Invalid time axis filter - no columns passed through the filter. Please check your filter method.');
            this.clearFilter();
        }
        tickStore.resumeEvents();
    },

    /**
     * Returns `true` if the time axis is continuos (will return `false` when filtered)
     * @return {Boolean}
     */
    isContinuous : function() {
        return this.continuous && !this.tickStore.isFiltered();
    },

    /**
     * Clear the current filter of the time axis
     */
    clearFilter : function() {
        this.continuous = this.originalContinuous;
        this.tickStore.clearFilter();
    },

    /**
     * Method generating the ticks for this time axis. Should return an array of ticks. Each tick is an object of the following structure:
        {
            start       : ..., // start date
            end         : ...  // end date
        }
     *  
     * @param {Date} startDate The start date of the interval
     * @param {Date} endDate The end date of the interval
     * @param {String} unit The unit of the time axis
     * @param {Mixed} increment The increment for the unit specified.
     * @return {Array} ticks The ticks representing the time axis
     */
    generateTicks : function(start, end, unit, increment) {
    
        var ticks = [],
            intervalEnd,
            DATE = Sch.util.Date,
            dstDiff = 0;

        unit = unit || this.unit;
        increment = increment || this.increment;
        
        if (this.autoAdjust) {
            start = this.floorDate(start || this.getStart(), false);
            end = this.ceilDate(end || DATE.add(start, this.mainUnit, this.defaultSpan), false);
        }
       
        while (start < end) {
            intervalEnd = this.getNext(start, unit, increment);
            
            // Handle hourly increments crossing DST boundaries to keep the timescale looking correct
            // Only do this for HOUR resolution currently, and only handle it once per tick generation.
            if (unit === DATE.HOUR && increment > 1 && ticks.length > 0 && dstDiff === 0) {
                var prev = ticks[ticks.length-1];
                
                dstDiff = ((prev.start.getHours()+increment) % 24) - prev.end.getHours();

                if (dstDiff !== 0) {
                    // A DST boundary was crossed in previous tick, adjust this tick to keep timeaxis "symmetric".
                    intervalEnd = DATE.add(intervalEnd, DATE.HOUR, dstDiff);
                }
            }

            ticks.push({
                start : start,
                end : intervalEnd
            });
            start = intervalEnd;
        }
        return ticks;
    },

    /**
    * Gets a tick coordinate representing the date parameter on the time scale
    * @param {Date} date the date to get x coordinate for
    * @return {Float} the tick position on the scale
    */
    getTickFromDate : function(date) {
        
        if (this.getStart() > date || this.getEnd() < date) {
            return -1;
        } 

        var ticks = this.tickStore.getRange(),
            tickStart, tickEnd, i, l;

        if (this.reverse) {
            for (i = ticks.length-1; i >= 0; i--) {
                tickEnd = ticks[i].data.end;
                if (date <= tickEnd) {
                    tickStart = ticks[i].data.start;
                    
                    return i + (date < tickEnd ? (1 - (date - tickStart)/(tickEnd - tickStart)) : 0);
                } 
            }
        } else {
            for (i = 0, l = ticks.length; i < l; i++) {
                tickEnd = ticks[i].data.end;
                if (date <= tickEnd) {
                    tickStart = ticks[i].data.start;
                    
                    return i + (date > tickStart ? (date - tickStart)/(tickEnd - tickStart) : 0);
                } 
            }
        }
        
        return -1;
    },

    /**
    * Gets the time represented by a tick "coordinate".
    * @param {Float} tick the tick "coordinate"
    * @param {String} roundingMethod The rounding method to use
    * @return {Date} The date to represented by the tick "coordinate", or null if invalid.
    */
    getDateFromTick : function(tick, roundingMethod) {
        var count = this.tickStore.getCount();
        
        if (tick === count){
            return this.reverse ? this.getStart() : this.getEnd();
        }

        var wholeTick = Math.floor(tick),
            fraction = tick - wholeTick,
            t = this.getAt(wholeTick);

        var date = Sch.util.Date.add(t.start, Sch.util.Date.MILLI, (this.reverse ? (1 - fraction) : fraction) * (t.end - t.start));

        if (roundingMethod) {
            date = this[roundingMethod + 'Date'](date);
        }

        return date;
    },

    /**
    * Gets the tick with start and end date for the indicated tick index
    * @param {Float} tick the tick "coordinate"
    * @return {Object} The tick object containing a "start" date and an "end" date.
    */
    getAt : function(index) {
        return this.tickStore.getAt(index).data;
    },

    // private
    getCount : function() {
        return this.tickStore.getCount();
    },
    
    /**
    * Returns the ticks of the timeaxis in an array of objects with a "start" and "end" date.
    * @return {Array[Object]} the ticks on the scale
    */
    getTicks : function() {
        var ticks = [];
        
        this.tickStore.each(function(r) { ticks.push(r.data); });
        return ticks;
    },

    /**
    * Method to get the current start date of the time axis
    * @return {Date} The start date
    */
    getStart : function() {
        return Ext.Date.clone(this.tickStore[this.reverse ? "last" : "first"]().data.start);
    },

    /**
    * Method to get a the current end date of the time axis
    * @return {Date} The end date
    */
    getEnd : function() {
        return Ext.Date.clone(this.tickStore[this.reverse ? "first" : "last"]().data.end);
    },

    // Floors the date to nearest minute increment
    // private
    roundDate : function(date) {
        var dt = Ext.Date.clone(date),
            relativeTo = this.getStart(),
            increment = this.resolutionIncrement;
        
        switch(this.resolutionUnit) {
            case Sch.util.Date.MILLI:    
                var milliseconds = Sch.util.Date.getDurationInMilliseconds(relativeTo, dt),
                    snappedMilliseconds = Math.round(milliseconds / increment) * increment;
                dt = Sch.util.Date.add(relativeTo, Sch.util.Date.MILLI, snappedMilliseconds);
                break;

            case Sch.util.Date.SECOND:
                var seconds = Sch.util.Date.getDurationInSeconds(relativeTo, dt),
                    snappedSeconds = Math.round(seconds / increment) * increment;
                dt = Sch.util.Date.add(relativeTo, Sch.util.Date.MILLI, snappedSeconds * 1000);
                break;

            case Sch.util.Date.MINUTE:
                var minutes = Sch.util.Date.getDurationInMinutes(relativeTo, dt),
                    snappedMinutes = Math.round(minutes / increment) * increment;
                dt = Sch.util.Date.add(relativeTo, Sch.util.Date.SECOND, snappedMinutes * 60);
                break; 

            case Sch.util.Date.HOUR:
                var nbrHours = Sch.util.Date.getDurationInHours(this.getStart(), dt),
                    snappedHours = Math.round(nbrHours / increment) * increment;
                dt = Sch.util.Date.add(relativeTo, Sch.util.Date.MINUTE, snappedHours * 60);
                break;

            case Sch.util.Date.DAY:
                var nbrDays = Sch.util.Date.getDurationInDays(relativeTo, dt),
                    snappedDays = Math.round(nbrDays / increment) * increment;
                dt = Sch.util.Date.add(relativeTo, Sch.util.Date.DAY, snappedDays);
                break;

            case Sch.util.Date.WEEK:
                Ext.Date.clearTime(dt);

                var distanceToWeekStartDay = dt.getDay() - this.weekStartDay,
                    toAdd;
                    
                if (distanceToWeekStartDay < 0) {
                    distanceToWeekStartDay = 7 + distanceToWeekStartDay;
                }

                if (Math.round(distanceToWeekStartDay/7) === 1) {
                    toAdd = 7 - distanceToWeekStartDay;
                } else {
                    toAdd = -distanceToWeekStartDay;
                }

                dt = Sch.util.Date.add(dt, Sch.util.Date.DAY, toAdd);
                break;

            case Sch.util.Date.MONTH:
                var nbrMonths = Sch.util.Date.getDurationInMonths(relativeTo, dt) + (dt.getDate() / Ext.Date.getDaysInMonth(dt)),
                    snappedMonths = Math.round(nbrMonths / increment) * increment;
                dt = Sch.util.Date.add(relativeTo, Sch.util.Date.MONTH, snappedMonths);
                break;

            case Sch.util.Date.QUARTER:
                Ext.Date.clearTime(dt);
                dt.setDate(1);
                dt = Sch.util.Date.add(dt, Sch.util.Date.MONTH, 3 - (dt.getMonth() % 3));
                break;

            case Sch.util.Date.YEAR:
                var nbrYears = Sch.util.Date.getDurationInYears(relativeTo, dt),
                    snappedYears = Math.round(nbrYears / increment) * increment;
                dt = Sch.util.Date.add(relativeTo, Sch.util.Date.YEAR, snappedYears);
                break;

        }
        return dt;
    },
    
    // Floors a date to the current resolution
    // private
    floorDate : function(date, relativeToStart) {
        relativeToStart = relativeToStart !== false;
        
        var dt = Ext.Date.clone(date),
            relativeTo = relativeToStart ? this.getStart() : null,
            increment = this.resolutionIncrement;
            
        switch(relativeToStart ? this.resolutionUnit : this.mainUnit) {
            case Sch.util.Date.MILLI:    
                if (relativeToStart) {
                    var milliseconds = Sch.util.Date.getDurationInMilliseconds(relativeTo, dt),
                        snappedMilliseconds = Math.floor(milliseconds / increment) * increment;
                    dt = Sch.util.Date.add(relativeTo, Sch.util.Date.MILLI, snappedMilliseconds);
                }
                break;

            case Sch.util.Date.SECOND:
                if (relativeToStart) {
                    var seconds = Sch.util.Date.getDurationInSeconds(relativeTo, dt),
                        snappedSeconds = Math.floor(seconds / increment) * increment;
                    dt = Sch.util.Date.add(relativeTo, Sch.util.Date.MILLI, snappedSeconds * 1000);
                } else {
                    dt.setMilliseconds(0);
                }
                break;

            case Sch.util.Date.MINUTE:
                if (relativeToStart) {
                    var minutes = Sch.util.Date.getDurationInMinutes(relativeTo, dt),
                        snappedMinutes = Math.floor(minutes / increment) * increment;
                    dt = Sch.util.Date.add(relativeTo, Sch.util.Date.SECOND, snappedMinutes * 60);
                } else {
                    dt.setSeconds(0);
                    dt.setMilliseconds(0);
                }
                break; 

            case Sch.util.Date.HOUR:
                if (relativeToStart) {
                    var nbrHours = Sch.util.Date.getDurationInHours(this.getStart(), dt),
                        snappedHours = Math.floor(nbrHours / increment) * increment;
                    dt = Sch.util.Date.add(relativeTo, Sch.util.Date.MINUTE, snappedHours * 60);
                } else {
                    dt.setMinutes(0);
                    dt.setSeconds(0);
                    dt.setMilliseconds(0);
                }
                break;

            case Sch.util.Date.DAY:
                if (relativeToStart) {
                    var nbrDays = Sch.util.Date.getDurationInDays(relativeTo, dt),
                        snappedDays = Math.floor(nbrDays / increment) * increment;
                    dt = Sch.util.Date.add(relativeTo, Sch.util.Date.DAY, snappedDays);
                } else {
                    Ext.Date.clearTime(dt);
                }
                break;

            case Sch.util.Date.WEEK:
                var day = dt.getDay();
                Ext.Date.clearTime(dt);
                if (day !== this.weekStartDay) {
                    dt = Sch.util.Date.add(dt, Sch.util.Date.DAY, -(day > this.weekStartDay ? (day - this.weekStartDay) : (7 - day - this.weekStartDay)));
                }
                break;

            case Sch.util.Date.MONTH:
                if (relativeToStart) {
                    var nbrMonths = Sch.util.Date.getDurationInMonths(relativeTo, dt),
                        snappedMonths = Math.floor(nbrMonths / increment) * increment;
                    dt = Sch.util.Date.add(relativeTo, Sch.util.Date.MONTH, snappedMonths);
                } else {
                    Ext.Date.clearTime(dt);
                    dt.setDate(1);
                }
                break;

            case Sch.util.Date.QUARTER:
                Ext.Date.clearTime(dt);
                dt.setDate(1);
                dt = Sch.util.Date.add(dt, Sch.util.Date.MONTH, -(dt.getMonth() % 3));
                break;

            case Sch.util.Date.YEAR:
                if (relativeToStart) {
                    var nbrYears = Sch.util.Date.getDurationInYears(relativeTo, dt),
                        snappedYears = Math.floor(nbrYears / increment) * increment;
                    dt = Sch.util.Date.add(relativeTo, Sch.util.Date.YEAR, snappedYears);
                } else {
                    dt = new Date(date.getFullYear(), 0, 1);
                }
                break;

        }
        return dt;
    },

    // private
    ceilDate : function(date, relativeToStart) {
        var dt = Ext.Date.clone(date);
        relativeToStart = relativeToStart !== false;
        
        var increment = relativeToStart ? this.resolutionIncrement : 1,
            unit = relativeToStart ? this.resolutionUnit : this.mainUnit,
            doCall = false;

        switch (unit) {
            case Sch.util.Date.DAY: 
                if (dt.getMinutes() > 0 || dt.getSeconds() > 0 || dt.getMilliseconds() > 0) {
                    doCall = true;
                }
            break;

            case Sch.util.Date.WEEK: 
                Ext.Date.clearTime(dt);
                if (dt.getDay() !== this.weekStartDay) {
                    doCall = true;
                }
            break;

            case Sch.util.Date.MONTH: 
                Ext.Date.clearTime(dt);
                if(dt.getDate() !== 1) {
                    doCall = true;
                }
            break;

            case Sch.util.Date.QUARTER:
                Ext.Date.clearTime(dt);
                if(dt.getMonth() % 3 !== 0) {
                    doCall = true;
                }
            break;
            
            case Sch.util.Date.YEAR:
                Ext.Date.clearTime(dt);
                if(dt.getMonth() !== 0 && dt.getDate() !== 1) {
                    doCall = true;
                }
            break;

            default:
            break;
        }

        if (doCall) {
            return this.getNext(dt, unit, increment);
        } else {
            return dt;
        }
    },

    // private
    getNext : function(date, unit, increment) {
        return Sch.util.Date.getNext(date, unit, increment, this.weekStartDay);
    },

    // private
    getResolution : function() {
        return {
            unit : this.resolutionUnit,
            increment : this.resolutionIncrement
        };
    },

    // private
    setResolution : function(unit, increment) {
        this.resolutionUnit = unit;
        this.resolutionIncrement = increment || 1;
    },

    /**
    * Moves the time axis forward in time in units specified by the view preset `shiftUnit`, and by the amount specified by the `shiftIncrement` 
    * config of the current view preset.
    * @param {Int} amount (optional) The number of units to jump forward
    */
    shiftNext: function (amount) {
        amount = amount || this.getShiftIncrement();
        var unit = this.getShiftUnit();
        this.setTimeSpan(Sch.util.Date.add(this.getStart(), unit, amount), Sch.util.Date.add(this.getEnd(), unit, amount));
    },

    /**
    * Moves the time axis backward in time in units specified by the view preset `shiftUnit`, and by the amount specified by the `shiftIncrement` config of the current view preset.
    * @param {Int} amount (optional) The number of units to jump backward
    */
    shiftPrevious: function (amount) {
        amount = -(amount || this.getShiftIncrement());
        var unit = this.getShiftUnit();
        this.setTimeSpan(Sch.util.Date.add(this.getStart(), unit, amount), Sch.util.Date.add(this.getEnd(), unit, amount));
    },

    getShiftUnit: function () {
        return this.shiftUnit || this.getMainUnit();
    },
    
    // private
    getShiftIncrement: function () {
        return this.shiftIncrement || 1;
    },
    
    // private
    getUnit: function () {
        return this.unit;
    },

    // private
    getIncrement: function () {
        return this.increment;
    },

    /**
    * Returns true if the passed timespan is part of the current time axis (in whole or partially).
    * @param {Date} start The start date
    * @param {Date} end The end date
    * @return {boolean} true if the timespan is part of the timeaxis
    */
    timeSpanInAxis: function(start, end) {
        if (this.continuous) {
            return Sch.util.Date.intersectSpans(start, end, this.getStart(), this.getEnd());
        } else {
            return end > start && this.getTickFromDate(start) !== this.getTickFromDate(end);
        }
    }
});
/**
@class Sch.preset.Manager
@singleton

Provides a registry of the possible view presets that any instance of an grid with {@link Sch.mixin.SchedulerPanel} mixin can use.

See the {@link Sch.preset.ViewPreset}, {@link Sch.preset.ViewPresetHeaderRow} for description of the view preset properties.

Available presets are:

- `hourAndDay` - creates 2 level headers - day and hours within it: {@img scheduler/images/hourAndDay.png} 
- `dayAndWeek` - creates 2 level headers - week and days within it: {@img scheduler/images/dayAndWeek.png} 
- `weekAndDay` - just like `dayAndWeek` but with different formatting: {@img scheduler/images/weekAndDay.png} 
- `weekAndMonth` - creates 2 level headers - month and weeks within it: {@img scheduler/images/weekAndMonth.png}

- `monthAndYear` - creates 2 level headers - year and months within it: {@img scheduler/images/monthAndYear.png}
- `year` - creates 2 level headers - year and quarters within it: {@img scheduler/images/year-preset.png}
- `weekAndDayLetter` - creates a lightweight 2 level headers - weeks and days within it (days are not real columns). 
   See {@link Sch.util.HeaderRenderers} for details. {@img scheduler/images/header-renderer2.png}
- `weekDateAndMonth` - creates 2 level headers - month and weeks within it (weeks shown by first day only): {@img scheduler/images/weekDateAndMonth.png}

You can register your own preset with the {@link #registerPreset} call 

*/
 
Ext.define('Sch.preset.Manager', {
    extend: 'Ext.util.MixedCollection',
    requires: [
        'Sch.util.Date',
        'Sch.util.HeaderRenderers'
    ],
    singleton: true,

    constructor : function() {
        this.callParent(arguments);
        this.registerDefaults();
    },
    
    /**
    * Registers a new view preset to be used by any scheduler grid or tree on the page.
    * @param {String} name The unique name identifying this preset
    * @param {Object} config The configuration properties of the view preset (see {@link Sch.preset.ViewPreset} for more information)
    */
    registerPreset : function(name, cfg) {
        if (cfg) {
            var headerConfig    = cfg.headerConfig;
            var DATE            = Sch.util.Date;
            
            // Make sure date "unit" constant specified in the preset are resolved
            for (var o in headerConfig) {
                if (headerConfig.hasOwnProperty(o)) {
                    if (DATE[headerConfig[o].unit]) {
                        headerConfig[o].unit = DATE[headerConfig[o].unit.toUpperCase()];
                    }
                }
            }
            
            if (!cfg.timeColumnWidth) {
                cfg.timeColumnWidth = 50;
            }

            // Resolve date units
            if (cfg.timeResolution && DATE[cfg.timeResolution.unit]) {
                cfg.timeResolution.unit = DATE[cfg.timeResolution.unit.toUpperCase()];
            }

            // Resolve date units
            if (cfg.shiftUnit && DATE[cfg.shiftUnit]) {
                cfg.shiftUnit = DATE[cfg.shiftUnit.toUpperCase()];
            }
        }
        
        if (this.isValidPreset(cfg)) {
            if (this.containsKey(name)){
                this.removeAtKey(name);
            }
            this.add(name, cfg);
        } else {
            throw 'Invalid preset, please check your configuration';
        }
    },

    isValidPreset : function(cfg) {
        var D = Sch.util.Date,
            valid = true,
            validUnits = Sch.util.Date.units;

        // Make sure all date "unit" constants are valid
        for (var o in cfg.headerConfig) {
            if (cfg.headerConfig.hasOwnProperty(o)) {
                valid = valid && Ext.Array.indexOf(validUnits, cfg.headerConfig[o].unit) >= 0;
            }
        }

        if (cfg.timeResolution) {
            valid = valid && Ext.Array.indexOf(validUnits, cfg.timeResolution.unit) >= 0;
        }

        if (cfg.shiftUnit) {
            valid = valid && Ext.Array.indexOf(validUnits, cfg.shiftUnit) >= 0;
        }

        return valid;
    },

    /**
    * Fetches a view preset from the global cache
    * @param {String} name The name of the preset
    * @return {Object} The view preset, see {@link Sch.preset.ViewPreset} for more information
    */
    getPreset : function(name) {
        return this.get(name);
    },

    /**
    * Deletes a view preset 
    * @param {String} name The name of the preset
    */
    deletePreset : function(name) {
        this.removeAtKey(name);
    },

    registerDefaults : function() {
        var pm = this,
            vp = this.defaultPresets;

        for (var p in vp) {
            pm.registerPreset(p, vp[p]);
        }
    },

    defaultPresets : {
        hourAndDay : {
            timeColumnWidth : 60,   // Time column width (used for rowHeight in vertical mode)
            rowHeight: 24,          // Only used in horizontal orientation
            resourceColumnWidth : 100,  // Only used in vertical orientation
            displayDateFormat : 'G:i',  // Controls how dates will be displayed in tooltips etc
            shiftIncrement : 1,     // Controls how much time to skip when calling shiftNext and shiftPrevious.
            shiftUnit : "DAY",      // Valid values are "MILLI", "SECOND", "MINUTE", "HOUR", "DAY", "WEEK", "MONTH", "QUARTER", "YEAR".
            defaultSpan : 12,       // By default, if no end date is supplied to a view it will show 12 hours
            timeResolution : {      // Dates will be snapped to this resolution
                unit : "MINUTE",    // Valid values are "MILLI", "SECOND", "MINUTE", "HOUR", "DAY", "WEEK", "MONTH", "QUARTER", "YEAR".
                increment : 15
            },
            headerConfig : {    // This defines your header, you must include a "middle" object, and top/bottom are optional. For each row you can define "unit", "increment", "dateFormat", "renderer", "align", and "scope"
                middle : {              
                    unit : "HOUR",
                    dateFormat : 'G:i'
                },
                top : {
                    unit : "DAY",
                    dateFormat : 'D d/m'
                }
            }
        },
        dayAndWeek : {
            timeColumnWidth : 100,
            rowHeight: 24,          // Only used in horizontal orientation
            resourceColumnWidth : 100,  // Only used in vertical orientation
            displayDateFormat : 'Y-m-d G:i',
            shiftUnit : "DAY",
            shiftIncrement : 1,
            defaultSpan : 5,       // By default, show 5 days
            timeResolution : {
                unit : "HOUR",
                increment : 1
            },
            headerConfig : {
                middle : {
                    unit : "DAY",
                    dateFormat : 'D d M'
                },
                top : {
                    unit : "WEEK",
                    renderer : function(start, end, cfg) {
                        return Sch.util.Date.getShortNameOfUnit("WEEK") + '.' + Ext.Date.format(start, 'W M Y');
                    }
                }
            }
        },

        weekAndDay : {
            timeColumnWidth : 100,
            rowHeight: 24,          // Only used in horizontal orientation
            resourceColumnWidth : 100,  // Only used in vertical orientation
            displayDateFormat : 'Y-m-d',
            shiftUnit : "WEEK",
            shiftIncrement : 1,
            defaultSpan : 1,       // By default, show 1 week
            timeResolution : {
                unit : "DAY",
                increment : 1
            },
            headerConfig : {
                 bottom : {
                    unit : "DAY",
                    increment : 1,
                    dateFormat : 'd/m'
                },
                middle : {
                    unit : "WEEK",
                    dateFormat : 'D d M',
                    align : 'left'
                }
            }
        },

        weekAndMonth : {
            timeColumnWidth : 100,
            rowHeight: 24,          // Only used in horizontal orientation
            resourceColumnWidth : 100,  // Only used in vertical orientation
            displayDateFormat : 'Y-m-d',
            shiftUnit : "WEEK",
            shiftIncrement : 5,
            defaultSpan : 6,       // By default, show 6 weeks
            timeResolution : {
                unit : "DAY",
                increment : 1
            },
            headerConfig : {
                middle : {
                    unit : "WEEK",
                    renderer : function(start, end, cfg) {
                        cfg.align = 'left';
                        return Ext.Date.format(start, 'd M');
                    }
                },
                top : {
                    unit : "MONTH",
                    dateFormat : 'M Y'
                }
            }
        },

        monthAndYear : {
            timeColumnWidth : 110,
            rowHeight: 24,          // Only used in horizontal orientation
            resourceColumnWidth : 100,  // Only used in vertical orientation
            displayDateFormat : 'Y-m-d',
            shiftIncrement : 3,
            shiftUnit : "MONTH",
            defaultSpan : 12,       // By default, show 12 months
            timeResolution : {
                unit : "DAY",
                increment : 1
            },
            headerConfig : {
                middle : {
                    unit : "MONTH",
                    dateFormat : 'M Y'
                },
                top : {
                    unit : "YEAR",
                    dateFormat : 'Y'
                }
            }
        },
        year : {
            timeColumnWidth : 100,
            rowHeight: 24,          // Only used in horizontal orientation
            resourceColumnWidth : 100,  // Only used in vertical orientation
            displayDateFormat : 'Y-m-d',
            shiftUnit : "YEAR",
            shiftIncrement : 1,
            defaultSpan : 1,       // By default, show 1 year
            timeResolution : {
                unit : "MONTH",
                increment : 1
            },
            headerConfig : {
                bottom : {
                    unit : "QUARTER",
                    renderer : function(start, end, cfg) {
                        return Ext.String.format(Sch.util.Date.getShortNameOfUnit("QUARTER").toUpperCase() + '{0}', Math.floor(start.getMonth() / 3) + 1);
                    }
                },
                middle : {
                    unit : "YEAR",
                    dateFormat : 'Y'
                }
            }
        },
        weekAndDayLetter : {
            timeColumnWidth : 20,
            rowHeight: 24,          // Only used in horizontal orientation
            resourceColumnWidth : 100,  // Only used in vertical orientation
            displayDateFormat : 'Y-m-d',
            shiftUnit : "WEEK",
            shiftIncrement : 1,
            defaultSpan : 10,       // By default, show 10 weeks
            timeResolution : {
                unit : "DAY",
                increment : 1
            },
            headerConfig : {
                 bottom : {
                    unit : "DAY",
                    increment : 1,
                    renderer : function(start) {
                        return Ext.Date.dayShortNames[start.getDay()].substring(0, 1);
                    }
                },
                middle : {
                    unit : "WEEK",
                    dateFormat : 'Y-m-d',
                    align : 'left'
                }
            }
        },
        weekDateAndMonth : {
            timeColumnWidth : 30,
            rowHeight: 24,          // Only used in horizontal orientation
            resourceColumnWidth : 100,  // Only used in vertical orientation
            displayDateFormat : 'Y-m-d',
            shiftUnit : "WEEK",
            shiftIncrement : 1,
            defaultSpan : 10,       // By default, show 10 weeks
            timeResolution : {
                unit : "DAY",
                increment : 1
            },
            headerConfig : {
                 middle : {
                    unit : "WEEK",
                    dateFormat : 'd'
                },
                top : {
                    unit : "MONTH",
                    dateFormat : 'Y F',
                    align : 'left'
                }
            }
        }
    }
}); 

/**
@class Sch.feature.AbstractTimeSpan
@extends Ext.util.Observable

Plugin for visualizing "global" time span in the scheduler grid, these can by styled easily using just CSS. This is an abstract class not intended for direct use.

*/
Ext.define("Sch.feature.AbstractTimeSpan", {
    
    schedulerView       : null,
    timeAxis            : null,
    containerEl         : null,
    
    // If lines/zones should stretch to fill the whole view container element in case the table does not fill it
    expandToFitView     : false,
    
    disabled            : false,
    
    /**
     * @property {String} cls An internal css class which is added to each rendered timespan element
     * @private
     */
    cls                 : null,
    
    /**
     * @cfg {Ext.XTemplate} template Template to render the timespan elements  
     */
    template            : null,

    /**
     * @cfg {Ext.data.Store} store A store with timespan data 
     */
    store               : null,
    
    renderElementsBuffered      : false,
    
    /**
     * @cfg {Int} renderDelay Delay the zones rendering by this amount (to speed up the default rendering of rows and events).
     */
    renderDelay : 15,

    constructor : function(cfg) {
        // unique css class to be able to identify only the zones belonging to this plugin instance
        this.uniqueCls = this.uniqueCls || ('sch-timespangroup-' + Ext.id());
        
        Ext.apply(this, cfg);
    },

    
    /**
     * @param {Boolean} disabled Pass `true` to disable the plugin (and remove all lines)
     */
    setDisabled : function(disabled) {
        if (disabled) {
            this.removeElements();
        }
        
        this.disabled = disabled;
    },

    
    /**
     * Returns the currently rendered DOM elements of this plugin (if any), as the {@link Ext.CompositeElementLite} instance.  
     * @return {Ext.CompositeElementLite}
     */
    getElements : function() {
        if (this.containerEl) {
            return this.containerEl.select('.' + this.uniqueCls);
        }

        return null;
    },
    
    
    // private
    removeElements : function() {
        var els = this.getElements();
        if (els) {
            els.remove();
        }
    },
    
    
    init:function(scheduler) {
        this.timeAxis = scheduler.getTimeAxis();
        this.schedulerView = scheduler.getSchedulingView(); 
    
        if (!this.store) {
            Ext.Error.raise("Error: You must define a store for this plugin");
        }
        
        this.schedulerView.on({
            afterrender : this.onAfterRender, 
            destroy : this.onDestroy, 
            scope : this
        });
    },
    
    
    onAfterRender : function (scheduler) {
        var view            = this.schedulerView;
        this.containerEl    = view.el;
        
        this.store.on({
            load            : this.renderElements,
            datachanged     : this.renderElements, 
            clear           : this.renderElements,
            
            add             : this.renderElements, 
            remove          : this.renderElements, 
            update          : this.refreshSingle, 
            
            scope           : this
        });
        
        if (Ext.data.NodeStore && view.store instanceof Ext.data.NodeStore) {
            // if the view is animated, then update the elements in "after*" events (when the animation has completed)
            if (view.animate) {
                // NOT YET SUPPORTED
//                view.on({
//                    afterexpand     : this.renderElements, 
//                    aftercollapse   : this.renderElements,
//                    
//                    scope           : this
//                });
            } else {
                view.store.on({
                    expand      : this.renderElements, 
                    collapse    : this.renderElements,
                    
                    scope       : this
                });
            }
        }
        
        view.on({
            refresh         : this.renderElements,
            itemadd         : this.renderElements,
            itemremove      : this.renderElements,
            itemupdate      : this.renderElements,
            // start grouping events
            groupexpand     : this.renderElements, 
            groupcollapse   : this.renderElements,
            
            scope           : this
        });

        view.headerCt.on({
            add         : this.renderElements,
            remove      : this.renderElements,
            scope       : this
        });

        view.on({
            columnwidthchange   : this.renderElements,
            resize              : this.renderElements,
            scope               : this
        });

        view.ownerCt.up('panel').on({
            viewchange          : this.renderElements,
            orientationchange   : this.renderElements,
            
            scope               : this
        });

        this.renderElements();
    },
    
    renderElements : function() {
        if (this.renderElementsBuffered || this.disabled || this.schedulerView.headerCt.getColumnCount() === 0) return;
        
        this.renderElementsBuffered = true;
        
        // Defer to make sure rendering is not delayed by this plugin
        // deferring on 15 because the cascade delay is 10 (cascading will trigger a view refresh)
        Ext.Function.defer(this.renderElementsInternal, this.renderDelay, this);
    },
    
    renderElementsInternal : function() {
        this.renderElementsBuffered = false;
        
        //                            | component can be destroyed during the buffering timeframe
        if (this.disabled || this.schedulerView.isDestroyed || this.schedulerView.headerCt.getColumnCount() === 0) return;
        
        this.removeElements();
        
        var start       = this.timeAxis.getStart(), 
            end         = this.timeAxis.getEnd(),
            data        = this.getElementData(start, end);
        
        this.template.insertFirst(this.containerEl, data);
    },
    
    
    getElementData : function(viewStart, viewEnd) {
        throw 'Abstract method call';
    },

    
    onDestroy : function() {
        if (this.store.autoDestroy) {
            this.store.destroy();
        }
    },

    refreshSingle : function(store, record) {
        var el = Ext.get(this.uniqueCls + '-' + record.internalId);
        
        if (el) {
            var start       = this.timeAxis.getStart(), 
                end         = this.timeAxis.getEnd(),
                data        = this.getElementData(start, end, [record])[0];
            
            el.setTop(data.top);
            el.setLeft(data.left);
            el.setSize(data.width, data.height);
        } else {
            // Should not happen, fallback to full refresh
            this.renderElements();
        }
    }
}); 

/**
@class Sch.plugin.Lines
@extends Sch.feature.AbstractTimeSpan
 
Plugin for showing "global" time lines in the scheduler grid. It uses a store to populate itself, records in this store should have the following fields:

- `Date` The date of the line
- `Text` The Text to show when hovering over the line (optional)
- `Cls`  A CSS class to add to the line (optional)

To add this plugin to scheduler:

        var dayStore    = new Ext.data.Store({
            fields  : [ 'Date', 'Text', 'Cls' ],
            
            data    : [
                {
                    Date        : new Date(2011, 06, 19),
                    Text        : 'Some important day'
                }
            ]
        }); 


        var scheduler = Ext.create('Sch.panel.SchedulerGrid', {
            ...
    
            resourceStore   : resourceStore,
            eventStore      : eventStore,
            
            plugins         : [
                Ext.create('Sch.plugin.Lines', { store : dayStore })
            ]
        });


*/
Ext.define("Sch.plugin.Lines", {
    extend      : "Sch.feature.AbstractTimeSpan",    

    cls : 'sch-timeline',
    
    /**
      * @cfg {Boolean} showTip 'true' to include a native browser tooltip when hovering over the line.
      */
    showTip : true,

    init : function(scheduler) {
        this.callParent(arguments);
        
        var view = this.schedulerView;
        
        if (!this.template) {
            this.template = new Ext.XTemplate(
                '<tpl for=".">',
                    '<div id="' + this.uniqueCls + '-{id}"' + (this.showTip ? 'title="{[this.getTipText(values)]}" ' : '') + 'class="' + this.cls + ' ' + this.uniqueCls + ' {Cls}" style="left:{left}px;top:{top}px;height:{height}px;width:{width}px"></div>',
                '</tpl>',
                {
                    getTipText : function (values) {
                        return view.getFormattedDate(values.Date) + ' ' + (values.Text || "");
                    }
                }
            );       
        }
    },
    
    
    getElementData : function(viewStart, viewEnd, records) {
        var s = this.store,
            scheduler = this.schedulerView,
            rs = records || s.getRange(),
            data = [],
            height = this.containerEl.lastBox ? this.containerEl.lastBox.height : this.containerEl.getHeight(),
            r, date, region, width;

        for (var i = 0, l = s.getCount(); i < l; i++) {
            r = rs[i];
            date = r.get('Date');
            
            if (date && Ext.Date.between(date, viewStart, viewEnd)) {
                region = scheduler.getTimeSpanRegion(date, null, this.expandToFitView);
                
                data[data.length] = Ext.apply({
                    id      : r.internalId,

                    left    : region.left,
                    top     : region.top,
                    width   : Math.max(1, region.right-region.left),
                    height  : region.bottom - region.top
                }, r.data);
            }
        }
        return data;
    }
}); 

/**
@class Sch.plugin.Zones
@extends Sch.feature.AbstractTimeSpan

Plugin for showing "global" zones in the scheduler grid, these can by styled easily using just CSS. 
To populate this plugin you need to pass it a store having the `Sch.model.Range` as the model.

{@img scheduler/images/scheduler-grid-horizontal.png}

To add this plugin to scheduler:

        var zonesStore = Ext.create('Ext.data.Store', {
            model   : 'Sch.model.Range',
            data    : [
                {
                    StartDate   : new Date(2011, 0, 6),
                    EndDate     : new Date(2011, 0, 7),
                    Cls         : 'myZoneStyle'
                }
            ]
        });

        var scheduler = Ext.create('Sch.panel.SchedulerGrid', {
            ...
    
            resourceStore   : resourceStore,
            eventStore      : eventStore,
            
            plugins         : [
                Ext.create('Sch.plugin.Zones', { store : zonesStore })
            ]
        });


*/
Ext.define("Sch.plugin.Zones", {
    extend      : "Sch.feature.AbstractTimeSpan",
    
    requires    : [
        'Sch.model.Range'
    ],

    cls : 'sch-zone',
    
    init:function(scheduler) {
        if (!this.template) {
            this.template = new Ext.XTemplate(
                '<tpl for=".">',
                    '<div id="' + this.uniqueCls + '-{id}" class="' + this.cls + ' ' + this.uniqueCls + ' {Cls}" style="left:{left}px;top:{top}px;height:{height}px;width:{width}px"></div>',
                '</tpl>'
            );
        }
        this.callParent(arguments);
    },

    
    getElementData : function(viewStart, viewEnd, records) {
        var s = this.store,
            scheduler = this.schedulerView,
            rs = records || s.getRange(),
            data = [],
            r, spanStart, spanEnd, region;
            
        for (var i = 0, l = s.getCount(); i < l; i++) {
            r = rs[i];

            spanStart = r.getStartDate();
            spanEnd = r.getEndDate();
            
            if (spanStart && spanEnd && Sch.util.Date.intersectSpans(spanStart, spanEnd, viewStart, viewEnd)) {
                
                region = scheduler.getTimeSpanRegion(Sch.util.Date.max(spanStart, viewStart), Sch.util.Date.min(spanEnd, viewEnd), this.expandToFitView);
                
                data[data.length] = Ext.apply({
                    id      : r.internalId,
                    
                    left    : region.left,
                    top     : region.top,
                    width   : region.right-region.left,
                    height  : region.bottom - region.top,
                    
                    Cls : r.getCls()
                }, r.data);
            }
        }
        return data;
    }
}); 

/**
@class Sch.plugin.Pan

A plugin enabling panning by clicking and dragging in a scheduling view.

To add this plugin to your scheduler or gantt view:

        var scheduler = Ext.create('Sch.panel.SchedulerGrid', {
            ...
    
            resourceStore   : resourceStore,
            eventStore      : eventStore,
            
            plugins         : [
                Ext.create('Sch.plugin.Pan', { enableVerticalPan : true })
            ]
        });


*/
Ext.define("Sch.plugin.Pan", {
    alias : 'plugin.pan',

    /**
     * @cfg {Boolean} enableVerticalPan
     * True to allow vertical panning
     */
    enableVerticalPan   : true,
    
    panel               : null,
    
    
    constructor : function(config) {
        Ext.apply(this, config);
    },

    init : function(pnl) {
        this.panel  = pnl.normalGrid || pnl;
        this.view   = pnl.getSchedulingView();
        
        this.view.on('afterrender', this.onRender, this);
    },

    onRender: function(s) {
        this.view.el.on('mousedown', this.onMouseDown, this, { delegate : '.' + this.view.timeCellCls });
    },

    onMouseDown: function(e, t) {
        // ignore clicks on tasks and events
        if (e.getTarget('.' + this.view.timeCellCls) && !e.getTarget(this.view.eventSelector)) {
            this.mouseX = e.getPageX();
            this.mouseY = e.getPageY();
            Ext.getBody().on('mousemove', this.onMouseMove, this);
            Ext.getDoc().on('mouseup', this.onMouseUp, this);
        }
    },

    onMouseMove: function(e) {
        e.stopEvent();
        
        var x = e.getPageX(),
            y = e.getPageY(),
            xDelta = x - this.mouseX,
            yDelta = y - this.mouseY;

        this.panel.scrollByDeltaX(-xDelta);
        this.mouseX = x;
        this.mouseY = y;
        
        if (this.enableVerticalPan) {
            this.panel.scrollByDeltaY(-yDelta);
        }
    },

    onMouseUp: function(e) {
        Ext.getBody().un('mousemove', this.onMouseMove, this);
        Ext.getDoc().un('mouseup', this.onMouseUp, this);
    }   
});

Ext.define('Sch.view.Locking', {
    
    extend : 'Ext.grid.LockingView',

    scheduleEventRelayRe: /^(schedule|event|beforeevent|afterevent|dragcreate|beforedragcreate|afterdragcreate|beforetooltipshow)/,
    
    constructor: function(config){
        this.callParent(arguments);
        
        var me = this,
            eventNames = [],
            eventRe = me.scheduleEventRelayRe,
            normal = config.normal.getView(),
            events = normal.events,
            event;
        
        for (event in events) {
            if (events.hasOwnProperty(event) && eventRe.test(event)) {
                eventNames.push(event);
            }
        }
        me.relayEvents(normal, eventNames);
    },
    
    getElementFromEventRecord : function (record) {
        return this.normal.getView().getElementFromEventRecord(record);
    },
    
    
    onClear : function () {
        this.relayFn('onClear', arguments);
    },

    // For tree view
    beginBulkUpdate : function() {
        this.relayFn('beginBulkUpdate', arguments);
    },

    // For tree view
    endBulkUpdate : function() {
        this.relayFn('endBulkUpdate', arguments);
    },

    refreshKeepingScroll : function() {
        this.locked.getView().refresh();
        this.normal.getView().refreshKeepingScroll();
    }
});
/*
@class Sch.column.Time
@extends Ext.grid.Column
@private

A Column representing a time span in the schedule
*/
Ext.define('Sch.column.Time', {
    extend          : 'Ext.grid.column.Column',
    alias           : 'timecolumn',

    draggable       : false,
    groupable       : false,
    hideable        : false,
    sortable        : false,
    
    fixed           : true,
    
    align           : 'center',
    tdCls           : 'sch-timetd',
    menuDisabled    : true,
    
    initComponent   : function () {
        this.addEvents('timeheaderdblclick');
        this.enableBubble('timeheaderdblclick');
        
        this.callParent();
    },
    
    initRenderData: function() {
        var me = this;
        me.renderData.headerCls = me.renderData.headerCls || me.headerCls;
        return me.callParent(arguments);
    },
    
    // HACK, overriding private method    
    onElDblClick: function (e, t) {
        this.callParent(arguments);
        
        this.fireEvent('timeheaderdblclick', this, this.startDate, this.endDate, e);
    }
}, function() {
    // Inject placeholder for {headerCls} and sch-timeheader
    Sch.column.Time.prototype.renderTpl = Sch.column.Time.prototype.renderTpl.replace('column-header-inner', 'column-header-inner sch-timeheader {headerCls}');
});


/*
 * @class Sch.column.timeAxis.Horizontal
 * @extends Ext.grid.column.Column
 * @private
 *
 * A visual representation of the time axis. This class can represent up to three different axes, that are defined in the
 * view preset config object.
 */
Ext.define("Sch.column.timeAxis.Horizontal", {
    extend      : "Ext.grid.column.Column",
    alias       : 'widget.timeaxiscolumn',

    requires    : [
        'Ext.Date',
        'Ext.XTemplate',
        'Sch.column.Time',
        'Sch.preset.Manager'
    ],


    cls         : 'sch-timeaxiscolumn',

    timeAxis                : null,

    renderTpl : 
        '<div id="{id}-titleEl" class="' + Ext.baseCSSPrefix + 'column-header-inner">' +
            '<span id="{id}-textEl" style="display:none" class="' + Ext.baseCSSPrefix + 'column-header-text"></span>' +
            '<tpl if="topHeaderCells">' +
                '{topHeaderCells}' +
            '</tpl>' +
            '<tpl if="middleHeaderCells">' +
                '{middleHeaderCells}' +
            '</tpl>' +
        '</div>' +
        '{%this.renderContainer(out,values)%}',
        
    headerRowTpl    :
        '<table border="0" cellspacing="0" cellpadding="0" style="{tstyle}" class="sch-header-row sch-header-row-{position}">' +
            '<thead>' +
                '<tr>{cells}</tr>' +
            '</thead>' +
        '</table>',

    headerCellTpl   :
        '<tpl for=".">' +
            '<td class="sch-column-header x-column-header {headerCls}" style="position : static; text-align: {align}; {style}" tabIndex="0" id="{headerId}" ' +
                'headerPosition="{position}" headerIndex="{index}">' +
                    '<div class="x-column-header-inner">{header}</div>' +
            '</td>' +
        '</tpl>',

    columnConfig            : {},

    timeCellRenderer        : null,
    timeCellRendererScope   : null,

    // cache for single column width value
    columnWidth             : null,
    
    // own width / height value
    previousWidth           : null,
    previousHeight          : null,


    initComponent : function() {
        if (!(this.headerRowTpl instanceof Ext.Template)) {
            this.headerRowTpl = Ext.create("Ext.XTemplate", this.headerRowTpl);
        }

        if (!(this.headerCellTpl instanceof Ext.Template)) {
            this.headerCellTpl = Ext.create("Ext.XTemplate", this.headerCellTpl);
        }

        // to turn this column into group (the actual sub-columns will be added in the `onTimeAxisReconfigure`
        // which seems requires initialized "items"
        this.columns    = [{}];

        this.addEvents('timeheaderdblclick', 'timeaxiscolumnreconfigured');
        this.enableBubble('timeheaderdblclick');

        this.stubForResizer = new Ext.Component({
            isOnLeftEdge        : function () {
                return false;
            },

            isOnRightEdge       : function () {
                return false;
            },

            el                  : {
                dom     : {
                    style   : {}
                }
            }
        });
        
        this.callParent(arguments);

        this.onTimeAxisReconfigure();

        this.mon(this.timeAxis, 'reconfigure', this.onTimeAxisReconfigure, this);
    },


    getSchedulingView : function () {
        return this.getOwnerHeaderCt().view;
    },


    onTimeAxisReconfigure : function () {
        var timeAxis                    = this.timeAxis,
            proposedTimeColumnWidth     = timeAxis.preset.timeColumnWidth,
            schedulingView              = this.rendered && this.getSchedulingView(),
            headerConfig    = timeAxis.headerConfig,
            start           = timeAxis.getStart(),
            end             = timeAxis.getEnd(),
            columnDefaults  = {
                renderer    : this.timeColumnRenderer,
                scope       : this,
                width       : this.rendered ? schedulingView.calculateTimeColumnWidth(proposedTimeColumnWidth) : proposedTimeColumnWidth
            };

        // clear the previous values to bypass the guard in the "afterLayout"
        delete this.previousWidth;
        delete this.previousHeight;
            
        var columnConfig    = this.columnConfig = this.createColumns(this.timeAxis, headerConfig, columnDefaults);

        Ext.suspendLayouts();

        this.removeAll();

        if (this.rendered) {
            var innerCt     = this.el.child('.x-column-header-inner');

            innerCt.select('table').remove();

            var renderData  = this.initRenderData();

            if (columnConfig.top) {
                Ext.core.DomHelper.append(innerCt, renderData.topHeaderCells);
            }

            if (columnConfig.middle) {
                Ext.core.DomHelper.append(innerCt, renderData.middleHeaderCells);
            }

            if (!columnConfig.top && !columnConfig.middle) {
                this.addCls('sch-header-single-row');
            } else {
                this.removeCls('sch-header-single-row');
            }
        }

        Ext.resumeLayouts();

//        // need to calculate the own total width myself - starting as of 4.0.6
//        var width   = 0;
//
//        Ext.each(columnConfig.bottom, function (column) { width += column.width; });
//
//        this.width  = width;

        // this call will reset the "suspendLayout" to false and will trigger a "doLayout" at the end,
        // so generally the following call is not required
        this.add(columnConfig.bottom);
        
        if (this.rendered) {
            if (this.fireEvent('timeaxiscolumnreconfigured', this) !== false) {
                schedulingView.refresh();
            }
        }
    },


    beforeRender : function () {
        var columnConfig        = this.columnConfig;

        if (!columnConfig.middle && !columnConfig.top) {
            this.addCls('sch-header-single-row');
        }

        this.callParent(arguments);
    },


    // private
    timeColumnRenderer: function (v, m, rec, row, col, ds, events) {
        var retVal = '';

        // Thanks Condor for this fix!
        if (Ext.isIE) {
            m.style += ';z-index:' + (this.items.getCount() - col);
        }

        if (this.timeCellRenderer) {
            var ta          = this.timeAxis,
                colTick     = ta.getAt(col),
                colStart    = colTick.start,
                colEnd      = colTick.end;
            
            retVal  = this.timeCellRenderer.call(this.timeCellRendererScope || this, m, rec, row, col, ds, colStart, colEnd);
        }

        return retVal;
    },


    initRenderData : function () {
        var columnConfig        = this.columnConfig;

        var topHeaderCells      = columnConfig.top ? this.headerRowTpl.apply({
            cells           : this.headerCellTpl.apply(columnConfig.top),
            position        : 'top',
            // for webkit, table need to have the width defined upfront,
            // for the "table-layout : fixed" style to have any effect
            // so we set it to 100px in all cases
            // we'll overwrite it with correct value in the `refreshHeaderRow` anyway
            tstyle          : 'border-top : 0; width : 100px'
        }) : '';

        var middleHeaderCells   = columnConfig.middle ? this.headerRowTpl.apply({
            cells           : this.headerCellTpl.apply(columnConfig.middle),
            position        : 'middle',
            tstyle          : columnConfig.top ? 'width : 100px' : 'border-top : 0; width : 100px'
        }) : '';

        return Ext.apply(this.callParent(arguments), {
            topHeaderCells      : topHeaderCells,
            middleHeaderCells   : middleHeaderCells
        });
    },


    // Default renderer method if no renderer is supplied in the header config
    defaultRenderer : function(start, end, dateFormat) {
        return Ext.Date.format(start, dateFormat);
    },


    // Method generating the column config array for the time columns
    createColumns : function (timeAxis, headerConfig, defaults) {
        if (!timeAxis || !headerConfig) {
            throw 'Invalid parameters passed to createColumns';
        }

        var columns         = [],
            lowestHeader    = headerConfig.bottom || headerConfig.middle,
            ticks           = timeAxis.getTicks(),
            colConfig;

        for (var i = 0, l = ticks.length; i < l; i++) {
            colConfig = {
                align       : lowestHeader.align || 'center',
                headerCls   : '',

                startDate   : ticks[i].start,
                endDate     : ticks[i].end
            };

            if (lowestHeader.renderer) {
                colConfig.header = lowestHeader.renderer.call(lowestHeader.scope || this, ticks[i].start, ticks[i].end, colConfig, i);
            } else {
                colConfig.header = this.defaultRenderer(ticks[i].start, ticks[i].end, lowestHeader.dateFormat);
            }

            columns[ columns.length ] = Ext.create("Sch.column.Time", Ext.apply(colConfig, defaults));
        }

        var headerRows = this.createHeaderRows(timeAxis, headerConfig);

        return {
            bottom          : columns,
            middle          : headerRows.middle,
            top             : headerRows.top
        };
    },

    /*
     * Method generating the config array for any additional header rows
     * @private
     * @param {Sch.data.TimeAxis} timeAxis The time axis used by the scheduler
     * @param {Object} headerConfig The current scheduler header config object
     * @return {Object} the extra header rows
     */
    createHeaderRows : function (timeAxis, headerConfig) {
        var rows = {};

        if (headerConfig.top) {
            var topRow;
            if (headerConfig.top.cellGenerator) {
                topRow = headerConfig.top.cellGenerator.call(this, timeAxis.getStart(), timeAxis.getEnd());
            } else {
                topRow = this.createHeaderRow(timeAxis, headerConfig.top);
            }
            rows.top = this.processHeaderRow(topRow, 'top');
        }

        if (headerConfig.bottom) {
            var middleRow;
            if (headerConfig.middle.cellGenerator) {
                middleRow = headerConfig.middle.cellGenerator.call(this, timeAxis.getStart(), timeAxis.getEnd());
            } else {
                middleRow = this.createHeaderRow(timeAxis, headerConfig.middle);
            }
            rows.middle = this.processHeaderRow(middleRow, 'middle');
        }

        return rows;
    },


    processHeaderRow : function (rowCells, position) {
        var me      = this;

        Ext.each(rowCells, function (rowCell, index) {

            rowCell.index       = index;
            rowCell.position    = position;
            // this additional config will allow the top level headers act "on behalf" of the whole column
            // see "Ext.grid.plugin.HeaderResizer#onHeaderCtMouseMove"
            rowCell.headerId    = me.stubForResizer.id;
        });

        return rowCells;
    },


    // private
    createHeaderRow: function(timeAxis, headerConfig) {
        var cells           = [],
            colConfig,
            start           = timeAxis.getStart(),
            end             = timeAxis.getEnd(),
            totalDuration   = end - start,
            cols            = [],
            dt              = start,
            i               = 0,
            cfg,
            align           = headerConfig.align || 'center',
            intervalEnd;

        while (dt < end) {
            intervalEnd =  Sch.util.Date.min(timeAxis.getNext(dt, headerConfig.unit, headerConfig.increment || 1), end);

            colConfig = {
                align       : align,
                start       : dt,
                end         : intervalEnd,
                headerCls   : ''
            };

            if (headerConfig.renderer) {
                colConfig.header = headerConfig.renderer.call(headerConfig.scope || this, dt, intervalEnd, colConfig, i);
            } else {
                colConfig.header = this.defaultRenderer(dt, intervalEnd, headerConfig.dateFormat, colConfig, i);
            }

            cells.push(colConfig);
            dt = intervalEnd;
            i++;
        }

        return cells;
    },


    afterLayout: function () {
        // clear the cached value
        delete this.columnWidth;
        
        this.callParent(arguments);
        
        var width       = this.getWidth();
        var height      = this.getHeight();
        
        if (width === this.previousWidth && height === this.previousHeight) { return; }
        
        this.previousWidth    = width;
        this.previousHeight   = height;
        

        var columnConfig    = this.columnConfig;
        var me              = this;
        var thisEl          = this.el;

        var top             = columnConfig.top;

        var sumTop          = 0;
        var sumMiddle       = 0;

        if (top) {
            thisEl.select('.sch-header-row-top').setWidth(this.lastBox.width);

            thisEl.select('.sch-header-row-top td').each(function (el, composite, index) {
                var width   = me.getHeaderGroupCellWidth(top[ index ].start, top[ index ].end);

                el.setVisibilityMode(Ext.Element.DISPLAY);

                if (width) {
                    sumTop += width;

                    el.show();
                    el.setWidth(width);
                } else {
                    el.hide();
                }
            });
        }

        var middle             = columnConfig.middle;

        if (middle) {
            thisEl.select('.sch-header-row-middle').setWidth(this.lastBox.width);

            thisEl.select('.sch-header-row-middle td').each(function (el, composite, index) {
                var width   = me.getHeaderGroupCellWidth(middle[ index ].start, middle[ index ].end);

                el.setVisibilityMode(Ext.Element.DISPLAY);

                if (width) {
                    sumMiddle += width;

                    el.show();
                    el.setWidth(width);
                } else {
                    el.hide();
                }
            });
        }
        
//        TODO remove after headers are felt stable
//        var totalWidth          = sumTop || sumMiddle;
//        var schedulingView      = this.getSchedulingView();
//        
//        if (totalWidth) {
//            thisEl.setWidth(totalWidth);
//            
//            // FIX for /tests/headers/110_timeheader.t.js
//            var totalWithRight  = totalWidth + schedulingView.getRightColumnsWidth();
//            
//            if (this.__overwriteTimeout) { clearTimeout(this.__overwriteTimeout); }
//            
//            this.__overwriteTimeout = setTimeout(function () {
//                // orientation may change (like in test)
//                if (schedulingView.orientation != 'horizontal') { return; }
//                
//                var downBox     = thisEl.down('.x-box-inner');
//                
//                thisEl.up('.x-box-inner').setWidth(totalWithRight + 30);    
//                downBox.setWidth(totalWidth + 30);
//                
//                if (schedulingView.hasRightColumns()) {
//                    schedulingView.fixRightColumnsPositions();
//                }
//            }, 0);
//            // EOF FIX
//            
//            thisEl.select('table').each(function (el) {
//                if (!el.hasCls('sch-nested-hdr-tbl')) {
//                    el.setWidth(totalWidth);
//                }
//            });
//        } else {
//            if (this.__overwriteTimeout) { clearTimeout(this.__overwriteTimeout); }
//            
//            this.__overwriteTimeout = setTimeout(function () {
//                // orientation may change (like in test)
//                if (schedulingView.orientation != 'horizontal') { return; }
//                
//                var downBox     = thisEl.down('.x-box-inner');
//                
//                thisEl.setWidth('auto');
//    
//                thisEl.select('table').each(function (el) {
//                    if (!el.hasCls('sch-nested-hdr-tbl')) {
//                        el.setWidth('auto');
//                    }
//                });
//                
//                var deFactoTotalWidth   = thisEl.down('.x-column-header-first').getWidth() * me.items.getCount();
//                
//                thisEl.up('.x-box-inner').setWidth(deFactoTotalWidth + schedulingView.getRightColumnsWidth() + 30);    
//                downBox.setWidth(deFactoTotalWidth + 30);
//            });
//        }
    },


    getHeaderGroupCellWidth : function(start, end/*, headerRowUnit, headerRowIncrement*/) {
        var baseUnit                    = this.timeAxis.unit,
            baseIncrement               = this.timeAxis.increment,
            width,
            measuringUnit               = Sch.util.Date.getMeasuringUnit(baseUnit),
            durationInMeasuringUnit     = Sch.util.Date.getDurationInUnit(start, end, measuringUnit),
            schedulingView              = this.getSchedulingView();

        if (this.timeAxis.isContinuous()) {
            width = durationInMeasuringUnit * schedulingView.getSingleUnitInPixels(measuringUnit) / baseIncrement;
        } else {
            width = schedulingView.getXYFromDate(end)[ 0 ] - schedulingView.getXYFromDate(start)[ 0 ];
        }
        
        return width;
    },


    onElDblClick: function (event, target) {
        this.callParent(arguments);

        var headerCell  = event.getTarget('.sch-column-header');

        if (headerCell) {
            var position    = Ext.fly(headerCell).getAttribute('headerPosition'),
                index       = Ext.fly(headerCell).getAttribute('headerIndex'),
                headerConfig  = this.columnConfig[ position ][ index ];

            this.fireEvent('timeheaderdblclick', this, headerConfig.start, headerConfig.end, event);
        }
    },


    getTimeColumnWidth : function () {
        if (this.columnWidth === null) {
            this.columnWidth = this.items.get(0).getWidth();
        }

        return this.columnWidth;
    },


    setTimeColumnWidth : function (width) {
//        console.time('setTimeColumnWidth')
        
        //this.suspendLayouts();
        this.suspendEvents();
        
        this.items.each(function (column) {
            column.setWidth(width);
        });
        
//        this.updateLayout();
//
        this.resumeEvents();
//        Ext.resumeLayouts(true);
        
//        this.updateLayout();
        
//        console.timeEnd('setTimeColumnWidth')
    }
});


/*
 * @class Sch.column.timeAxis.HorizontalSingle
 * @extends Ext.grid.column.Column
 * @private
 *
 * A "lightweight" visual representation of the time axis. This class does not produce any real Ext grid columns, instead it just renders the timeaxis as its HTML content.
 * This class can represent up to three different axes, that are defined in the
 * view preset config object. 
 */
Ext.define("Sch.column.timeAxis.HorizontalSingle", {
    extend      : "Sch.column.Time",
    alias       : 'widget.singletimeaxiscolumn',

    requires    : [
        'Ext.Date',
        'Ext.XTemplate',
        'Sch.preset.Manager'
    ],

    cls : 'sch-simple-timeaxis',

    timeAxis                : null,

    /**
     * @cfg {Boolean} trackHeaderOver `true` to highlight each header cell when the mouse is moved over it. 
     */
    trackHeaderOver         : true,

    /**
     * @cfg {Int} compactCellWidthThreshold The minimum width for a bottom row header cell to be considered 'compact', which adds a special CSS class to the row. 
     *            Defaults to 15px.
     */
    compactCellWidthThreshold : 15,

    renderTpl : 
        '<div id="{id}-titleEl" class="' + Ext.baseCSSPrefix + 'column-header-inner">' +
            '<span id="{id}-textEl" style="display:none" class="' + Ext.baseCSSPrefix + 'column-header-text"></span>' +
            '<tpl if="topHeaderCells">' +
                '{topHeaderCells}' +
            '</tpl>' +
            '<tpl if="middleHeaderCells">' +
                '{middleHeaderCells}' +
            '</tpl>' +
            '<tpl if="bottomHeaderCells">' +
                '{bottomHeaderCells}' +
            '</tpl>' +
        '</div>' +
        '{%this.renderContainer(out,values)%}',
        
    headerRowTpl    :
        '<table border="0" cellspacing="0" cellpadding="0" style="{tstyle}" class="sch-header-row sch-header-row-{position}">' +
            '<thead>' +
                '<tr>' + 
                    '<tpl for="cells">' + 
                        '<td class="sch-column-header x-column-header {headerCls}" style="position : static; text-align: {align}; {style}" tabIndex="0" id="{headerId}" ' +
                            'headerPosition="{parent.position}" headerIndex="{[xindex-1]}">' +
                                '<div class="sch-simple-timeheader">{header}</div>' +
                        '</td>' + 
                    '</tpl>' + 
                '</tr>' +
            '</thead>' +
        '</table>',

    columnConfig            : {},

    // cache for single column width value
    columnWidth             : null,
    nbrTimeColumns          : null,
    
    initComponent : function() {
        this.tdCls += ' sch-singletimetd';
        
        if (!(this.headerRowTpl instanceof Ext.Template)) {
            this.headerRowTpl = Ext.create("Ext.XTemplate", this.headerRowTpl);
        }

        this.addEvents('timeheaderdblclick', 'timeaxiscolumnreconfigured');
        this.enableBubble('timeheaderdblclick');

        this.callParent(arguments);

        this.onTimeAxisReconfigure();

        this.mon(this.timeAxis, 'reconfigure', this.onTimeAxisReconfigure, this);
        this.on('resize', this.refreshHeaderSizes, this);

        // Keep this and use for our own TDs hover functionality.
        this.ownHoverCls = this.hoverCls;

        // Do not want the default hover cls to be added to container column TD.
        this.hoverCls = '';
    },


    getSchedulingView : function () {
        return this.getOwnerHeaderCt().view;
    },


    onTimeAxisReconfigure : function () {
        
        var timeAxis                    = this.timeAxis,
            proposedTimeColumnWidth     = timeAxis.preset.timeColumnWidth,
            schedulingView              = this.rendered && this.getSchedulingView(),
            headerConfig    = timeAxis.headerConfig,
            start           = timeAxis.getStart(),
            end             = timeAxis.getEnd(),
            width           = this.rendered ? schedulingView.calculateTimeColumnWidth(proposedTimeColumnWidth) : proposedTimeColumnWidth;
            
        var columnConfig    = this.columnConfig = this.createHeaderRows(this.timeAxis, headerConfig);
        
        var lowestRow = columnConfig.bottom || columnConfig.middle;

        if (this.rendered) {
            var rowEl;
            var innerCt = this.el.child('.x-column-header-inner');
            var ctDom = innerCt.dom;
            var oldDisplay = ctDom.style.display;
            var parent = ctDom.parentNode;
            ctDom.style.display = 'none';
            parent.removeChild(ctDom);
            
            ctDom.innerHTML = '';

            var renderData  = this.initRenderData();

            if (columnConfig.top) {
                rowEl = Ext.core.DomHelper.append(innerCt, renderData.topHeaderCells);
                this.refreshHeaderRow("top", rowEl);
            }

            if (columnConfig.middle) {
                rowEl = Ext.core.DomHelper.append(innerCt, renderData.middleHeaderCells);
                this.refreshHeaderRow("middle", rowEl);
            }
            
            if (columnConfig.bottom) {
                rowEl = Ext.core.DomHelper.append(innerCt, renderData.bottomHeaderCells);
                this.refreshHeaderRow("bottom", rowEl);
            }

            if (!columnConfig.top && !columnConfig.middle) {
                this.addCls('sch-header-single-row');
            } else {
                this.removeCls('sch-header-single-row');
            }
            

            parent.appendChild(ctDom);
            ctDom.style.display = oldDisplay;
            
            if (width !== this.columnWidth || this.nbrTimeColumns !== lowestRow.length) {
                this.nbrTimeColumns = lowestRow.length;
                this.setTimeColumnWidth(width);
            }

            if (this.fireEvent('timeaxiscolumnreconfigured', this) !== false) {
                schedulingView.lightRefresh();
            }
        } else {
        
            if (width !== this.columnWidth || this.nbrTimeColumns !== lowestRow.length) {
                this.nbrTimeColumns = lowestRow.length;
                this.setTimeColumnWidth(width);
            }
        }
    },


    beforeRender : function () {
        var me              = this,
            columnConfig    = this.columnConfig;

        if (!columnConfig.middle && !columnConfig.top) {
            me.addCls('sch-header-single-row');
        }
        me.callParent(arguments);
    },

    afterRender : function() {
        var me = this;

        if (this.trackHeaderOver) {
            me.el.on({
                mousemove   : me.highlightCell,
                delegate    : 'div.sch-simple-timeheader',
                scope       : me
            });

            me.el.on({
                mouseleave: me.clearHighlight,
                scope:      me
            });
        }

        me.callParent(arguments);
    },

    initRenderData : function () {
        var columnConfig        = this.columnConfig;

        var topHeaderCells      = columnConfig.top ? this.headerRowTpl.apply({
            cells           : columnConfig.top,
            position        : 'top',
            // for webkit, table need to have the width defined upfront,
            // for the "table-layout : fixed" style to have any effect
            // so we set it to 100px in all cases
            // we'll overwrite it with correct value in the `refreshHeaderRow` anyway
            tstyle          : 'border-top : 0; width : 100px'
        }) : '';

        var middleHeaderCells   = columnConfig.middle ? this.headerRowTpl.apply({
            cells           : columnConfig.middle,
            position        : 'middle',
            tstyle          : columnConfig.top ? 'width : 100px' : 'border-top : 0; width : 100px'
        }) : '';

        var bottomHeaderCells   = columnConfig.bottom ? this.headerRowTpl.apply({
            cells           : columnConfig.bottom,
            position        : 'bottom',
            tstyle          : 'width : 100px'
        }) : '';

        return Ext.apply(this.callParent(arguments), {
            topHeaderCells      : topHeaderCells,
            middleHeaderCells   : middleHeaderCells,
            bottomHeaderCells   : bottomHeaderCells
        });
    },

    // Default renderer method if no renderer is supplied in the header config
    defaultRenderer : function(start, end, dateFormat) {
        return Ext.Date.format(start, dateFormat);
    },

    /*
     * Method generating the config array for any additional header rows
     * @private
     * @param {Sch.data.TimeAxis} timeAxis The time axis used by the scheduler
     * @param {Object} headerConfig The current scheduler header config object
     * @return {Object} the extra header rows
     */
    createHeaderRows : function (timeAxis, headerConfig) {
        var rows = {};
        var row;

        if (headerConfig.top) {
            if (headerConfig.top.cellGenerator) {
                row = headerConfig.top.cellGenerator.call(this, timeAxis.getStart(), timeAxis.getEnd());
            } else {
                row = this.createHeaderRow(timeAxis, headerConfig.top);
            }
            rows.top = row;
        }

        if (headerConfig.middle) {
            if (headerConfig.middle.cellGenerator) {
                row = headerConfig.middle.cellGenerator.call(this, timeAxis.getStart(), timeAxis.getEnd());
            } else {
                row = headerConfig.bottom ? this.createHeaderRow(timeAxis, headerConfig.middle) : 
                                            this.createLowestHeaderRow(timeAxis, headerConfig.middle);
            }
            rows.middle = row;
        }

        if (headerConfig.bottom) {
            if (headerConfig.bottom.cellGenerator) {
                row = headerConfig.bottom.cellGenerator.call(this, timeAxis.getStart(), timeAxis.getEnd());
            } else {
                row = this.createLowestHeaderRow(timeAxis, headerConfig.bottom);
            }
            rows.bottom = row;
        }

        return rows;
    },

    // private
    createHeaderRow: function(timeAxis, headerConfig) {
        var cells           = [],
            colConfig,
            start           = timeAxis.getStart(),
            end             = timeAxis.getEnd(),
            totalDuration   = end - start,
            cols            = [],
            dt              = start,
            i               = 0,
            cfg,
            align           = headerConfig.align || 'center',
            intervalEnd;

        while (dt < end) {
            intervalEnd =  Sch.util.Date.min(timeAxis.getNext(dt, headerConfig.unit, headerConfig.increment || 1), end);

            colConfig = {
                align       : align,
                start       : dt,
                end         : intervalEnd,
                headerCls   : ''
            };

            if (headerConfig.renderer) {
                colConfig.header = headerConfig.renderer.call(headerConfig.scope || this, dt, intervalEnd, colConfig, i);
            } else {
                colConfig.header = this.defaultRenderer(dt, intervalEnd, headerConfig.dateFormat, colConfig, i);
            }

            if (headerConfig.unit === Sch.util.Date.DAY && (!headerConfig.increment || headerConfig.increment === 1)) {
                colConfig.headerCls += ' sch-dayheadercell-' + dt.getDay();
            }

            cells.push(colConfig);
            dt = intervalEnd;
            i++;
        }

        return cells;
    },

    // private
    createLowestHeaderRow: function(timeAxis, headerConfig) {
        var cells           = [],
            colConfig,
            cols            = [],
            i               = 0,
            cfg,
            align           = headerConfig.align || 'center',
            intervalEnd;

        Ext.each(timeAxis.getTicks(), function(tick, i) {
            colConfig = {
                align       : align,
                start       : tick.start,
                end         : tick.end,
                headerCls   : ''
            };

            if (headerConfig.renderer) {
                colConfig.header = headerConfig.renderer.call(headerConfig.scope || this, tick.start, tick.end, colConfig, i);
            } else {
                colConfig.header = this.defaultRenderer(tick.start, tick.end, headerConfig.dateFormat, colConfig, i);
            }

            if (headerConfig.unit === Sch.util.Date.DAY && (!headerConfig.increment || headerConfig.increment === 1)) {
                colConfig.headerCls += ' sch-dayheadercell-' + tick.start.getDay();
            }

            cells.push(colConfig);
        }, this);

        return cells;
    },

    afterLayout: function () {
        this.callParent(arguments);
        this.refreshHeaderSizes();
    },

    refreshHeaderSizes : function() {
        var columnConfig    = this.columnConfig;
        
        if (columnConfig.top) {
            this.refreshHeaderRow('top');
        }

        if (columnConfig.middle) {
            this.refreshHeaderRow('middle');
        }

        if (columnConfig.bottom) {
            this.refreshHeaderRow('bottom');
        }
    },

    refreshHeaderRow : function(position, rowEl) {
        var thisEl  = this.el;
        var rowData = this.columnConfig[position];
        var me      = this;
        var width;
         
        if (rowEl) {
            Ext.fly(rowEl).setWidth(me.getTotalWidth());

            Ext.fly(rowEl).select('> td').each(function (el, composite, index) {
                width   = me.getHeaderGroupCellWidth(rowData[ index ].start, rowData[ index ].end);
            
                el.setVisibilityMode(Ext.Element.DISPLAY);

                if (width) {
                    el.show();
                    // weird bug in Webkit - seems to be related to the `box-sizing` style
                    // in combination with table cells - only first cell will honor it
                    // for other cells need to reduce the width by 1px
                    el.setWidth(width - (Ext.isWebKit ? (index ? 1 : 0) : 0 ));
                } else {
                    el.hide();
                }
            });
        } else {
            rowEl = thisEl.down('.sch-header-row-' + position);
            rowEl.setWidth(me.getTotalWidth());
            
            rowEl.select(' thead > tr > td').each(function (el, composite, index) {
                width   = me.getHeaderGroupCellWidth(rowData[ index ].start, rowData[ index ].end);
                
                el.setVisibilityMode(Ext.Element.DISPLAY);

                if (width) {
                    el.show();
                    el.setWidth(width - (Ext.isWebKit ? (index ? 1 : 0) : 0 ));
                } else {
                    el.hide();
                }
            });
        }

        if (position === 'bottom') {
            if (width < this.compactCellWidthThreshold) {
                Ext.fly(rowEl).addCls('sch-header-row-compact');
            } else {
                Ext.fly(rowEl).removeCls('sch-header-row-compact');
            }
        }
    },

    getHeaderGroupCellWidth : function(start, end) {
        var baseUnit                    = this.timeAxis.unit,
            baseIncrement               = this.timeAxis.increment,
            width,
            measuringUnit               = Sch.util.Date.getMeasuringUnit(baseUnit),
            durationInMeasuringUnit     = Sch.util.Date.getDurationInUnit(start, end, measuringUnit),
            schedulingView              = this.getSchedulingView();
        
        if (this.timeAxis.isContinuous()) {
            width = durationInMeasuringUnit * schedulingView.getSingleUnitInPixels(measuringUnit) / baseIncrement;
        } else {
            width = schedulingView.getXYFromDate(end)[ 0 ] - schedulingView.getXYFromDate(start)[ 0 ];
        }
        
        return width;
    },


    onElDblClick: function (event, target) {
        var headerCell  = event.getTarget('.sch-column-header');

        if (headerCell) {
            var position    = Ext.fly(headerCell).getAttribute('headerPosition'),
                index       = Ext.fly(headerCell).getAttribute('headerIndex'),
                headerConfig  = this.columnConfig[ position ][ index ];
           
            this.fireEvent('timeheaderdblclick', this, headerConfig.start, headerConfig.end, event);
        }
    },


    getTimeColumnWidth : function () {
        if (this.columnWidth === null) {
            this.columnWidth = this.getWidth() / this.nbrTimeColumns;
        }

        return this.columnWidth;
    },


    setTimeColumnWidth : function (width) {
        //console.time('setTimeColumnWidth');
        this.columnWidth = width;
        if (this.rendered) {
            Ext.suspendLayouts();
            // Very expensive call
            this.setWidth(width * this.nbrTimeColumns);
            Ext.resumeLayouts();
            this.refreshHeaderSizes();
            this.ownerCt.updateLayout();
        } else {
            this.setWidth(width * this.nbrTimeColumns);
        }
        //console.timeEnd('setTimeColumnWidth');
    },

    getTotalWidth : function() {
        return this.columnWidth * this.nbrTimeColumns;
    },

    highlightCell: function(e, cell) {
        var me = this;
        
        if (cell !== me.highlightedCell) {
            me.clearHighlight();
            me.highlightedCell = cell;
            Ext.fly(cell).addCls(me.ownHoverCls);
        }
    },

    clearHighlight: function() {
        var me = this,
            highlighted = me.highlightedCell;

        if (highlighted) {
            Ext.fly(highlighted).removeCls(me.ownHoverCls);
            delete me.highlightedCell;
        }
    }
});



// Private
Ext.define('Sch.mixin.Lockable', {
    extend: 'Ext.grid.Lockable',

    requires: [
        'Sch.column.timeAxis.Horizontal',
        'Sch.column.timeAxis.HorizontalSingle'
    ],

    findEditingPlugin : function() {
        var plugins = this.plugins;
        var me = this;
        var editing;
        
        Ext.each(plugins, function(p, index) {
            if (Ext.grid.plugin && Ext.grid.plugin.CellEditing && p instanceof Ext.grid.plugin.CellEditing) {
                editing = p;
                Ext.Array.remove(plugins, p);
                return false;
            }
        });
        return editing;
    },

    // overridden
    injectLockable: function () {
        
        // Editing feature of 4.1.0 is not compatible with locking grid, manually move it to locked grid
        var editPlugin  = this.findEditingPlugin();

        var me          = this;
        var isTree      = me.store instanceof Ext.data.TreeStore;
        var isBuffered  = me.store.buffered;

        var eventSelModel = me.getEventSelectionModel ? me.getEventSelectionModel() : me.getSelectionModel();
        
        me.lockedGridConfig = me.lockedGridConfig || {};
        me.normalGridConfig = me.schedulerConfig || me.normalGridConfig || {};

        var lockedGrid = me.lockedGridConfig,
            normalGrid = me.normalGridConfig;
            
        Ext.applyIf(me.lockedGridConfig, {
            enableLocking: false,
            lockable: false,
            useArrows: true,
            xtype: me.lockedXType,
            columnLines: me.columnLines,
            rowLines: me.rowLines,
            
            // Some nice border layout defaults
            split: true,
            animCollapse : false,
            collapseDirection : 'left',
            region : 'west'
        });

        if (editPlugin) {
            me.lockedGridConfig.plugins = (me.lockedGridConfig.plugins || []).concat(editPlugin);
        }

        Ext.applyIf(me.normalGridConfig, {
            layout : 'fit',
            xtype: me.normalXType,
            viewType : me.viewType,
            enableLocking: false,
            lockable: false,
            sortableColumns: false,
            enableColumnMove: false,
            enableColumnResize: false,
            enableColumnHide: false,
            selModel: eventSelModel,
            _top: me,
            orientation: me.orientation,
            viewPreset: me.viewPreset,
            timeAxis: me.timeAxis,
            columnLines: me.columnLines,
            rowLines: me.rowLines,
            
            // Some nice border layout defaults
            collapseDirection : 'right',
            animCollapse : false,
            region : 'center'
        });

        // For locked tree support
        me.bothCfgCopy = me.bothCfgCopy || 
                        (Ext.grid.Panel && Ext.grid.Panel.prototype.bothCfgCopy) || 
                        [ 'invalidateScrollerOnRefresh', 
                          'hideHeaders', 
                          'enableColumnHide', 
                          'enableColumnMove', 
                          'enableColumnResize',
                          'sortableColumns'
                        ];

        if (me.orientation === 'vertical') {
            lockedGrid.store = normalGrid.store = me.timeAxis.tickStore;

            me.resourceStore.on({
                clear: me.refreshResourceColumns,
                datachanged: me.refreshResourceColumns,
                load: me.refreshResourceColumns,
                scope: me
            });
        }

        if (lockedGrid.width) {
            // User has specified a fixed width for the locked section, disable the syncLockedWidth method 
            me.syncLockedWidth = Ext.emptyFn;
            // Enable scrollbars for locked section
            lockedGrid.scroll = 'horizontal';
            lockedGrid.scrollerOwner = true;
        }

        if (me.resourceStore) {
            normalGrid.resourceStore = me.resourceStore;
        }

        if (me.eventStore) {
            normalGrid.eventStore = me.eventStore;
        }

        if (me.dependencyStore) {
            normalGrid.dependencyStore = me.dependencyStore;
        }

        me.lockedViewConfig         = me.lockedViewConfig || {};
        me.normalViewConfig         = me.normalViewConfig || {};
        
        me.lockedViewConfig.enableAnimations = me.normalViewConfig.enableAnimations = false;
        
        if (isTree) {
            // re-use the same NodeStore for both grids (construction of NodeStore is an expensive operation, shouldn't just unbind the extra one)
            me.normalViewConfig.providedStore = me.lockedViewConfig.providedStore = me.createNodeStore(isBuffered, me.store);
        }

                
        // Grids instantiation

        // EOF Grids instantiation
        var origLayout = me.layout;

        this.callParent(arguments);
        
        // At this point, the 2 child grids are created
        
        // Now post processing, changing and overriding some things that Ext.grid.Lockable sets up
        if (lockedGrid.width) {
            me.lockedGrid.setWidth(lockedGrid.width);
        } else if (me.normalGrid.collapsed) {
            // Need to workaround this, child grids cannot be collapsed initially
            me.normalGrid.collapsed = false;
            me.normalGrid.on('render', function(){
                me.normalGrid.collapse();
            }, me, { delay : 0 });
        }

        var lockedView = me.lockedGrid.getView();
        var normalView = me.normalGrid.getView();

        // Try to prevent 2 unnecessary DOM updates
        lockedView.on('beforerefresh', function () { return normalView.store.getCount() > 0; }, null, { single: true });
        normalView.on('beforerefresh', function () { return normalView.store.getCount() > 0; }, null, { single: true });

        // Buffered support for locked grid
        if (isBuffered) {
            lockedView.on('render', this.onLockedViewRender, this);
            
            this.fixPagingScroller(me.normalGrid.verticalScroller);
        }
        
        if (isTree) {
            this.setupLockableTree();
        }
        
        
        if (isBuffered) {
            // dummy object to make the "normalView.el.un()" call to work in the "bindView" below
            normalView.el = { un : function () {} };

            // re-bind the view of the scroller
            // this will:
            // 1) update the `store` of the scroller from TreeStore instance to NodeStore
            // 2) will update the listener of `guaranteedrange` event
            //    so it will use the override for `onGuaranteedRange` from `setupLockableTree`
            // 3) will update the listener of `refresh` to use the override from `fixPagingScroller`
            me.normalGrid.verticalScroller.bindView(normalView);
            
            delete normalView.el;
        }
        

        me.view.clearListeners();
        
        lockedView.on({
            itemadd: me.onViewItemAdd,
            refresh: me.updateSpacer,
            scope: me
        });

        // Create new view
        me.view = Ext.create('Sch.view.Locking', {
            locked: me.lockedGrid,
            normal: me.normalGrid,
            panel: me
        });

        if (me.syncRowHeight) {
            lockedView.on('refresh', this.onLockedViewRefresh, this);

            normalView.on({
                itemadd: me.onViewItemAdd,
                itemupdate: me.onNormalViewItemUpdate,
                
                // required for grouping
                groupexpand : me.onNormalViewGroupExpand,
                scope: me
            });

            // PATCH broken implementation broken for IE9
            if (Ext.isIE9 && Ext.isStrict) {
                me.onNormalViewItemUpdate = function (record, index, node) {
                    if (me.lockedGridDependsOnSchedule) {
                        var lockedView = me.lockedGrid.getView();
                        lockedView.suspendEvents();
                        lockedView.onUpdate(me.lockedGrid.store, record);
                        lockedView.resumeEvents();
                    }

                    // HACK: Row height must be synced manually
                    var row = me.normalGrid.getView().getNode(index);
                    row.style.height = node.style.height;
                    me.normalHeights[index] = node.style.height;

                    me.syncRowHeights();
                };
            }
        }

        if (origLayout !== 'fit') {
            me.layout = origLayout;
        }

        me.normalGrid.on({
            beforecollapse : me.onBeforeNormalGridCollapse,
            expand : me.onNormalGridExpand,
            scope :me
        });

        me.lockedGrid.on({
            beforecollapse : me.onBeforeLockedGridCollapse,
            scope :me
        });
        
        if (this.lockedGrid.view.store !== this.normalGrid.view.store) {
            Ext.Error.raise('Sch.mixin.lockable setup failed, not sharing store between the two views');   
        }
    },

    onBeforeLockedGridCollapse : function() {
        if (this.normalGrid.collapsed) {
            this.normalGrid.expand();
        }
    },

    onBeforeNormalGridCollapse : function() {
        var me = this;
        me.lastLockedWidth = me.lockedGrid.getWidth();
        me.lockedGrid.setWidth(me.getWidth() - 35);
                
        if (me.lockedGrid.collapsed) {
            me.lockedGrid.expand();
        }
    },

    onNormalGridExpand : function() {
        this.lockedGrid.setWidth(this.lastLockedWidth);
    },
    
    
    fixPagingScroller : function (scroller) {
        var prevOnViewRefresh   = scroller.onViewRefresh;
        
        scroller.onViewRefresh = function () {
            prevOnViewRefresh.apply(this, arguments);
            
            var me      = this,
                store   = me.store;
    
            if (store.getCount() === store.getTotalCount() || (store.isFiltered() && !store.remoteFilter)) {
                me.stretcher.setHeight(me.getScrollHeight());
            }
        };
    },
    
    
    createNodeStore : function (isBuffered, treeStore) {
        return new Ext.data.NodeStore({
            buffered        : isBuffered,
            
            // never purge any data, we prefetch all up front
            purgePageCount  : 0,
            pageSize        : 1e10,
            
            treeStore       : treeStore,
            recursive       : true,
            
            refreshFromTree : function () {
                var eventsWereSuspended     = this.eventsSuspended;
                
                this.suspendEvents();
                
                this.removeAll();
                
                var root            = treeStore.getRootNode(),
                    linearNodes     = [];
                
                var collectNodes    = function (node) {
                    if (node != root) {
                        linearNodes[ linearNodes.length ] = node;
                    }
                    
                    if (node.isExpanded()) {
                        var childNodes  = node.childNodes,
                            length      = childNodes.length;
                        
                        for (var k = 0; k < length; k++) {
                            collectNodes(childNodes[ k ]);
                        }
                    }
                };
                
                collectNodes(root);
                
                this.totalCount = linearNodes.length;
                
                this.cachePage(linearNodes, 1);
                
                if (!eventsWereSuspended) {
                    this.resumeEvents();
                }
            }
        });
    },
    

    setupLockableTree: function () {
        var oldRootNode;
        var fillingRoot;
        
        var me              = this;
        
        var isBuffered      = me.store.buffered;
        var topView         = me.getView();
        var lockedView      = me.lockedGrid.getView();
        var normalView      = me.normalGrid.getView();
        var normalStore     = normalView.store;
        var treeStore       = me.store;
        
        var verticalScroller        = me.normalGrid.verticalScroller;
        
        // this function is covered with "203_buffered_view_2.t.js" in Gantt
        var guaranteeRange = function (rangeStart, rangeEnd) {
            var pageSize        = treeStore.viewSize || 50;
            var totalCount      = normalStore.getTotalCount();

            if (totalCount) {
                var rangeLength = rangeEnd - rangeStart + 1;

                // if current range is less than a page size but in total we have at least one full page
                if (rangeLength < pageSize && totalCount >= rangeLength) {

                    // then expand the range till the page size
                    rangeEnd = rangeStart + pageSize - 1;
                }

                // if the end of range goes after limit
                if (rangeEnd >= totalCount) {
                    // then adjust it
                    rangeStart  = totalCount - (rangeEnd - rangeStart);
                    rangeEnd    = totalCount - 1;

                    rangeStart  = Math.max(0, rangeStart);
                }

                normalStore.guaranteeRange(rangeStart, rangeEnd);
            }
        };

        treeStore.on('root-fill-start', function () {
            fillingRoot = true;

            normalStore.suspendEvents();

            if (isBuffered) {
                oldRootNode = normalStore.node;

                // setting the root node of NodeStore to null - so we now should update the NodeStore manually for all CRUD operations in tree
                // with `refreshFromTree` call
                normalStore.setNode();
            }
        });

        treeStore.on('root-fill-end', function () {
            fillingRoot = false;

            if (isBuffered) {
                normalStore.refreshFromTree();

                normalStore.resumeEvents();
                
                guaranteeRange(0, treeStore.viewSize || 50);
            } else {
                normalStore.resumeEvents();
                
                topView.refresh();
            }
        });

        if (isBuffered) {
            var rangeStart, rangeEnd;
            
            normalStore.on('guaranteedrange', function (range, start, end) {
                rangeStart      = start;
                rangeEnd        = end;
            });
            
            var updateNodeStore = function () {
                if (fillingRoot) return;
                
                normalStore.refreshFromTree();
                
                guaranteeRange(rangeStart, rangeEnd);

                if (normalView.rendered) me.onNormalViewScroll();
            };

            treeStore.on({
                append      : updateNodeStore,
                insert      : updateNodeStore,
                remove      : updateNodeStore,
                move        : updateNodeStore,
                expand      : updateNodeStore,
                collapse    : updateNodeStore,
                sort        : updateNodeStore,

                buffer      : 1
            });
        }

        treeStore.on('filter', function (treeStore, args) {
            normalStore.filter.apply(normalStore, args);

            topView.refresh();
        });

        treeStore.on('clearfilter', function (treeStore) {
            normalStore.clearFilter();

            topView.refresh();
        });

        // TODO this should be moved to gantt, no cascade functionality in scheduler
        treeStore.on('beforecascade', function (treeStore) {
            normalStore.suspendEvents();
        });

        // TODO this should be moved to gantt, no cascade functionality in scheduler
        treeStore.on('cascade', function (treeStore, context) {

            normalStore.resumeEvents();

            if (context.nbrAffected > 0) {
                normalView.refreshKeepingScroll(true);
                setTimeout(function() {
                    lockedView.saveScrollState();
                    lockedView.refresh();
                    lockedView.restoreScrollState();
                }, 0);
            }
        });

        if (isBuffered && verticalScroller) {
            var prevOnGuaranteedRange   = verticalScroller.onGuaranteedRange;

            // native buffering is based on the assumption, that "refresh" event
            // from the store will trigger the view refresh - thats not true for tree case 
            // (search for "blockRefresh" in Ext sources)
            // so, after "onGuaranteedRange" we need to perform view refresh manually (for both locked/normal views)
            // we are doing "light" refresh - the one, not causing any changes in layout
            verticalScroller.onGuaranteedRange = function () {
                prevOnGuaranteedRange.apply(this, arguments);
                
                Ext.suspendLayouts();
                
                normalView.refreshSize  = Ext.emptyFn;
                lockedView.refreshSize  = Ext.emptyFn;
                
                topView.refresh();
                
                delete normalView.refreshSize;
                delete lockedView.refreshSize;
                
                Ext.resumeLayouts();
            };
        }
    },

    // Sync locked section after an event update
    onNormalViewItemUpdate: function (record, index, node) {
        if (this.lockedGridDependsOnSchedule) {
            var lockedView = this.lockedGrid.getView();
            lockedView.suspendEvents();
            lockedView.onUpdate(this.lockedGrid.store, record);
            lockedView.resumeEvents();
        }

        // HACK: Row height must be synced manually
        var row = this.normalGrid.getView().getNode(index);
        var changed = row.style.height !== node.style.height;
        row.style.height = node.style.height;
        this.normalHeights[index] = node.style.height;

        this.syncRowHeights(changed);
    },


    onViewItemAdd: function (records, index, nodes) {
        var normalHeights = this.normalHeights;
        var normalView = this.normalGrid.getView();
        
        Ext.each(records, function (record, idx) {
            var node = normalView.getNode(record);
            if (node) {
                normalHeights[node.viewIndex] = node.style.height;
            }
        });
        this.syncRowHeights();
    },


    processColumns: function (columns) {
        var res = this.callParent(arguments);
        var rightColumns = [];

        Ext.each(columns, function (column) {
            if (column.position == 'right') {
                column.processed = true;

                if (!Ext.isNumber(column.width)) {
                    Ext.Error.raise('"Right" columns must have a fixed width');
                }
                rightColumns.push(column);
                Ext.Array.remove(res.locked.items, column);

                // Adjust the locked width since 'right' columns (which Ext JS is knows nothing of) are not part of the locked section.
                res.lockedWidth -= column.width;
            }
        });

        if (this.orientation === 'horizontal') {
            res.normal.items = [
                {
                    xtype: this.lightWeight ? 'singletimeaxiscolumn' : 'timeaxiscolumn',
                    timeAxis: this.timeAxis,

                    timeCellRenderer: this.timeCellRenderer,
                    timeCellRendererScope: this.timeCellRendererScope,

                    trackHeaderOver : this.trackHeaderOver
                }
            ].concat(rightColumns);
        } else {
            res.locked.items = [
                Ext.apply({
                    xtype: 'verticaltimeaxis',
                    width: 100,
                    timeAxis: this.timeAxis
                }, this.timeAxisColumnCfg || {})
            ];
            res.lockedWidth = res.locked.items[0].width;
        }

        return res;
    },

    prepareFullRowHeightSync : function() {
        var me = this,
            view = me.normalGrid.getView(),
            lockedView = me.lockedGrid.getView(),
            el = view.el,
            lockedEl = lockedView.el,
            rowEls = el.query(view.getItemSelector()),
            lockedRowEls = lockedEl.query(lockedView.getItemSelector()),
            ln = rowEls.length,
            i = 0;

        me.lockedHeights = [];
        me.normalHeights = [];

        if (lockedRowEls.length !== ln) {
            return;
        }

        for (; i < ln; i++) {
            me.normalHeights[i] = rowEls[i].style.height;
        }
    },
    
    onLockedViewRefresh: function () { 
        this.prepareFullRowHeightSync();
        this.syncRowHeights();
    },

    onNormalViewRefresh: function () { 
        var lockedView = this.lockedGrid.getView();
        
        if (this.lockedGridDependsOnSchedule) {
            lockedView.un('refresh', this.onLockedViewRefresh, this);
            this.lockedGrid.getView().refresh();
            lockedView.on('refresh', this.onLockedViewRefresh, this);
        }

        this.prepareFullRowHeightSync();
        this.syncRowHeights();
    },

    syncRowHeights: function (updateSpacer) {
        var me = this,
            lockedHeights = me.lockedHeights,
            normalHeights = me.normalHeights,
            calcHeights = [],
            ln = lockedHeights.length || normalHeights.length,
            i = 0,
            lockedView, normalView,
            lockedRowEls, normalRowEls;
            
        if (lockedHeights.length || normalHeights.length) {
            lockedView = me.lockedGrid.getView();
            normalView = me.normalGrid.getView();

            if (!lockedView.rendered || !normalView.rendered) {
                return;
            }
            lockedRowEls = lockedView.el.query(lockedView.getItemSelector());

            if (!lockedRowEls.length) {
                return;
            }

            for (; i < ln; i++) {
                if (lockedRowEls[i] && normalHeights[i]) {
                    lockedRowEls[i].style.height = normalHeights[i];
                }
            }

            me.lockedHeights = [];
            me.normalHeights = [];
        }

        if (updateSpacer !== false) {
            me.updateSpacer();
        }
    },

    // Don't add locking/unlocking menu actions
    getMenuItems: function () {
        return function () {
            return Ext.grid.header.Container.prototype.getMenuItems.call(this);
        };
    },

    // @PATCH Broken in 4.1 RC2
    applyColumnsState: Ext.emptyFn,

    updateSpacer : function() {
        var lockedView = this.lockedGrid.getView();
        if (lockedView.rendered && lockedView.el.child('table') && !this.getSchedulingView().__lightRefresh) {
            var me   = this,
                // This affects scrolling all the way to the bottom of a locked grid
                // additional test, sort a column and make sure it synchronizes
                lockedViewEl   = me.lockedGrid.getView().el,
                normalViewEl = me.normalGrid.getView().el.dom,
                spacerId = lockedViewEl.dom.id + '-spacer',
                spacerHeight = (normalViewEl.offsetHeight - normalViewEl.clientHeight) + 'px';
                
            // put the spacer inside of stretcher with special css class (see below), which will cause the 
            // stretcher to increase its height on the height of spacer 
            var spacerParent    = this.store.buffered ? me.normalGrid.verticalScroller.stretcher.item(0) : lockedViewEl;
    
            me.spacerEl = Ext.getDom(spacerId);
            if (me.spacerEl) {
                me.spacerEl.style.height = spacerHeight;
            } else {
                Ext.core.DomHelper.append(spacerParent, {
                    id      : spacerId,
                    cls     : this.store.buffered ? 'sch-locked-buffered-spacer' : '',
                    style   : 'height: ' + spacerHeight
                });
            }
        }
    },
    
    onLockedViewRender    : function () {
        var normalGrid      = this.normalGrid;
        
        if (!normalGrid.rendered) {
            normalGrid.getView().on('render', this.onLockedViewRender, this);
            
            return;
        }
        
        // make sure the listener for "scroll" event is the last one 
        // (it should be called _after_ same listener of the PagingScroller)
        // only relevant for IE generally, but won't hurt for other browsers too
        normalGrid.getView().el.un('scroll', this.onNormalViewScroll, this);
        normalGrid.getView().el.on('scroll', this.onNormalViewScroll, this);

        var lockedViewEl        = this.lockedGrid.getView().el;
        
        var lockedStretcher     = lockedViewEl.createChild({
            cls     : 'x-stretcher',
            style   : {
                position    : 'absolute',
                width       : '1px',
                height      : 0,
                top         : 0,
                left        : 0
            }
        }, lockedViewEl.dom.firstChild);
        
        var verticalScroller        = normalGrid.verticalScroller;
        
        verticalScroller.stretcher.addCls('x-stretcher');
        
        verticalScroller.stretcher  = new Ext.dom.CompositeElement([ lockedStretcher, verticalScroller.stretcher ]);
    },

    onNormalViewGroupExpand : function() {
        this.prepareFullRowHeightSync();
        this.syncRowHeights();
    }
});

//updateSpacer : function() {
//        var lockedView = this.lockedGrid.getView();
//        
//        if (lockedView.rendered && lockedView.el.child('table') && !this.getSchedulingView().__lightRefresh) {
//            var me   = this,
//                // This affects scrolling all the way to the bottom of a locked grid
//                // additional test, sort a column and make sure it synchronizes
//                lockedViewEl    = lockedView.el,
//                normalViewEl    = me.normalGrid.getView().el.dom,
//                spacerId        = lockedViewEl.dom.id + '-spacer',
//                spacerHeight    = (normalViewEl.offsetHeight - normalViewEl.clientHeight) + 'px';
//                
//            var lockedStretcherEl   = me.normalGrid.verticalScroller.stretcher.item(0).dom;
//            var spacerPosition      = this.store.buffered && lockedStretcherEl.clientHeight ? 'absolute' : 'static';
//            
//            // put the spacer inside of stretcher with special css class (see below), which will cause the 
//            // stretcher to increase its height on the height of spacer 
//            var spacerParent    = spacerPosition == 'absolute' ? lockedStretcherEl : lockedViewEl;
//            
//            me.spacerEl         = Ext.getDom(spacerId);
//            
//            if (this.prevSpacerPosition && this.prevSpacerPosition != spacerPosition) {
//                Ext.fly(me.spacerEl).remove();
//                me.spacerEl     = null;
//            }
//            
//            this.prevSpacerPosition = spacerPosition
//            
//            if (me.spacerEl) {
//                me.spacerEl.style.height = spacerHeight;
//            } else {
//                Ext.core.DomHelper.append(spacerParent, {
//                    id      : spacerId,
//                    cls     : spacerPosition == 'absolute' ? 'sch-locked-buffered-spacer' : '',
//                    style   : 'height: ' + spacerHeight
//                });
//            }
//        }
//    },
/**
@class Sch.plugin.TreeCellEditing
@extends Ext.grid.plugin.CellEditing

A specialized "cell editing" plugin, purposed to correctly work with trees. Add it to your component (scheduler with tree view or gantt)
as usual grid plugin:

    var gantt = Ext.create('Gnt.panel.Gantt', {
        
        plugins             : [
            Ext.create('Sch.plugin.TreeCellEditing', {
                clicksToEdit: 1
            })
        ],
        ...
    })
*/
Ext.define("Sch.plugin.TreeCellEditing", {
    extend : "Ext.grid.plugin.CellEditing",
    
    // IE7 breaks otherwise
    startEditByClick: function(view, cell, colIdx, record, row, rowIdx, e) {
        // do not start editing when click occurs on the expander icon
        if (e.getTarget(view.expanderSelector)) {
            return;
        }
        
        this.callParent(arguments);
    },
    

    startEdit: function(record, columnHeader) {
// MODIFICATION
        if (!record || !columnHeader) {
            return;
        }
// EOF MODIFICATION
        
        var me = this,
            ed   = me.getEditor(record, columnHeader),
            value = record.get(columnHeader.dataIndex),
            context = me.getEditingContext(record, columnHeader);

        record = context.record;
        columnHeader = context.column;

        // Complete the edit now, before getting the editor's target
        // cell DOM element. Completing the edit causes a view refresh.
        me.completeEdit();

        // See if the field is editable for the requested record
        if (columnHeader && !columnHeader.getEditor(record)) {
            return false;
        }
        
        if (ed) {
            context.originalValue = context.value = value;
            if (me.beforeEdit(context) === false || me.fireEvent('beforeedit', context) === false || context.cancel) {
                return false;
            }

            me.context = context;
            me.setActiveEditor(ed);
            me.setActiveRecord(record);
            me.setActiveColumn(columnHeader);

// MODIFICATION
            me.grid.view.focusCell({ column : context.colIdx, row : context.rowIdx });
            // Defer, so we have some time between view scroll to sync up the editor
//                                                    enables the correct tabbing      enables the value adjustment in the 'beforeedit' event 
//                                                           |                                |    
            me.editTask.delay(15, ed.startEdit, ed, [me.getCell(record, columnHeader), context.value, context]);
// EOF MODIFICATION
            
        } else {
            // BrowserBug: WebKit & IE refuse to focus the element, rather
            // it will focus it and then immediately focus the body. This
            // temporary hack works for Webkit and IE6. IE7 and 8 are still
            // broken
            me.grid.getView().getEl(columnHeader).focus((Ext.isWebKit || Ext.isIE) ? 10 : false);
        }
    },

    getEditingContext: function(record, columnHeader) {
        var me = this,
            grid = me.grid,
            store = grid.store,
            rowIdx,
            colIdx,
            view = grid.getView(),
            value;

        
        if (Ext.isNumber(record)) {
            rowIdx = record;
            record = store.getAt(rowIdx);
        } else {
            if (store.indexOf) {
                rowIdx = store.indexOf(record);
            } else {
                rowIdx = view.indexOf(view.getNode(record));
            }
        }
        if (Ext.isNumber(columnHeader)) {
            colIdx = columnHeader;
            columnHeader = grid.headerCt.getHeaderAtIndex(colIdx);
        } else {
            colIdx = columnHeader.getIndex();
        }

        value = record.get(columnHeader.dataIndex);
        return {
            grid: grid,
            record: record,
            field: columnHeader.dataIndex,
            value: value,
            row: view.getNode(rowIdx),
            column: columnHeader,
            rowIdx: rowIdx,
            colIdx: colIdx
        };
    },

    startEditByPosition: function(position) {
        var me = this,
            grid = me.grid,
            sm = grid.getSelectionModel(),
            view = me.view,
            node = this.view.getNode(position.row),
            editColumnHeader = grid.headerCt.getHeaderAtIndex(position.column),
            editRecord = view.getRecord(node);

        if (sm.selectByPosition) {
            sm.selectByPosition(position);
        }
        me.startEdit(editRecord, editColumnHeader);
    }
});
/**
@class Sch.feature.ColumnLines
@extends Sch.plugin.Lines

A simple feature adding column lines (to be used when using the SingleTimeAxis column).

*/
Ext.define("Sch.feature.ColumnLines", {
    extend : 'Sch.plugin.Lines',

    cls : 'sch-column-line',
    
    showTip : false,

    requires : [
        'Ext.data.Store'
    ],
    
    init : function (panel) {
        this.timeAxis = panel.getTimeAxis();

        this.store = Ext.create("Ext.data.JsonStore", {
            model : Ext.define("Sch.model.TimeLine", {
                extend : 'Ext.data.Model',
                fields : [
                    'start',
                    { name : 'Date', convert: function(val, r) { return r.data.start; } }
                ]
            }),
            data : panel.getOrientation() === 'horizontal' ? this.getData() : []
        });
        
        this.callParent(arguments);

        var view = this.schedulerView;
        view.on('refresh', this.refresh, this);
    },

    refresh : function() {
        this.store.removeAll(true);
        var sv = this.schedulerView;

        if (sv.getOrientation() === 'horizontal' && sv.resourceStore.getCount() > 0) {
            this.store.add(this.getData());
        }
    },


    getData : function() {
        // Ignore first tick
        var ticks = this.timeAxis.getTicks().slice(1);
        
        // Manually inject last tick end date
        ticks.push({ start : this.timeAxis.getEnd() });
        return ticks;

    }
});
/**
@class Sch.plugin.CurrentTimeLine
@extends Sch.plugin.Lines

Plugin indicating the current date and time as a line in the schedule. 

To add this plugin to scheduler:

        var scheduler = Ext.create('Sch.panel.SchedulerGrid', {
            ...
    
            resourceStore   : resourceStore,
            eventStore      : eventStore,
            
            plugins         : [
                Ext.create('Sch.plugin.CurrentTimeLine', { updateInterval : 30000 })
            ]
        });


*/
Ext.define("Sch.plugin.CurrentTimeLine", {
    extend              : "Sch.plugin.Lines",
    
    /**
     * @cfg {String} tooltipText The text to show in the tooltip next to the current time (defaults to 'Current time').
     */
    tooltipText         : 'Current time',
    
    /**
     * @cfg {Int} updateInterval This value (in ms) defines how often the timeline shall be refreshed. Defaults to every once every minute.
     */
    updateInterval      : 60000,
    
    /**
     * @cfg {Boolean} autoUpdate true to automatically update the line position over time. Default value is `true`
     */
    autoUpdate          : true,
    
    
    init : function(cmp) {
        var store = Ext.create("Ext.data.JsonStore", {
            model : Ext.define("TimeLineEvent", {
                extend : 'Ext.data.Model',
                fields : ['Date', 'Cls', 'Text']
            }),
            data : [{Date : new Date(), Cls : 'sch-todayLine', Text : this.tooltipText}]
        });
            
        var record = store.first();

        if (this.autoUpdate) {
            this.runner = Ext.create("Ext.util.TaskRunner");
            this.runner.start({
                run: function() {
                    record.set('Date', new Date());
                },
                interval: this.updateInterval 
            });
        }

        cmp.on('destroy', this.onHostDestroy, this);
        
        this.store = store;
        this.callParent(arguments);
    },

    onHostDestroy : function() {
        if (this.runner) {
            this.runner.stopAll();
        }

        if (this.store.autoDestroy) {
            this.store.destroy();
        }
    }
}); 

/**
@class Sch.mixin.TimelineView
 
A base mixing for {@link Ext.view.View} classes, giving to the consuming view the "time line" functionality. 
This means that the view will be capabale to display a list of "events", ordered on the {@link Sch.data.TimeAxis time axis}.

By itself this mixin is not enough for correct rendering. The class, consuming this mixin, should also consume one of the 
{@link Sch.view.Horizontal} or {@link Sch.view.Vertical} mixins, which provides the implementation of some orientation-specfic methods.

Generally, should not be used directly, if you need to subclass the view, subclass the {@link Sch.view.SchedulerGridView} or {@link Sch.view.SchedulerTreeView} 
instead.

*/
Ext.define("Sch.mixin.TimelineView", {
    requires: [
        'Sch.column.Time', 
        'Sch.data.TimeAxis'
    ],

    /**
    * @cfg {String} orientation The view orientation
    */
    orientation: 'horizontal',
    
    /**
    * @cfg {String} overScheduledEventClass
    * A CSS class to apply to each event in the view on mouseover (defaults to 'sch-event-hover').
    */
    overScheduledEventClass: 'sch-event-hover',

    /**
    * @cfg {String} selectedEventCls
    * A CSS class to apply to each event in the view on mouseover (defaults to 'sch-event-selected').
    */
    selectedEventCls : 'sch-event-selected',
    
    // private
    altColCls : 'sch-col-alt',
        
    timeCellCls : 'sch-timetd',
    timeCellSelector : '.sch-timetd',

    ScheduleEventMap    : {
        click           : 'Click',
        dblclick        : 'DblClick',
        contextmenu     : 'ContextMenu',
        keydown         : 'KeyDown'
    },
        
    suppressFitCheck    : 0,
    
    forceFit            : false,

    inheritables : function() {
        return {
            cellBorderWidth : 1,
        
            // private
            initComponent: function () {
            
                this.setOrientation(this.panel._top.orientation || this.orientation);
        
                this.addEvents(
                    /**
                    * @event beforetooltipshow
                    * Fires before the event tooltip is shown, return false to suppress it.
                    * @param {Sch.mixin.SchedulerPanel} scheduler The scheduler object
                    * @param {Ext.data.Model} eventRecord The event record of the clicked record
                    */
                    'beforetooltipshow',

                    /**
                    * @event scheduleclick
                    * Fires after a click on the schedule area
                    * @param {Sch.mixin.SchedulerPanel} scheduler The scheduler object
                    * @param {Date} clickedDate The clicked date 
                    * @param {Int} rowIndex The row index 
                    * @param {Ext.EventObject} e The event object
                    */
                    'scheduleclick',

                    /**
                    * @event scheduledblclick
                    * Fires after a doubleclick on the schedule area
                    * @param {Sch.mixin.SchedulerPanel} scheduler The scheduler object
                    * @param {Date} clickedDate The clicked date 
                    * @param {Int} rowIndex The row index 
                    * @param {Ext.EventObject} e The event object
                    */
                    'scheduledblclick',

                    /**
                    * @event schedulecontextmenu
                    * Fires after a context menu click on the schedule area
                    * @param {Sch.mixin.SchedulerPanel} scheduler The scheduler object
                    * @param {Date} clickedDate The clicked date 
                    * @param {Int} rowIndex The row index 
                    * @param {Ext.EventObject} e The event object
                    */
                    'schedulecontextmenu',
                
                    'columnwidthchange'
                );
            
                this.enableBubble('columnwidthchange');
        
                var largeUnits = {},
                    D = Sch.util.Date;

                largeUnits[D.DAY] = largeUnits[D.WEEK] = largeUnits[D.MONTH] = largeUnits[D.QUARTER] = largeUnits[D.YEAR] = null;

                Ext.applyIf(this, {
                    eventPrefix : this.id + '-',
                    largeUnits : largeUnits
                });

                this.callParent(arguments);
            
                if (this.orientation === 'horizontal') {
                    this.getTimeAxisColumn().on('timeaxiscolumnreconfigured', this.checkHorizontalFit, this);
                }

                var pnl = this.panel._top;

                Ext.apply(this, {
                    eventRendererScope : pnl.eventRendererScope,
                    eventRenderer : pnl.eventRenderer,
                    eventBorderWidth: pnl.eventBorderWidth,
                    timeAxis : pnl.timeAxis,
                    dndValidatorFn : pnl.dndValidatorFn || Ext.emptyFn,
                    resizeValidatorFn : pnl.resizeValidatorFn || Ext.emptyFn,
                    createValidatorFn : pnl.createValidatorFn || Ext.emptyFn,
                    tooltipTpl : pnl.tooltipTpl,
                    validatorFnScope : pnl.validatorFnScope || this,
                    snapToIncrement: pnl.snapToIncrement,
                    timeCellRenderer: pnl.timeCellRenderer,
                    timeCellRendererScope: pnl.timeCellRendererScope,
                    readOnly: pnl.readOnly,
                    eventResizeHandles: pnl.eventResizeHandles,
                    enableEventDragDrop: pnl.enableEventDragDrop,
                    enableDragCreation: pnl.enableDragCreation,
                    dragConfig : pnl.dragConfig,
                    dropConfig : pnl.dropConfig,
                    resizeConfig : pnl.resizeConfig,
                    createConfig : pnl.createConfig,
                    tipCfg : pnl.tipCfg,
                    orientation : pnl.orientation,
                    getDateConstraints : pnl.getDateConstraints || Ext.emptyFn
                });
            },    

             // private, clean up
            onDestroy: function () {
                if (this.tip) {
                    this.tip.destroy();
                }
                this.callParent(arguments);
            },

            afterComponentLayout : function () {
                this.callParent(arguments);
                
                var width       = this.getWidth();
                var height      = this.getHeight();
                
                if (width === this.__prevWidth && height === this.__prevHeight) { return; }
                
                this.__prevWidth    = width;
                this.__prevHeight   = height;
                
                if (!this.lockable && !this.suppressFitCheck) {
                    this.checkHorizontalFit();
                }
            },

            // private
            beforeRender: function () {
                this.callParent(arguments);
                this.addCls("sch-timelineview");
                
                if (this.readOnly) {
                    this.addCls(this._cmpCls + '-readonly');
                }
            },

            afterRender : function () {
                this.callParent(arguments);
            
                if (this.overScheduledEventClass) {
                    this.mon(this.el, {
                        "mouseover": this.onMouseOver,
                        "mouseout": this.onMouseOut,
                        delegate: this.eventSelector,
                        scope: this
                    });
                }

                if (this.tooltipTpl) {
                    this.el.on('mousemove', this.setupTooltip, this, { single : true });
                }
        
                this.setupTimeCellEvents();
            },

            processUIEvent: function(e){
                var me = this,
                    eventBarNode = e.getTarget(this.eventSelector),
                    map = me.ScheduleEventMap,
                    type = e.type;
            
                if (eventBarNode && type in map) {
                    this.fireEvent(this.scheduledEventName + type, this, this.resolveEventRecord(eventBarNode), e);
                } else {
                    this.callParent(arguments);
                }
            },

            refresh: function(){
                // Force view to clear its contents
                this.fixedNodes = 0;
                //console.time('refresh');
                this.callParent(arguments);
                //console.timeEnd('refresh');
            },

            clearViewEl : function(){
                // Avoid clearing rendered zones/lines
                var me = this,
                    el = me.getTargetEl();
                
                el.down('table').remove();
            },

            // private
            onMouseOver: function (e, t) {
                if (t !== this.lastItem) {
                    this.lastItem = t;
                    Ext.fly(t).addCls(this.overScheduledEventClass);
                }
            },

            // private
            onMouseOut: function (e, t) {
                if (this.lastItem) {
                    if (!e.within(this.lastItem, true, true)) {
                        Ext.fly(this.lastItem).removeCls(this.overScheduledEventClass);
                        delete this.lastItem;
                    }
                }
            },
    
            // Overridden since locked grid can try to highlight items in the unlocked grid while it's loading/empty
            highlightItem: function(item) {
                if (item) {
                    var me = this;
                    me.clearHighlight();
                    me.highlightedItem = item;
                    Ext.fly(item).addCls(me.overItemCls);
                }
            },

            // Don't want Ext guessing if this row should be repainted or not, just do it
            shouldUpdateCell : function() { return true; }
        };
    },
        
    /**
    * Returns true, if there are any columns with `position : right` provided to this view
    * @return {Boolean} The formatted date
    */
    hasRightColumns : function () {
        return this.headerCt.items.getCount() > 1;
    },
        
        
    // returns `false` if the refresh has been happened
    checkHorizontalFit : function () {
        
        if (this.orientation === 'horizontal') {
            var actualWidth     = this.getActualTimeColumnWidth();
            var fittingWidth    = this.getFittingColumnWidth();
                
            if (this.forceFit) {
                if (fittingWidth != actualWidth) {
                    this.fitColumns();
                }
            } else if (this.snapToIncrement) {
                var snapColumnWidth    = this.calculateTimeColumnWidth(actualWidth);
                if (snapColumnWidth > 0 && snapColumnWidth !== actualWidth) {
                    this.setColumnWidth(snapColumnWidth);
                }
            } else if (actualWidth < fittingWidth) {
                this.fitColumns();
            }
        }
    },
        
        
    getTimeAxisColumn : function () {
        return this.headerCt.items.get(0);
    },
        
    getFirstTimeColumn : function () {
        return this.headerCt.getGridColumns()[0];
    },
        
    
    /**
    * Method to get a formatted display date
    * @private
    * @param {Date} date The date
    * @return {String} The formatted date
    */
    getFormattedDate: function (date) {
        return Ext.Date.format(date, this.getDisplayDateFormat());
    },

    /**
    * Method to get a formatted end date for a scheduled event, the grid uses the "displayDateFormat" property defined in the current view preset.
    * @private
    * @param {Date} endDate The date to format
    * @param {Date} startDate The start date 
    * @return {String} The formatted date
    */
    getFormattedEndDate: function (endDate, startDate) {
        var ta = this.timeAxis,
            resUnit = ta.getResolution().unit;

        // If resolution is day or greater, and end date is greater then start date
        if (resUnit in this.largeUnits && endDate.getHours() === 0 && endDate.getMinutes() === 0 &&
            !(endDate.getYear() === startDate.getYear() && endDate.getMonth() === startDate.getMonth() && endDate.getDate() === startDate.getDate())) {
            endDate = Sch.util.Date.add(endDate, Sch.util.Date.DAY, -1);
        }
                
//            // experimental, this should turn "<" into "<="
//            endDate = Sch.util.Date.add(endDate, Sch.util.Date.MILLI, -1);
                
        return Ext.Date.format(endDate, this.getDisplayDateFormat());
    },

    // private
    getDisplayDateFormat: function () {
        return this.displayDateFormat;
    },

    // private
    setDisplayDateFormat: function (format) {
        this.displayDateFormat = format;
    },
   

    /**
    * Returns the amount of pixels for a single unit
    * @private
    * @return {String} The unit in pixel
    */
    getSingleUnitInPixels: function (unit) {
        return Sch.util.Date.getUnitToBaseUnitRatio(this.timeAxis.getUnit(), unit) * this.getSingleTickInPixels();
    },

    /**
    * Returns the amount of pixels for a single unit
    * @private
    * @return {String} The unit in pixel
    */
    getSingleTickInPixels: function () {
        throw 'Must be implemented by horizontal/vertical';
    },

    /**
    *  Scrolls an event record into the viewport (only works for events that have already been rendered)
    *  @param {Ext.data.Model} eventRec, the event record to scroll into view
    *  @param {Mixed} highlight, either true/false or a highlight config object used to highlight the element after scrolling it into view
    */
    scrollEventIntoView: function (eventRec, highlight) {
        var el = this.getOuterElementFromEventRecord(eventRec);

        if (el) {
            el.scrollIntoView(this.el);
                
            if (highlight) {
                if (typeof highlight === "boolean") {
                    el.highlight();
                } else {
                    el.highlight(null, highlight);
                }
            }
        }
    },

    calculateTimeColumnWidth: function (proposedTimeColumnWidth) {
        if (!this.panel.rendered) {
            return proposedTimeColumnWidth;
        }

        var forceFit = this.forceFit;
        
        var width           = 0,
            timelineUnit    = this.timeAxis.getUnit(),
            nbrTimeColumns  = this.timeAxis.getCount(),
            ratio           = Number.MAX_VALUE;
            
        if (this.snapToIncrement) {
            var res         = this.timeAxis.getResolution(),
                unit        = res.unit,
                resIncr     = res.increment;

            ratio = Sch.util.Date.getUnitToBaseUnitRatio(timelineUnit, unit) * resIncr;
        }
            
        var measuringUnit   = Sch.util.Date.getMeasuringUnit(timelineUnit);

        ratio               = Math.min(ratio, Sch.util.Date.getUnitToBaseUnitRatio(timelineUnit, measuringUnit));
            
        var fittingWidth    = Math.floor(this.getAvailableWidthForSchedule() / nbrTimeColumns);

        width               = (forceFit || proposedTimeColumnWidth < fittingWidth) ? fittingWidth : proposedTimeColumnWidth;

        if (!forceFit || ratio < 1) {
            width = Math.round(Math.max(1, Math[forceFit ? 'floor' : 'round'](ratio * width)) / ratio);
        }
            
        return width;
    },
        
        
    getFittingColumnWidth : function () {
        var proposedWidth   = Math.floor(this.getAvailableWidthForSchedule() / this.timeAxis.getCount());
            
        return this.calculateTimeColumnWidth(proposedWidth);
    },
        
        
    /**
    * This function fits the time columns into the available space in the grid.
    * @param {Boolean} preventRefresh `true` to prevent the refresh of view
    */ 
    fitColumns: function (preventRefresh) {
        var w = 0;
            
        if (this.orientation === 'horizontal') {
            w = this.getFittingColumnWidth();
        } else {
            w = Math.floor((this.panel.getWidth() - Ext.getScrollbarSize().width - 1) / this.headerCt.getColumnCount());
        }
        
        // will call `refresh` if `preventRefresh` is not true
        this.setColumnWidth(w, preventRefresh);
    },
    
    // private
    getAvailableWidthForSchedule: function () {
        var available   = this.lastBox.width;
        var items       = this.headerCt.items.items;
        
        // substracting the widths of all columns starting from 2nd ("right" columns)
        for (var i = 1; i < items.length; i++) {
            available -= items[ i ].getWidth();
        }
            
        return available - Ext.getScrollbarSize().width - 1;
    },
    
    
    getRightColumnsWidth : function () {
        var total       = 0;
        var items       = this.headerCt.items.items;
        
        for (var i = 1; i < items.length; i++) {
            total       += items[ i ].getWidth();
        }
            
        return total;
    },
    
    
    // monkey patch for "right column" + "forceFit" combination
    // the positions of the headers for right columns are calculated wrong - fixing them manually 
    fixRightColumnsPositions : function () {
        var items       = this.headerCt.items.items;
        
        var leftPos     = items[ 0 ].getWidth();
        
        for (var i = 1; i < items.length; i++) {
            var item    = items[ i ];
            
            item.el.setLeft(leftPos);
            
            leftPos     += item.getWidth();
        }
    },
    

    /**
    * <p>Returns the Ext Element representing an event record</p> 
    * @param {Sch.model.Event} record The event record
    * @return {Ext.Element} The Ext.Element representing the event record
    */
    getElementFromEventRecord: function (record) {
        return Ext.get(this.eventPrefix + record.internalId);
    },
        
        
    getEventNodeByRecord: function(record) {
        return document.getElementById(this.eventPrefix + record.internalId);
    },

        
    /**
    * <p>Returns the Ext Element representing an event record</p> 
    * @param {Ext.data.Model} record The record
    * @return {Ext.Element} The Ext Element representing the event record
    */
    getOuterElementFromEventRecord: function (record) {
        return Ext.get(this.eventPrefix + record.internalId);
    },
        

    // private
    resolveColumnIndex: function (x) {
        return Math.floor(x/this.getActualTimeColumnWidth());
    },

    /**
    * Gets the start and end dates for an element Region
    * @param {Region} region The region to map to start and end dates
    * @param {String} roundingMethod The rounding method to use
    * @returns {Object} an object containing start/end properties
    */
    getStartEndDatesFromRegion: function (region, roundingMethod) {
        throw 'Must be implemented by horizontal/vertical';
    },

    
    // private
    setupTooltip: function () {
        var me = this,
            tipCfg = Ext.apply({
                renderTo: Ext.getBody(),
                delegate: me.eventSelector,
                target: me.el,
                anchor: 'b'
            }, me.tipCfg);    

        me.tip = Ext.create('Ext.ToolTip', tipCfg);
        me.tip.on({
            beforeshow: function (tip) {
                if (!tip.triggerElement || !tip.triggerElement.id) {
                    return false;
                }

                var record = this.resolveEventRecord(tip.triggerElement);

                if (!record || this.fireEvent('beforetooltipshow', this, record) === false) {
                    return false;
                }

                tip.update(this.tooltipTpl.apply(this.getDataForTooltipTpl(record)));

                return true;
            },
            scope: this
        });
    },

    /**
    * Template method to allow you to easily provide data for your {@link Sch.mixing.TimelinePanel#tooltipTpl} template.
    * @return {Mixed} The data to be applied to your template, typically any object or array.
    */
    getDataForTooltipTpl : function(record) {
        return record.data;
    },

    /**
    * Returns the current time resolution object, which contains a unit identifier and an increment count.
    * @return {Object} The time resolution object
    */
    getTimeResolution: function () {
        return this.timeAxis.getResolution();
    },

    /**
    * Sets the current time resolution, composed by a unit identifier and an increment count.
    * @return {Object} The time resolution object
    */
    setTimeResolution: function (unit, increment) {
        this.timeAxis.setResolution(unit, increment);

        // View will have to be updated to support snap to increment
        if (this.snapToIncrement) {
            this.refreshKeepingScroll();
        }
    },

    /**
    * <p>Returns the event id for a DOM id </p>
    * @private
    * @param {String} id The id of the DOM node
    * @return {Ext.data.Model} The event record
    */
    getEventIdFromDomNodeId: function (id) {
        return id.substring(this.eventPrefix.length);
    },

     
    /**
    *  Gets the time for a DOM event such as 'mousemove' or 'click'
    *  @param {Ext.EventObject} e, the EventObject instance
    *  @param {String} roundingMethod (optional), 'floor' to floor the value or 'round' to round the value to nearest increment
    *  @returns {Date} The date corresponding to the EventObject x coordinate
    */
    getDateFromDomEvent : function(e, roundingMethod) {
        return this.getDateFromXY(e.getXY(), roundingMethod);
    },

    // private
    handleScheduleEvent : function(e) {
        var t = e.getTarget('.' + this.timeCellCls, 2);

        if (t) {
            var clickedDate = this.getDateFromDomEvent(e, 'floor');
            this.fireEvent('schedule' + e.type, this, clickedDate, this.indexOf(this.findItemByChild(t)), e);
        }
    },
        
    setupTimeCellEvents: function () {
        this.mon(this.el, {
            click: this.handleScheduleEvent,
            dblclick: this.handleScheduleEvent,
            contextmenu: this.handleScheduleEvent,
            scope: this
        }, this);
    },

    /**
    * [Experimental] Returns the pixel increment for the current view resolution.
    * @return {Int} The width increment
    */
    getSnapPixelAmount: function () {
        if (this.snapToIncrement) {
            var resolution = this.timeAxis.getResolution();
            return (resolution.increment || 1) * this.getSingleUnitInPixels(resolution.unit);
        } else {
            return 1;
        }
    },

    getActualTimeColumnWidth : function() {
        return this.headerCt.items.get(0).getTimeColumnWidth();
    },

    /**
    * Controls whether the scheduler should snap to the resolution when interacting with it.
    * @param {Boolean} enabled true to enable snapping when interacting with events.
    */
    setSnapEnabled: function (enabled) {
        this.snapToIncrement = enabled;

        if (enabled) {
            this.refreshKeepingScroll();
        }
    },

    /**
    * Sets the readonly state which limits the interactivity (resizing, drag and drop etc).
    * @param {Boolean} readOnly The new readOnly state
    */
    setReadOnly: function (readOnly) {
        this.readOnly = readOnly;
        this[readOnly ? 'addCls' : 'removeCls'](this._cmpCls + '-readonly');
    },

    /**
    * Returns true if the view is currently readOnly.
    * @return {Boolean} readOnly 
    */
    isReadOnly: function () {
        return this.readOnly;
    },

        
    /**
    * Sets the current orientation.
    * 
    * @param {String} orientation Either 'horizontal' or 'vertical'
    */
    setOrientation : function(orientation) {
        this.orientation = orientation; 
        // Apply the orientation specific view methods/properties from the horizontal or vertical meta classes
        Ext.apply(this, Sch.view[Ext.String.capitalize(orientation)].prototype.props);
    },

    /**
    * Returns the current view orientation
    * @return {String} The view orientation ('horizontal' or 'vertical')
    */
    getOrientation: function () {
        return this.orientation;
    },
       
    translateToScheduleCoordinate: function (x) {
        throw 'Abstract method call!';
    },

    translateToPageCoordinate: function (x) {
        throw 'Abstract method call!';
    },

    /**
    * Gets the date for an XY coordinate
    * @param {Array} xy The page X and Y coordinates
    * @param {String} roundingMethod The rounding method to use
    * @returns {Date} the Date corresponding to the xy coordinate
    * @abstract
    */
    getDateFromXY: function (xy, roundingMethod) {
        throw 'Abstract method call!';
    },

    /**
    *  Gets xy coordinates relative to the element containing the time columns time for a date
    *  @param {Date} xy, the page X and Y coordinates
    *  @param {Boolean} local, true to return a coordinate local to the element containing the calendar columns
    *  @returns {Array} the XY coordinates representing the date
    */
    getXYFromDate: function (date, local) {
        throw 'Abstract method call!';
    },

    /**
    *  Returns the region for a "global" time span in the view. Coordinates are relative to element containing the time columns
    *  @param {Date} startDate The start date of the span
    *  @param {Date} endDate The end date of the span
    *  @return {Ext.util.Region} The region for the time span
    */
    getTimeSpanRegion: function (startDate, endDate) {
        throw 'Abstract method call!';
    },

    /**
    * Method to get a the current start date of the scheduler view
    * @return {Date} The start date
    */
    getStart: function () {
        return this.timeAxis.getStart();
    },

    /**
    * Method to get a the current end date of the scheduler view
    * @return {Date} The end date
    */
    getEnd: function () {
        return this.timeAxis.getEnd();
    },

    /**
    * Sets the amount of margin to keep between bars and rows.
    * @param {Int} margin The new margin value
    * @param {Boolean} preventRefresh true to skip refreshing the view
    */
    setBarMargin: function (margin, preventRefresh) {
        this.barMargin = margin;
        if (!preventRefresh) {
            this.refreshKeepingScroll();
        }
    },

        
    /**
        * Sets the height of row
        * @param {Number} height The height to set
        * @param {Boolean} preventRefresh `true` to prevent view refresh
        */
    setRowHeight: function (height, preventRefresh) {
        this.rowHeight = height || 24;
 
        if (this.rendered && !preventRefresh) {
            this.refreshKeepingScroll();
        }
    },
    
    /**
    * Refreshes the view and maintains the scroll position.
    */
    refreshKeepingScroll : function(lightRefresh) {
        this.saveScrollState();
        if (this.lightRefresh) {
            this.lightRefresh();
        } else {
            this.refresh();
        }
        this.restoreScrollState();
    },

    /**
    * Refreshes the view without causing resize calculations, layout cycles.
    */
    lightRefresh : function() {
        var old = this.refreshSize;
        Ext.suspendLayouts();
        this.refreshSize = Ext.emptyFn;
        this.__lightRefresh = true;
        this.refresh();
        delete this.__lightRefresh;
        this.refreshSize = old;
        Ext.resumeLayouts();
    }

    /**
    * Sets the width of individual time column
    * @param {Number} width The width to set
    * @param {Boolean} preventRefresh `true` to prevent view refresh
    */
//    setColumnWidth : function (width, preventRefresh) {
//        throw 'Abstract method call!';
//    }
});


Ext.apply(Sch, {
    /*VERSION*/
});
/**
@class Sch.view.Horizontal

A mixin, purposed to be consumed along with {@link Sch.mixin.TimelineView} and providing the implementation of some methods, specific to horizontal orientation.

*/
Ext.define("Sch.view.Horizontal", {
    props: {

        translateToScheduleCoordinate: function (x) {
            return x - this.el.getX() + this.el.getScroll().left;
        },

        translateToPageCoordinate: function (x) {
            return x + this.el.getX() - this.el.getScroll().left;
        },

        /**
        * Gets the date for an XY coordinate
        * @param {Array} xy The page X and Y coordinates
        * @param {String} roundingMethod The rounding method to use
        * @returns {Date} the Date corresponding to the xy coordinate
        * @abstract
        */
        getDateFromXY: function (xy, roundingMethod) {
            var date,
                x = this.translateToScheduleCoordinate(xy[0]),
                tick = x / this.getActualTimeColumnWidth(),
                maxCol = this.timeAxis.getCount();
                
            if (tick < 0 || tick > maxCol) {
                date = null;
            } else {
                var diff = tick - this.resolveColumnIndex(x);
                if (diff > 2 && tick >= maxCol) {
                    return null;
                }
                date = this.timeAxis.getDateFromTick(tick, roundingMethod);
            }
            return date;
        },

        /**
        *  Gets xy coordinates relative to the element containing the time columns time for a date
        *  @param {Date} xy, the page X and Y coordinates
        *  @param {Boolean} local, true to return a coordinate local to the element containing the calendar columns
        *  @returns {Array} the XY coordinates representing the date
        */
        getXYFromDate: function (date, local) {
            var x,
                tick = this.timeAxis.getTickFromDate(date);

            if (tick >= 0) {
                x = this.getActualTimeColumnWidth() * tick;
            }

            if (local === false) {
                x = this.translateToPageCoordinate(x);
            }

            return [x, 0];
        },

        getEventBox: function (start, end) {
            var startX = Math.floor(this.getXYFromDate(start)[0]),
                endX = Math.floor(this.getXYFromDate(end)[0]),
                M = Math;

            if (this.managedEventSizing) {
                
                return {
                    top: Math.max(0, (this.barMargin - (Ext.isIE && !Ext.isStrict) ? 0 : this.eventBorderWidth - this.cellBorderWidth)),
                    left: M.min(startX, endX),
                    width: M.max(1, M.abs(startX - endX)),
                    height: this.rowHeight - (2 * this.barMargin) - this.eventBorderWidth
                };
            }
            return {
                left: M.min(startX, endX),
                width: M.max(1, M.abs(startX - endX))
            };
        },

        layoutEvents: function (events) {

            var rowEvents = Ext.Array.clone(events);

            // Sort events by start date, and text properties.
            rowEvents.sort(this.sortEvents);

            var nbrBandsRequired = this.layoutEventsInBands(0, rowEvents);

            return nbrBandsRequired;
        },

        layoutEventsInBands: function (bandIndex, events) {
            var ev = events[0],
                bandTop = bandIndex === 0 ? this.barMargin : (bandIndex * this.rowHeight - ((bandIndex - 1) * this.barMargin));
            
            if (bandTop >= this.cellBorderWidth) {
                bandTop -= this.cellBorderWidth;
            }

            while (ev) {
                // Apply band height to the event cfg
                ev.top = bandTop;

                // Remove it from the array and continue searching
                Ext.Array.remove(events, ev);
                ev = this.findClosestSuccessor(ev, events);
            }

            bandIndex++;

            if (events.length > 0) {
                return this.layoutEventsInBands(bandIndex, events);
            } else {
                // Done!
                return bandIndex;
            }
        },

        /**
        * Gets the Ext.util.Region represented by the schedule and optionally only for a single resource. This method will call getDateConstraints to 
        * allow for additional resource/event based constraints. By overriding that method you can constrain events differently for
        * different resources.
        * @param {Ext.data.Model} resourceRecord (optional) The resource record 
        * @param {Ext.data.Model} eventRecord (optional) The event record 
        * @return {Ext.util.Region} The region of the schedule
        */
        getScheduleRegion: function (resourceRecord, eventRecord) {
            var region          = resourceRecord ? Ext.fly(this.getNodeByRecord(resourceRecord)).getRegion() : this.el.down('.x-grid-table').getRegion(),
                taStart         = this.timeAxis.getStart(),
                taEnd           = this.timeAxis.getEnd(),
                dateConstraints = this.getDateConstraints(resourceRecord, eventRecord) || { start: taStart, end: taEnd },
                startX          = this.translateToPageCoordinate(this.getXYFromDate(dateConstraints.start)[0]),
                endX            = this.translateToPageCoordinate(this.getXYFromDate(dateConstraints.end)[0]),
                top             = region.top + this.barMargin,
                bottom          = region.bottom - this.barMargin - this.eventBorderWidth; 

            return new Ext.util.Region(top, Math.max(startX, endX), bottom, Math.min(startX, endX));
        },


        /**
        * Gets the Ext.util.Region representing the passed resource and optionally just for a certain date interval.
        * @param {Ext.data.Model} resourceRecord The resource record 
        * @param {Date} startDate A start date constraining the region
        * @param {Date} endDate An end date constraining the region
        * @return {Ext.util.Region} The region of the resource
        */
        getResourceRegion: function (resourceRecord, startDate, endDate) {
            var region          = Ext.fly(this.getNodeByRecord(resourceRecord)).getRegion(),
                taStart         = this.timeAxis.getStart(),
                taEnd           = this.timeAxis.getEnd(),
                start           = startDate ? Sch.util.Date.max(taStart, startDate) : taStart,
                end             = endDate ? Sch.util.Date.min(taEnd, endDate) : taEnd,
                startX          = this.getXYFromDate(start)[0],
                endX            = this.getXYFromDate(end)[0], 
                ctElTop         = this.el.getTop(),
                ctElScroll      = this.el.getScroll(),
                top             = region.top + 1 - ctElTop + ctElScroll.top,
                bottom          = region.bottom - 1 - ctElTop + ctElScroll.top;
                
            return new Ext.util.Region(top, Math.max(startX, endX), bottom, Math.min(startX, endX));
        },

        collectRowData: function (rowData, resourceRecord, index) {
            var resourceEvents = this.eventStore.getEventsForResource(resourceRecord);

            if (resourceEvents.length === 0 || this.headerCt.getColumnCount() === 0) {
                rowData.rowHeight = this.rowHeight;
                return rowData;
            }

            var D = Sch.util.Date,
                ta = this.timeAxis,
                viewStart = ta.getStart(),
                viewEnd = ta.getEnd(),
                eventsToRender = [],
                i, l;

            // Iterate events belonging to current row
            for (i = 0, l = resourceEvents.length; i < l; i++) {
                var event = resourceEvents[i],
                    start = event.getStartDate(),
                    end = event.getEndDate();

                // Determine if the event should be rendered or not
                if (start && end && ta.timeSpanInAxis(start, end)) {
                    var tplData = this.generateTplData(event, viewStart, viewEnd, resourceRecord, index);
                    eventsToRender[eventsToRender.length] = tplData;
                }
            }

            var nbrOfBandsRequired = 1;

            // Event data is now gathered, calculate layout properties for each event (if dynamicRowHeight is used)
            if (this.dynamicRowHeight) {
                nbrOfBandsRequired = this.layoutEvents(eventsToRender);
            }

            // Set rowHeight property that is applied by Scheduling feature
            rowData.rowHeight = (nbrOfBandsRequired * this.rowHeight) - ((nbrOfBandsRequired - 1) * this.barMargin);

            // Inject the rendered events into the first cell for the row
            rowData[this.getFirstTimeColumn().id] += '&#160;' + this.eventTpl.apply(eventsToRender);

            return rowData;
        },

        // private
        resolveResource: function (t) {
            var node = this.findItemByChild(t);
            if (node) {
                return this.getRecord(node);
            }

            return null;
        },

        /**
        *  Returns the region for a "global" time span in the view. Coordinates are relative to element containing the time columns
        *  @param {Date} startDate The start date of the span
        *  @param {Date} endDate The end date of the span
        *  @return {Ext.util.Region} The region for the time span
        */
        getTimeSpanRegion: function (startDate, endDate, useViewSize) {
            var startX      = this.getXYFromDate(startDate)[0],
                endX        = this.getXYFromDate(endDate || startDate)[0],
                height,
                tableEl;
                
            if (this.store.buffered) {
                var stretcher   = this.el.down('.x-stretcher');
                
                // when the buffered dataset is small and fully cached in the store
                // stretcher height is set to 0
                // in such cases we don't use its height
                if (stretcher.dom.clientHeight) tableEl = stretcher;
            }
            
            if (!tableEl) tableEl = this.el.down('.x-grid-table');
                
            if (useViewSize) {
                height = Math.max(tableEl ? tableEl.dom.clientHeight : 0, this.el.dom.clientHeight); // fallback in case grid is not rendered (no rows/table)
            } else {
                height = tableEl ? tableEl.dom.clientHeight : 0;
            }
            return new Ext.util.Region(0, Math.max(startX, endX), height, Math.min(startX, endX));
        },

        /**
        * Gets the start and end dates for an element Region
        * @param {Region} region The region to map to start and end dates
        * @param {String} roundingMethod The rounding method to use
        * @returns {Object} an object containing start/end properties
        */
        getStartEndDatesFromRegion: function (region, roundingMethod) {
            var leftDate = this.getDateFromXY([region.left, region.top], roundingMethod),
                rightDate = this.getDateFromXY([region.right, region.bottom], roundingMethod);

            if (rightDate && leftDate) {
                return {
                    start: Sch.util.Date.min(leftDate, rightDate),
                    end: Sch.util.Date.max(leftDate, rightDate)
                };
            } else {
                return null;
            }
        },

        // private
        onEventAdd: function (s, recs) {
            var affectedResources = {};

            for (var i = 0, l = recs.length; i < l; i++) {
                var resource = recs[i].getResource();
                if (resource) {
                    affectedResources[resource.getId()] = resource;
                }
            }

            Ext.Object.each(affectedResources, function(id, resource) {
                this.onUpdate(this.resourceStore, resource);
            }, this);
        },

        // private
        onEventRemove: function (s, eventRecord) {
            var el = this.getElementFromEventRecord(eventRecord);

            if (el) {
                var resource = this.resolveResource(el);
                el.fadeOut({
                    callback: function () {
                        if (this.resourceStore.indexOf(resource) >= 0) {
                            this.onUpdate(this.resourceStore, resource);
                        }
                    },
                    scope: this
                });
            }
        },

        // private
        onEventUpdate: function (store, model, operation) {
            var resource,
                previous = model.previous;
                
            if (previous && previous[model.resourceIdField]) {
                // If an event has been moved to a new row, refresh old row first
                resource = model.getResource(previous[model.resourceIdField]);
                if (resource) {
                    this.onUpdate(this.resourceStore, resource);
                }
            }

            resource = model.getResource();
            if (resource) {
                this.onUpdate(this.resourceStore, resource);
            }
        },

        /**
        * Returns the amount of pixels for a single unit
        * @private
        * @return {String} The unit in pixel
        */
        getSingleTickInPixels: function () {
            return this.getActualTimeColumnWidth();
        },

        setColumnWidth: function (width, preventRefresh) {
            if (this.getTimeAxisColumn()) {
                this.getTimeAxisColumn().setTimeColumnWidth(width);

                if (!preventRefresh) {
                    this.refreshKeepingScroll();
                }
            }

            this.fireEvent('columnwidthchange', this, width);
        },

        /**
        * Method to get a currently visible date range in a scheduling view. Please note that it only work when scheduler is rendered.
        * @return {Object} object with `startDate` and `endDate` properties.
        */
        getVisibleDateRange: function () {
            if (!this.rendered) {
                return null;
            }

            var scroll = this.getEl().getScroll(),
                startDate = this.panel.getStart(),
                endDate = this.panel.getEnd(),
                width = this.getWidth();

            var innerTable = Ext.query('.x-grid-table', this.getEl().dom)[0];

            if (innerTable.clientWidth < width) {
                return { startDate: startDate, endDate: endDate };
            }

            var singleTickInPixels = this.getSingleTickInPixels();
            var units = this.timeAxis.getUnit();

            return {
                startDate: Sch.util.Date.add(startDate, units, scroll.left / singleTickInPixels),
                endDate: Sch.util.Date.add(startDate, units, scroll.left / singleTickInPixels + width / singleTickInPixels)
            };
        }
    }
}); 

/**

@class Sch.view.TimelineTreeView
@extends Ext.tree.View
@mixin Sch.mixin.TimelineView

A tree view class, that have consumed the {@link Sch.mixin.TimelineView} mixin. Used internally.

*/
Ext.define("Sch.view.TimelineTreeView", {
    extend          : "Ext.tree.View",
    mixins : [
        'Sch.mixin.TimelineView'
    ], 

    requires : [
        'Sch.patches.TreeView'
    ],
    
    cellBorderWidth : 0,
    
    beforeRender : function() {
        this.addCls('sch-timelinetreeview');
        this.callParent(arguments);
    }
        
}, function() {
    this.override(Sch.mixin.TimelineView.prototype.inheritables() || {});
});
/**

@class Sch.mixin.TimelinePanel

A base mixing for {@link Ext.panel.Panel} classes, giving to the consuming panel the "time line" functionality. 
This means that the panel will be capabale to display a list of "events", ordered on the {@link Sch.data.TimeAxis time axis}.

Generally, should not be used directly, if you need to subclass the scheduler panel, subclass the {@link Sch.panel.SchedulerGrid} or {@link Sch.panel.SchedulerTree} 
instead.

*/

Ext.define('Sch.mixin.TimelinePanel', {
    requires: [
        'Sch.util.Patch',
        'Sch.patches.LoadMask',
        'Sch.patches.Model',

        'Sch.data.TimeAxis',
        'Sch.feature.ColumnLines',
        'Sch.view.Locking',
        'Sch.mixin.Lockable',
        'Sch.preset.Manager'
    ],


    /**
    * @cfg {String} orientation An initial orientation of the view - can be either `horizontal` or `vertical`. Default value is `horizontal`.
    */
    orientation: 'horizontal',

    /**
    * @cfg {Int} weekStartDay A valid JS date index between 0-6. (0: Sunday, 1: Monday etc.).
    */
    weekStartDay: 1,

    /**
    * @cfg {Boolean} snapToIncrement true to snap to resolution increment while interacting with scheduled events.
    */
    snapToIncrement: false,

    /**
    * @cfg {Boolean} readOnly true to disable editing.
    */
    readOnly: false,

    /**
    * @cfg {String} eventResizeHandles Defines which resize handles to use for resizing events. Possible values: 'none', 'start', 'end', 'both'. Defaults to 'both'
    */
    eventResizeHandles: 'both',

    /**
    * @cfg {Int} rowHeight The row height (used in horizontal mode only)
    */

    /**
    * @cfg {Object} validatorFnScope
    * The scope used for the different validator functions.
    */

    /**
    * @cfg {String} viewPreset A key used to lookup a predefined {@link Sch.preset.ViewPreset} (e.g. 'weekAndDay', 'hourAndDay'), managed by {@link Sch.preset.Manager}. See Sch.preset.Manager for more information.
    */
    viewPreset: 'weekAndDay',

    /**
    * @property {String} viewPreset A name of the current view preset: {@link Sch.ViewPreset}. Required.
    */


    /**
     * @cfg {Boolean} trackHeaderOver `true` to highlight each header cell when the mouse is moved over it. Only used when the "lightWeight" mode is enabled.
     */
    trackHeaderOver         : true,

    /**
    * @cfg {Date} startDate A start date of the timeline. Required
    */
    startDate: null,

    /**
    * @cfg {Date} endDate A end date of the timeline. Required
    */
    endDate: null,


    // The width of the left + right border of your event, needed to calculate the correct start/end positions
    eventBorderWidth: 1,

    // TODO, remove for 2.1. Don't think we need this
    syncCellHeight: Ext.emptyFn,

    /**
    * @cfg {Object} lockedGridConfig A custom config object used to initialize the left (locked) grid panel.
    */

    /**
    * @cfg {Object} schedulerConfig A custom config object used to initialize the right (schedule) grid panel. 
    */

    /**
    * @cfg {Ext.Template} tooltipTpl 
    * Template used to show a tooltip over a scheduled item, null by default (meaning no tooltip). The tooltip will be populated with the data in 
    * record corresponding to the hovered element. See also {@link #tipCfg}.
    */
    tooltipTpl: null,

    /**
    * @cfg {Object} tipCfg
    * The {@link Ext.Tooltip} config object used to configure a tooltip (only applicable if tooltipTpl is set).
    */
    tipCfg: {
        cls: 'sch-tip',

        showDelay: 1000,
        hideDelay: 0,

        autoHide: true,
        anchor: 'b'
    },
    
    /**
     * @cfg {Boolean} lightWeight
     * 
     * When this option is set to true (by default), scheduler will _not_ generate a separate cell for each time interval in the bottom row of the timeline.
     * Instead, only single cell will be generated, providing lightweight DOM footprint and much better performance. The downside of this optimization
     * is that its not possible to customize every cell in the scheduler view. Because of that, this option is automatically disabled 
     * if {@link #timeCellRenderer} is provided.
     */
    lightWeight             : true,
    
    
    /**
    * @cfg {Function} timeCellRenderer An empty function by default, but provided so that you can manipulate the html cells that make up the schedule.
    * This is called once for each cell, just like a normal GridPanel renderer though returning values from it has no effect.
    * @param {Object} meta The same meta object as seen in a standard GridPanel cell renderer. Use it to modify CSS/style of the cell.
    * @param {Ext.data.Model} record The resource record to which the cell belongs
    * @param {Int} row The row index
    * @param {Int} col The col index
    * @param {Ext.data.Store} ds The resource store
    * @param {Date} startDate The start date of the cell
    * @param {Date} endDate The end date of the cell
    */
    timeCellRenderer: null,

    /**
    * @cfg {Object} timeCellRendererScope The scope to use for the `timeCellRenderer` function 
    */
    timeCellRendererScope: null,
    

   
    inheritables: function() {
        return {
            // Configuring underlying table panel
            columnLines: true,
            enableColumnMove: false,
            enableLocking : true,
            lockable : true,
            // EOF: Configuring underlying table panel

            lockedXType: null,
            normalXType: null,

            // private
            initComponent: function () {
                // If user is not using timeCellRenderer, try to speed things up a bit
                this.lightWeight = this.lightWeight && !this.timeCellRenderer;
                
                this.addEvents(

                /** 
                * @event timeheaderdblclick
                * Fires after a doubleclick on a time header cell
                * @param {Sch.column.Time} column The column object
                * @param {Date} startDate The start date of the header cell
                * @param {Date} endDate The start date of the header cell
                * @param {Ext.EventObject} e The event object
                */
                    'timeheaderdblclick',

                /**
                * @event beforeviewchange
                * Fires before the current view changes to a new view type or a new time span. Return false to abort this action.
                * @param {Sch.mixin.SchedulerPanel} scheduler The scheduler object
                * @param {Object} preset The new preset
                */
                    'beforeviewchange',

                /**
                * @event viewchange
                * Fires after current view preset or time span has changed
                * @param {Sch.mixin.SchedulerPanel} scheduler The scheduler object
                */
                    'viewchange'
                );

                if (!this.timeAxis) {
                    this.timeAxis = Ext.create("Sch.data.TimeAxis");
                }

                if (!this.columns && !this.colModel) {
                    // No columns specified at all, fall back to empty array
                    this.columns = [];
                }

                if (this.enableLocking) {
                    
                    this.self.mixin('lockable', Sch.mixin.Lockable);
                    var i = 0,
                        len = this.columns.length,
                        column;

                    for (; i < len; ++i) {
                        column = this.columns[i];
                        if (column.locked !== false) {
                            column.locked = true;
                        }
                    }
                    this.timeAxis.on('reconfigure', this.onTimeAxisReconfigure, this);
                    this.switchViewPreset(this.viewPreset, this.startDate, this.endDate, true);
                }

                this.callParent(arguments);

                // HACK - too early to call 'applyViewSettings' in the 'switchViewPreset' before calling parent's `initComponent` - requires a view presence
                
                if (this.lockable) {
                    this.applyViewSettings(this.timeAxis.preset);
                    if (!this.viewPreset) {
                        throw 'You must define a valid view preset object. See Sch.preset.Manager class for reference';
                    }

                    if (this.lightWeight && this.columnLines) {
                        this.columnLinesFeature = new Sch.feature.ColumnLines();
                        this.columnLinesFeature.init(this);
                    }
                }

                this.relayEvents(this.getView(), [
                /**
                * @event beforetooltipshow
                * Fires before the event tooltip is shown, return false to suppress it.
                * @param {Sch.mixin.SchedulerPanel} scheduler The scheduler object
                * @param {Ext.data.Model} eventRecord The event record of the clicked record
                */
                    'beforetooltipshow',

                /**
                * @event scheduleclick
                * Fires after a click on the schedule area
                * @param {Sch.mixin.SchedulerPanel} scheduler The scheduler object
                * @param {Date} clickedDate The clicked date 
                * @param {Int} rowIndex The row index 
                * @param {Ext.EventObject} e The event object
                */
                    'scheduleclick',

                /**
                * @event scheduledblclick
                * Fires after a doubleclick on the schedule area
                * @param {Sch.mixin.SchedulerPanel} scheduler The scheduler object
                * @param {Date} clickedDate The clicked date 
                * @param {Int} rowIndex The row index 
                * @param {Ext.EventObject} e The event object
                */
                    'scheduledblclick',

                /**
                * @event schedulecontextmenu
                * Fires after a context menu click on the schedule area
                * @param {Sch.mixin.SchedulerPanel} scheduler The scheduler object
                * @param {Date} clickedDate The clicked date 
                * @param {Int} rowIndex The row index 
                * @param {Ext.EventObject} e The event object
                */
                    'schedulecontextmenu'
                ]);
            },

            initStateEvents: function () {
                this.stateEvents.push('viewchange');
                this.callParent();
            },

            getState: function () {
                var me = this,
                    state = me.callParent(arguments);

                Ext.apply(state, {
                    viewPreset: me.viewPreset,
                    startDate: me.getStart(),
                    endDate: me.getEnd()
                });
                return state;
            },

            applyState: function (state) {
                var me = this;

                me.callParent(arguments);

                if (state && state.viewPreset) {
                    me.switchViewPreset(state.viewPreset, state.startDate, state.endDate);
                }
            },

            beforeRender: function () {
                this.callParent(arguments);
                
                if (this.lockable) {
                    this.addCls('sch-' + this.orientation);
                }
            },

            afterRender: function () {
                this.callParent(arguments);
                if(this.lockable){
                    this.lockedGrid.on('itemdblclick', function(grid, record, el, rowIndex, event){
                        if(this.orientation == 'vertical' && record) {
                            this.fireEvent('timeheaderdblclick', this, record.get('start'), record.get('end'), rowIndex, event);
                        }
                    }, this);
                } else {
                    var header = this.headerCt;

                    if (header && header.reorderer && header.reorderer.dropZone) {
                        var dz = header.reorderer.dropZone;
                        dz.positionIndicator = Ext.Function.createSequence(dz.positionIndicator, function () {
                            this.valid = false;
                        });
                    }
                }
            },
            
            
            // this fixed the column width change case
            // when syncing the scroll position need to read the scrollLeft at the time of actual sync, not before 
            delayScroll: function(){
                var target = this.getScrollTarget().el;
                
                if (target) {
                    this.scrollTask.delay(10, function () {
                        
                        if (target.dom) {
                            this.syncHorizontalScroll(target.dom.scrollLeft);
                        }
                    }, this);
                }
            }
        };
    },

    /**
    * The {@link #readOnly} accessor. Use it to switch the `readonly` state. 
    */
    setReadOnly: function (readOnly) {
        this.getSchedulingView().setReadOnly(readOnly);
    },

    /**
    * Returns true if the panel is currently readOnly.
    * @return {Boolean} readOnly 
    */
    isReadOnly: function () {
        return this.getSchedulingView().isReadOnly();
    },

    /**
    * Switches the current header preset. See the {@link Sch.preset.Manager} for details. Will fire the {@link #beforeviewchange} event.
    * Returning `false` from the listener will cancel the switch. 
    * 
    * @param {String} preset The name of the new preset
    * @param {Date} startDate (optional) A new start date for the time axis
    * @param {Date} endDate (optional) A new end date for the time axis
    */
    switchViewPreset: function (preset, startDate, endDate, initial) {
        if (this.fireEvent('beforeviewchange', this, preset, startDate, endDate) !== false) {
            if (Ext.isString(preset)) {
                this.viewPreset = preset;
                preset = Sch.preset.Manager.getPreset(preset);
            }

            if (!preset) {
                throw 'View preset not found';
            }

            var hConf = preset.headerConfig;

            var timeAxisCfg = {
                unit: hConf.bottom ? hConf.bottom.unit : hConf.middle.unit,
                increment: (hConf.bottom ? hConf.bottom.increment : hConf.middle.increment) || 1,
                resolutionUnit: preset.timeResolution.unit,
                resolutionIncrement: preset.timeResolution.increment,

                weekStartDay: this.weekStartDay,

                mainUnit: hConf.middle.unit,
                shiftUnit: preset.shiftUnit,

                headerConfig: preset.headerConfig,
                shiftIncrement: preset.shiftIncrement || 1,
                preset: preset,
                defaultSpan: preset.defaultSpan || 1
            };

            if (initial) {
                timeAxisCfg.start = startDate || new Date();
                timeAxisCfg.end = endDate;

            } else {
                timeAxisCfg.start = startDate || this.timeAxis.getStart();
                timeAxisCfg.end = endDate;
            }

            // HACK - need to adjust the height of headers after the preset change
            // Seems not required in 4.1.0
//            var normalGrid = this.normalGrid;

//            if (normalGrid && normalGrid.headerCt) {

//                normalGrid.headerCt.on('afterlayout', function () {
//                    var lockedHeaderCt = this.lockedGrid.headerCt;
//                    var normalHeaderCt = normalGrid.headerCt;

//                    lockedHeaderCt.setSize(lockedHeaderCt.lastBox.width, normalHeaderCt.lastBox.height);
//                }, this, { single: true });
//            }
            // EOF HACK

            // Apply view specific properties to the view
            if (!initial) {
                this.applyViewSettings(preset); // Subclass may decide which property from the preset to use (orientation specific)
            }
            this.timeAxis.reconfigure(timeAxisCfg);
        }
    },

    // Applies view specific settings from the preset about to be used
    applyViewSettings: function (preset) {
        var view = this.getSchedulingView();
        
        view.setDisplayDateFormat(preset.displayDateFormat);

        if (this.orientation === 'horizontal') {
            view.setRowHeight(this.rowHeight || preset.rowHeight, true);
        }
    },

    /**
    * Method to get a the current start date of the scheduler view
    * @return {Date} The start date
    */
    getStart: function () {
        return this.timeAxis.getStart();
    },

    /**
    * Method to get a the current end date of the scheduler view
    * @return {Date} The end date
    */
    getEnd: function () {
        return this.timeAxis.getEnd();
    },

    /**
    * Updates the widths of all time columns to the supplied value. Only applicable when forceFit is set to false on the view.
    * @param {Int} width The new time column width
    */
    setTimeColumnWidth: function (width, preventRefresh) {
        this.getSchedulingView().setColumnWidth(width, preventRefresh);
    },

    // private
    onTimeAxisReconfigure: function () {
        this.fireEvent('viewchange', this);
    },

    /**
    * Moves the time axis forward in time in units specified by the view preset 'shiftUnit', and by the amount specified by the parameter or by the shiftIncrement config of the current view preset.
    * @param {Int} amount (optional) The number of units to jump forward
    */
    shiftNext: function (amount) {
        this.timeAxis.shiftNext(amount);
    },

    /**
    * Moves the time axis backward in time in units specified by the view preset 'shiftUnit', and by the amount specified by the parameter or by the shiftIncrement config of the current view preset.
    * @param {Int} amount (optional) The number of units to jump backward
    */
    shiftPrevious: function (amount) {
        this.timeAxis.shiftPrevious(amount);
    },

    /**
    * Convenience method to go to current date.
    */
    goToNow: function () {
        this.setTimeSpan(new Date());
    },

    /**
    * Changes the time axis timespan to the supplied start and end dates.
    * @param {Date} start The new start date
    * @param {Date} end (Optional) The new end date. If not supplied, the {@link Sch.preset.ViewPreset#defaultSpan} property of the current view preset will be used to calculate the new end date.
    */
    setTimeSpan: function (start, end) {
        if (this.timeAxis) {
            this.timeAxis.setTimeSpan(start, end);
        }
    },

    /**
    * Changes the time axis start date to the supplied date.
    * @param {Date} amount The new start date
    */
    setStart: function (date) {
        this.setTimeSpan(date);
    },

    /**
    * Changes the time end start date to the supplied date.
    * @param {Date} amount The new end date
    */
    setEnd: function (date) {
        this.setTimeSpan(null, date);
    },

    /**
    * Returns the {@link Sch.data.TimeAxis} instance in use.
    */
    getTimeAxis: function () {
        return this.timeAxis;
    },

    // DEPRECATED
    getResourceByEventRecord: function (eventRecord) {
        return eventRecord.getResource();
    },


    /**
    * Scrolls the time line to the specified `date`.
    * @param {Date} date The date to which to scroll the time line
    */
    scrollToDate: function (date, animate) {
        var view = this.getSchedulingView();
        var xy = view.getXYFromDate(date, true);
        
        if(this.orientation == 'horizontal'){
            view.getEl().scrollTo('left', Math.max(0, xy[0]), animate);
        }
        else {
            view.getEl().scrollTo('top', Math.max(0,  xy[1]), animate);
        }
    },


    /**
    * Returns the view of the scheduler part with time columns. This method should be used instead of usual `getView`, 
    * because `getView` will return an instance of special "locking" view, which has no any scheduler-specific features.
    * 
    * @return {Sch.mixin.SchedulerView} view A view implementing the {@link Sch.mixin.SchedulerView} mixin
    */
    getSchedulingView: function () {
        return this.lockable ? this.normalGrid.getView() : this.getView();
    },


    setOrientation: function (orientation) {
        this.removeCls('sch-' + this.orientation);
        this.addCls('sch-' + orientation);

        this.orientation = orientation;
    }
});
/**

@class Sch.panel.TimelineTreePanel
@extends Ext.tree.Panel
@mixin Sch.mixin.TimelinePanel

Internal class.

*/
Ext.define("Sch.panel.TimelineTreePanel", {
    extend      : "Ext.tree.Panel",
    requires    : ['Ext.data.TreeStore'], 
    mixins      : ['Sch.mixin.TimelinePanel'],
    
    useArrows       : true,
    rootVisible : false,

    constructor : function(config) {
        config = config || {};
        config.animate = false;
        this.callParent(arguments);
    },

    initComponent : function() {
        this.callParent(arguments);

        if (this.lockable && this.lockedGrid.headerCt.query('treecolumn').length === 0) {
            Ext.Error.raise("You must define an Ext.tree.Column (or use xtype : 'treecolumn').");
        }
    },

    // TreePanel does not support locked columns
    onRootChange: function(root) {
        if (!this.lockable) {
            this.callParent(arguments);
        }
    }
}, function() { 
    this.override(Sch.mixin.TimelinePanel.prototype.inheritables() || {});
});
/**
@class Sch.plugin.Printable

Plugin for printing an Ext Scheduler instance.

To use this plugin, add it to scheduler as usual. The plugin will add an additional `print` method to the scheduler:

        var scheduler = Ext.create('Sch.panel.SchedulerGrid', {
            ...
    
            resourceStore   : resourceStore,
            eventStore      : eventStore,
            
            plugins         : [
                Ext.create('Sch.plugin.Printable', { 
                    // default values
                    docType             : '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">',
                    autoPrintAndClose   : true
                })
            ]
        });
        
        ...
        
        scheduler.print();
        

*/
Ext.define("Sch.plugin.Printable", {
    
    /**
     * @cfg {String} docType This is the DOCTYPE to use for the print window. It should be the same DOCTYPE as on your application page.
     */
    docType             : '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">',
    
    /**
     * @cfg {Ext.Template} printableEventTpl Empty by default, but you can override this to use a custom event template used for printing.
     * This way you can make sure background-colors and icons are printed the way you want.
     */
    printableEventTpl   : null,
    
    /**
     * An empty function by default, but provided so that you can perform a custom action
     * before the print plugin extracts data from the scheduler.
     * @param {SchedulerPanel} scheduler The scheduler instance
     * @method beforePrint
     */
    beforePrint         : Ext.emptyFn, 
    
    /**
     * An empty function by default, but provided so that you can perform a custom action
     * after the print plugin has extracted the data from the scheduler.
     * @param {SchedulerPanel} scheduler The scheduler instance
     * @method afterPrint
     */
    afterPrint          : Ext.emptyFn, 

    /**
     * @cfg {Boolean} autoPrintAndClose True to automatically call print and close the new window after printing. Default value is `true`
     */
    autoPrintAndClose   : true,

     /**
     * @cfg {Boolean} fakeBackgroundColor True to reset background-color of events and enable use of border-width to fake background color (borders print by default in every browser). Default value is `true`
     */
    fakeBackgroundColor : true,

    scheduler           : null,
    
    
    constructor : function(config) {
        Ext.apply(this, config);
    },
    
    init : function(scheduler) {
        this.scheduler = scheduler;
        scheduler.print = Ext.Function.bind(this.print, this);
    },
    
    // private, the template for the new window
    mainTpl : '{docType}' +
          '<html class="x-border-box {htmlClasses}">' +
            '<head>' +
              '<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />' +
              '<title>{title}</title>' +
              '{styles}' +
            '</head>' +
            '<body class="sch-print-body {bodyClasses}">'+
                '<div class="sch-print-ct {componentClasses}" style="width:{totalWidth}px">'+
                    '<div class="sch-print-headerbg" style="border-left-width:{totalWidth}px;height:{headerHeight}px;"></div>'+
                    '<div class="sch-print-header-wrap">' +
                        '<div class="sch-print-lockedheader x-grid-header-ct x-grid-header-ct-default x-docked x-docked-top x-grid-header-ct-docked-top x-grid-header-ct-default-docked-top x-box-layout-ct x-docked-noborder-top x-docked-noborder-right x-docked-noborder-left">' +
                            '{lockedHeader}' +
                        '</div>'+
                        '<div style="left:{lockedWidth}px" class="sch-print-normalheader x-grid-header-ct x-grid-header-ct-default x-docked x-docked-top x-grid-header-ct-docked-top x-grid-header-ct-default-docked-top x-box-layout-ct x-docked-noborder-top x-docked-noborder-right x-docked-noborder-left">' +
                            '{normalHeader}' +
                        '</div>' +
                    '</div>'+
                    '<div id="lockedRowsCt" style="width:{lockedWidth}px;top:{headerHeight}px;" class="sch-print-locked-rows-ct {innerLockedClasses} x-grid-inner-locked">' + 
                        '{lockedRows}' +
                    '</div>'+
                    '<div id="normalRowsCt" style="left:{[Ext.isIE ? values.lockedWidth : 0]}px;top:{headerHeight}px;width:{normalWidth}px" class="sch-print-normal-rows-ct {innerNormalClasses}">' + 
                        '{normalRows}' +
                    '</div>'+
                '</div>' +
                '<script type="text/javascript">'+
                    '{setupScript}'+ 
                '</script>'+
            '</body>'+
          '</html>',
    
    // private
    getGridContent : function(component) {
        var normalGrid = component.normalGrid,
            lockedGrid = component.lockedGrid,
            lockedView = lockedGrid.getView(),
            normalView = normalGrid.getView(),
            header, lockedRows, normalRows;
        
        this.beforePrint(component);
        
        // Render rows
        var records = lockedView.store.getRange();
        lockedRows = lockedView.tpl.apply(lockedView.collectData(records, 0));
        normalRows = normalView.tpl.apply(normalView.collectData(records, 0));
 
        this.afterPrint(component);
        
        return {
            normalHeader : normalGrid.headerCt.el.dom.innerHTML,
            lockedHeader : lockedGrid.headerCt.el.dom.innerHTML,
            lockedRows : lockedRows,
            normalRows : normalRows,
            lockedWidth : lockedGrid.getWidth(),
            normalWidth : normalGrid.getWidth(),
            headerHeight : normalGrid.headerCt.getHeight(),
            innerLockedClasses : lockedGrid.view.el.dom.className,
            innerNormalClasses : normalGrid.view.el.dom.className + (this.fakeBackgroundColor ? ' sch-print-fake-background' : ''),
            width : component.getWidth()
        };
    },
    
    getStylesheets : function() {
        return Ext.getDoc().select('link[rel="stylesheet"]');
    },
    
    /**
     * Prints a scheduler panel. This method will be aliased to the main scheduler instance, so you can call it directly:
     * 
     *      scheduler.print()
     */
    print : function() {
        var component = this.scheduler;

        if (!(this.mainTpl instanceof Ext.Template)) {
            // Compile the tpl upon first call
            var headerRowHeight = 22;

            this.mainTpl = Ext.create("Ext.XTemplate", this.mainTpl, {
                compiled : true,
                disableFormats : true
            });
        }
    
        var v = component.getView(),
            styles = this.getStylesheets(),
            ctTmp = Ext.get(Ext.core.DomHelper.createDom({
                tag : 'div'
            })),
            styleFragment; 
        
        styles.each(function(s) {
            ctTmp.appendChild(s.dom.cloneNode(true));
        });
        
        styleFragment = ctTmp.dom.innerHTML + '';
        
        var gridContent = this.getGridContent(component),
            html = this.mainTpl.apply(Ext.apply({
                waitText : this.waitText,
                docType : this.docType,
                htmlClasses : '', // todo
                bodyClasses : Ext.getBody().dom.className,
                componentClasses : component.el.dom.className,
                title : (component.title || ''),
                styles : styleFragment,
                totalWidth : component.getWidth(),
                setupScript : "(" + this.setupScript.toString() + ")();"
            }, gridContent));
        
        var win = window.open('', 'printgrid');
    
        win.document.write(html);
        win.document.close();
        
        if (this.autoPrintAndClose) {
            win.print();
            // Chrome cannot print the page if you close the window being printed
            if (!Ext.isChrome) {
                win.close();
            }
        }
    },

    // Script executed in the newly open window, to sync row heights
    setupScript : function() {
                
        var lockedTableCt = document.getElementById('lockedRowsCt'),
            normalTableCt = document.getElementById('normalRowsCt'),
            lockedRows = lockedTableCt.getElementsByTagName('tr'),
            normalRows = normalTableCt.getElementsByTagName('tr'),
            count = normalRows.length,
            i = 0;
        for (; i < count; i++) {
            lockedRows[i].style.height = normalRows[i].style.height;
        }
    }
});

Ext.define('Gnt.model.WeekAvailability', {
    extend  : 'Sch.model.Range',
    
    customizableFields     : [
        { name : 'Availability' }
    ],    
    
    availabilityField   : 'Availability',

    set : function(field, value) {
        if (field === this.nameField) {
            Ext.Array.each(this.getAvailability(), function(weekDay){
                weekDay.setName(value);
            });
        }

        this.callParent(arguments);
    },

    getAvailability : function() {
        return this.get(this.availabilityField) || [];
    },

    setAvailability : function(availability) {
        var name = this.getName();
        
        Ext.Array.each(availability, function(weekDay){
            weekDay.setName(name);
        });

        this.set(this.availabilityField, availability);
    }
});
/**

@class Gnt.model.CalendarDay
@extends Sch.model.Customizable

A model representing a single day in the calendar. Day may be a concrete day per se (2012/01/01),  
a certain weekday (all Thursdays), or an override for all certain weekdays in the timeframe 
(all Fridays between 2012/01/01 - 2012/01/15, inclusive).

* **Please note, that the hourly availbility feature is experimental and the requirements for `Id` field is likely to change in the future releases**

A collection of this models is supposed to be provided for the {@link Gnt.data.Calendar calendar}   

Fields
------

- `Id`   - The id of the date. It is not an arbitrary unique value. In case of "normal" days - it should be a value of `Date` field (with cleared time information),
   converted to a number of milliseconds since the Epoch. In case of "weekday overrides" it should be a string in the following format:
   
        3-2012/02/08-2012/02/29
   the leading digit is weekday index (0 - Sunday, 1 - Monday and so on) and the dates define the timeframe this override is valid for.     
    
- `Date` - the date for this day in the ISO 8601 format. Any time information in this field will be cleared. If this instance 
  represents a weekday override, this field will be ignored. 
- `Name` - optional name of the day (holiday name for example)
- `IsWorkingDay` - optional boolean flag, allowing you to specify the exceptions - working days which falls on the weekends. Default value is `false`
- `Cls` - optional name of the CSS class, which can be used by various plugins working with weekends and holidays. Default value is `gnt-holiday`
If some holidays lasts for several days, then all days should have the same `Cls` value.
- `Availability` - should be an array of strings, containing the hourly availability for this day. Strings should have the following format:

        // two working intervals 
        [ '08:00-12:00', '13:00-17:00' ]
    
        // whole 24 hours are available 
        [ '00:00-24:00' ]

The name of any field can be customized in the subclass. Please refer to {@link Sch.model.Customizable} for details.

*/


Ext.define('Gnt.model.CalendarDay', {
    
    requires    : [ 'Ext.data.Types' ], 
    
    extend      : 'Sch.model.Customizable',
    
    idProperty  : 'Id',
    
    customizableFields      : [
        /**
         * @method getDate
         * 
         * Returns the value of the `Date` field 
         * 
         * @return {Date} The date of this calendar day
         */
        { 
            name        : 'Date',
            type        : 'date',
            dateFormat  : 'c', 
            
            convert     : function (value, record) {
                if (!value) return;

                var converted   = Ext.data.Types.DATE.convert.call(this, value);
                
                if (converted) {
                    Ext.Date.clearTime(converted);
                }
                
                if (record.data[ record.idProperty ] == null) {
                    record.data[ record.idProperty ] = converted - 0;
                }
                
                return converted;
            } 
        },
        {
            name        : 'Id'
        },
        { name: 'IsWorkingDay', type: 'boolean', defaultValue : false },
        
        /**
         * @method getCls
         * 
         * Gets the "class" of the day
         * 
         * @return {String} cls The "class" of the day 
         */        
        /**
         * @method setCls
         * 
         * Sets the "class" of the day
         * 
         * @param {String} cls The new class of the day 
         */        
        {   
            name            : 'Cls',
            defaultValue    : 'gnt-holiday'
        },
        
        /**
         * @method getName
         * 
         * Gets the "name" of the day
         * 
         * @return {String} name The "name" of the day 
         */        
        /**
         * @method setName
         * 
         * Sets the "name" of the day
         * 
         * @param {String} name The new name of the day 
         */        
        'Name',
        
        // [ '08:00-12:00', '13:00-17:00' ]
        {
            name        : 'Availability',
            convert     : function (value, record) {
                if (value) {
                    return Ext.typeOf(value) === 'string' ? [ value ] : value;
                } else {
                    return [];
                }
            } 
        }
    ],
    
    availabilityCache   : null,
    
    /**
    * @cfg {String} dateField The name of the `Date` field.
    */ 
    dateField           : 'Date',
    
    /**
    * @cfg {String} isWorkingDayField The name of the `IsWorkingDay` field.
    */ 
    isWorkingDayField   : 'IsWorkingDay',
    
    /**
    * @cfg {String} clsField The name of the `Cls` field.
    */ 
    clsField            : 'Cls',
    
    
    /**
    * @cfg {String} nameField The name of the `Name` field.
    */ 
    nameField           : 'Name',

    /**
    * @cfg {String} availabilityField The name of the `Availability` field.
    */ 
    availabilityField   : 'Availability',
    
    
    /**
     * Set the date for this day (will clear the time part)
     * @param {Date} date
     */
    setDate : function (date) {
        var cleared         = Ext.Date.clearTime(date, true);
        
        this.data[ this.idProperty ] = cleared - 0;
        
        this.set(this.dateField, cleared);
    },
    
    /**
     * Clears the date for this day
     * @param {Date} date
     */
    clearDate : function () {
        this.data[ this.idProperty ] = null;
    },
    
    /**
     * @method getDate
     * 
     * Returns the date for this day (will clear the time part)
     * @return {Date}
     */
    

    /**
     * This method returns the availability of this day. By default it will decode the array of strings '08:00-12:00' to the
     * array of objects like:
     * 
            {
                startTime       : new Date(0, 0, 0, 8),
                endTime         : new Date(0, 0, 0, 12)
            }

     * You can pass the "asString" flag to disable that and just return strings.
     * 
     * @param {Boolean} asString Whether to just return an array of strings, instead of objects.
     * @return {[ Object/String ]} Array of objects with "startTime", "endTime" properties. 
     */
    getAvailability : function (asString) {
        var me      = this;
        
        if (asString) {
            // Return the raw availability array with strings
            return this.get(this.availabilityField);
        }

        if (this.availabilityCache) {
            return this.availabilityCache;
        }
        
        var parsed  = [];
        
        Ext.Array.each(this.get(this.availabilityField), function (value) {
            parsed.push(Ext.typeOf(value) === 'string' ? me.parseInterval(value) : value);
        });
    
        this.verifyAvailability(parsed);
            
        return this.availabilityCache = parsed;
    },
    
    
    /**
     * This method updates the availability information for this day. It accept an array of strings: '08:00-12:00', or
     * object like:
            
            {
                startTime       : new Date(0, 0, 0, 8),
                endTime         : new Date(0, 0, 0, 12)
            }
            
     * @param {Array[Object/String]} intervals Array of availability intervals
     */
    setAvailability : function (intervals) {
        // clear cache
        this.availabilityCache = null;
        
        this.set(this.availabilityField, this.stringifyIntervals(intervals));
        
        // to trigger the `verifyAvailability`
        this.getAvailability();
    },
    
    
    verifyAvailability : function (intervals) {
        intervals.sort(function (a, b) {
            return a.startTime - b.startTime;
        });
        
        Ext.Array.each(intervals, function (interval) {
            if (interval.startTime > interval.endTime) {
                throw "Start time is greater than end time";
            }
        });
        
        for (var i = 1; i < intervals.length; i++) {
            var prev        = intervals[ i - 1 ];
            var curr        = intervals[ i ];
            
            if (prev.endTime > curr.startTime) {
                throw "Availability intervals should not intersect";
            }
        }
    },
    
    
    prependZero : function (value) {
        return value < 10 ? '0' + value : value;
    },
    
    
    stringifyInterval : function (interval) {
        var startTime   = interval.startTime;
        var endTime     = interval.endTime;
        
        return this.prependZero(startTime.getHours()) + ':' + this.prependZero(startTime.getMinutes()) + '-' +
            this.prependZero(endTime.getHours()) + ':' + this.prependZero(endTime.getMinutes());
    },
    
    
    stringifyIntervals : function (intervals) {
        var me                  = this;
        var result              = [];
        
        Ext.Array.each(intervals, function (interval) {
            if (Ext.typeOf(interval) === 'string') {
                result.push(interval);
            } else {
                result.push(me.stringifyInterval(interval));
            }
        });
        
        return result;
    },
    
    
    parseInterval : function (string) {
        var match   = /(\d\d):(\d\d)-(\d\d):(\d\d)/.exec(string);
        
        if (!match) throw "Invalid format for availability string: " + string + ". It should have exact format: hh:mm-hh:mm";
        
        return {
            startTime       : new Date(0, 0, 0, match[ 1 ], match[ 2 ]),
            endTime         : new Date(0, 0, 0, match[ 3 ], match[ 4 ])
        };
    },
    
    
    /**
     * Return the total length of all availability intervals for this day in hours.
     * 
     * @return {Number} 
     */
    getTotalHours : function () {
        return this.getTotalMS() / 1000 / 60 / 60;
    },
    
    
    /**
     * Return the total length of all availability intervals for this day in milliseconds.
     * 
     * @return {Number} 
     */
    getTotalMS : function () {
        var totalMS      = 0;
        
        Ext.Array.each(this.getAvailability(), function (interval) {
            totalMS      += interval.endTime - interval.startTime;
        });
        
        return totalMS;
    },
    
    
    /**
     * Adds a new availability interval to this day. Both arguments should have the same format.
     * 
     * @param {Date/String} startTime Start time of the interval. Can be a Date object (new Date(0, 0, 0, 8)) or just a plain string: '08'
     * @param {Date/String} endTime End time of the interval. Can be a Date object (new Date(0, 0, 0, 12)) or just a plain string: '12'
     */
    addAvailabilityInterval : function (startTime, endTime) {
        var interval;
        
        if (startTime instanceof Date) {
            interval        = {
                startTime       : startTime,
                endTime         : endTime
            };
        } else {
            interval        = this.parseInterval(startTime + (endTime ? '-' + endTime : ''));
        }
            
        var intervals       = this.getAvailability().concat(interval);
        
        this.verifyAvailability(intervals);
        
        this.setAvailability(intervals);
    },
    
    
    /**
     * Removes the availability interval by its index.
     * 
     * @param {Number} index Ordinal position of the interval to be removed
     */
    removeAvailbilityInterval : function (index) {
        var intervals       = this.getAvailability();
        
        intervals.splice(index, 1);
        
        this.setAvailability(intervals);
    },
    
    
    /**
     * Applies the availability intervals to a concrete day. For example the availability intervals [ '08:00-12:00', '13:00-17:00' ],
     * applied to a day 2012/01/01 will return the following result:
     * 
    [
        {
            startDate       : new Date(2012, 0, 1, 8),
            endDate         : new Date(2012, 0, 1, 12)
        },
        {
            startDate       : new Date(2012, 0, 1, 13),
            endDate         : new Date(2012, 0, 1, 17)
        }
    ]

     * 
     * @param {Date} date The date to apply the intervals to
     * 
     * @returns {Array[ Object ]} Array of objects with "startDate / endDate" properties.
     */
    getAvailabilityIntervalsFor : function (timeDate) {
        timeDate                = typeof timeDate == 'number' ? new Date(timeDate) : timeDate;
        
        var year                = timeDate.getFullYear();
        var month               = timeDate.getMonth();
        var date                = timeDate.getDate();
        
        var result              = [];
        
        Ext.Array.each(this.getAvailability(), function (interval) {
            
            var endDate     = interval.endTime.getDate();
            
            result.push({
                startDate       : new Date(year, month, date, interval.startTime.getHours(), interval.startTime.getMinutes()),
                endDate         : new Date(year, month, date + (endDate == 1 ? 1 : 0), interval.endTime.getHours(), interval.endTime.getMinutes())
            });
        });
        
        return result;
    },
    
    
    /**
     * Returns the earliest available time for the given date. If this day has no availability intervals for this day, returns `null`.
     * 
     * @param {Date} date A date to get the earliest availability time for.
     * 
     * @return {Date}
     */
    getAvailabilityStartFor : function (timeDate) {
        var intervals           = this.getAvailabilityIntervalsFor(timeDate);
        
        if (!intervals.length) {
            return null;
        }
        
        return intervals[ 0 ].startDate;
    },
    
    
    /**
     * Returns the latest available time for the given date. If this day has no availability intervals for this day, returns `null`.
     * 
     * @param {Date} date A date to get the latest availability time for.
     * 
     * @return {Date}
     */
    getAvailabilityEndFor : function (timeDate) {
        var intervals           = this.getAvailabilityIntervalsFor(timeDate);
        
        if (!intervals.length) {
            return null;
        }
        
        return intervals[ intervals.length - 1 ].endDate;
    }

});

/**

@class Gnt.model.Assignment
@extends Sch.model.Customizable

This class represent a single assignment of resource to task in your gantt chart. Its a subclass of the {@link Sch.model.Customizable}, which is in turn subclass of {@link Ext.data.Model}.
Please refer to documentation of those classes to become familar with the base interface of this class.

Assignment has the following fields:

- `Id` - The id of the assignment itself
- `ResourceId` - The id of the resource which is being assigned to task  
- `TaskId` - The id of the task to which the resource is being assigned
- `Units` - The integer value, representing the how much of resource's availability will be dedicated to this task

The name of any field can be customized in the subclass. Please refer to {@link Sch.model.Customizable} for details.

See also: {@link Gnt.column.ResourceAssignment}

*/


Ext.define('Gnt.model.Assignment', {
    extend  : 'Sch.model.Customizable',
    
    idProperty : 'Id',
    
    customizableFields  : [
        { name : 'Id' },
        
        
        { name : 'ResourceId' },
        { name : 'TaskId' },
        { name : 'Units', type : 'float', defaultValue : 100 }
    ],    

    /**
    * @cfg {String} resourceIdField The name of the field identifying the resource to which an assignment belongs. Defaults to "ResourceId".
    */ 
    resourceIdField         : 'ResourceId',
    
    /**
    * @cfg {String} taskIdField The name of the field identifying the task to which an event belongs. Defaults to "TaskId".
    */ 
    taskIdField             : 'TaskId',
    
    /**
    * @cfg {String} unitsField The name of the field identifying the units of this assignment. Defaults to "Units".
    */ 
    unitsField              : 'Units',
    
    /**
     * Returns true if the Assignment can be persisted (e.g. task and resource are not 'phantoms')
     * 
     * @return {Boolean} true if this model can be persisted to server.
     */
    isPersistable : function() {
        var task        = this.getTask(),
            resource    = this.getResource();

        return task && !task.phantom && resource && !resource.phantom;
    },


    /**
     * Returns the units of this assignment
     * 
     * @return {Number} units
     */
    getUnits : function () {
        // constrain to be >= 0
        return Math.max(0, this.get(this.unitsField));
    },
    
    
    /**
     * Sets the units of this assignment
     * 
     * @param {Number} value The new value for units
     */        
    setUnits : function (value) {
        if (value < 0) throw "`Units` value for assignment can't be less than 0";
        
        this.set(this.unitsField, value);
    },
    

    /**
     * Convenience method for returning the name of the associated resource.
     * 
     * @return {String} name
     */
    getResourceName : function() {
        var resource = this.stores[ 0 ].getResourceStore().getById(this.getResourceId());
        
        if (resource) {
            return resource.getName();
        }

        return '';
    },

    
    /**
     * Returns the task associated with this assignment.
     * 
     * @return {Gnt.model.Task} Instance of task
     * @method getTask
     */
    /** @ignore */
    getTask: function (taskStore) {
        // removed assignment will not have "this.stores" so we are providing a way to get the task via provided taskStore
        return (taskStore || this.stores[ 0 ].getTaskStore()).getById(this.getTaskId());    
    },

    
    /**
     * Returns the resource associated with this assignment.
     * 
     * @return {Gnt.model.Resource} Instance of resource
     */
    getResource: function(){
        return this.stores[ 0 ].getResourceStore().getByInternalId(this.getResourceId());
    },
    
    // We'll be using `internalId` for Id substitution when dealing with phantom records
    getInternalId: function(){
        return this.getId() || this.internalId;
    }
});
/**

@class Gnt.model.Dependency
@extends Sch.model.Customizable

This class represents a single Dependency in your gantt chart. Its a subclass of the {@link Sch.model.Customizable}, which is in turn subclass of {@link Ext.data.Model}.
Please refer to documentation of those classes to become familar with the base interface of this class.

A Dependency has the following fields:

- `Id` - The id of the dependency itself
- `From` - The id of the task at which the dependency starts  
- `To` - The id of the task at which the dependency ends
- `Lag` - An integer constant specifying the lag between the tasks, in days
- `Cls` - A CSS class that will be applied to each rendered dependency DOM element
- `Type` - An integer constant representing the type of the dependency:
    - 0 - start-to-start dependency
    - 1 - start-to-end dependency
    - 2 - end-to-start dependency
    - 3 - end-to-end dependency

Subclassing the Dependency class
--------------------

The name of any field can be customized in the subclass, see the example below. Please also refer to {@link Sch.model.Customizable} for details.

    Ext.define('MyProject.model.Dependency', {
        extend      : 'Gnt.model.Dependency',
        
        toField     : 'targetId', 
        fromField   : 'sourceId', 

        ...
    })

*/

Ext.define('Gnt.model.Dependency', {
    extend              : 'Sch.model.Customizable',
    
    inheritableStatics  : {
        Type    : {
            StartToStart    : 0,
            StartToEnd      : 1,
            EndToStart      : 2,
            EndToEnd        : 3
        }
    },
    
    idProperty          : 'Id',
    
    customizableFields     : [
        { name : 'Id' },

        // 3 mandatory fields
        { name: 'From' },
        { name: 'To' },
        { name: 'Type', type : 'int', defaultValue : 2},

        { name: 'Lag', type : 'int', defaultValue : 0},
        { name: 'Cls'}
    ],

    /**
    * @cfg {String} fromField The name of the field that contains the id of the source task.
    */ 
    fromField  : 'From',
    
    /**
    * @cfg {String} toField The name of the field that contains the id of the target task.
    */
    toField    : 'To',
    
    /**
    * @cfg {String} typeField The name of the field that contains the dependency type.
    */
    typeField       : 'Type',

    /**
    * @cfg {String} lagField The name of the field that contains the lag amount.
    */
    lagField       : 'Lag',

    /**
    * @cfg {String} clsField The name of the field that contains a CSS class that will be added to the rendered dependency elements.
    */
    clsField       : 'Cls',
    
    
    constructor : function(config) {
        this.callParent(arguments);
        
        if (config) {
            if (config.fromTask) {
                if (config.fromTask instanceof Gnt.model.Task) {
                    this.setSourceTask(config.fromTask);
                } else {
                    this.setSourceId(config.fromTask);
                }
            }

            if (config.toTask) {
                if (config.toTask instanceof Gnt.model.Task) {
                    this.setTargetTask(config.toTask);
                } else {
                    this.setTargetId(config.toTask);
                }
            }

            if (Ext.isDefined(config.type)) {
                this.setType(config.type);
            }
        }
    },
    

    getTaskStore : function() {
        return this.stores[0].taskStore;
    },

    /**
    * Returns the source task of the dependency
    * @return {Gnt.model.Task} The source task of this dependency
    */
    getSourceTask : function(taskStore) {
        return this.getTaskStore().getById(this.getSourceId());
    },

    /**
    * Sets the source task of the dependency
    * @param {Gnt.model.Task} task The new source task of this dependency
    */
    setSourceTask : function(task) {
        this.setSourceId(task.getId() || task.internalId);
    },

    /**
    * Returns the target task of the dependency
    * @return {Gnt.model.Task} The target task of this dependency
    */
    getTargetTask : function() {
        return this.getTaskStore().getById(this.getTargetId());
    },

    /**
    * Sets the target task of the dependency
    * @param {Gnt.model.Task} task The new target task of this dependency
    */
    setTargetTask : function(task) {
        this.setTargetId(task.getId() || task.internalId);
    },

    /**
    * Returns the source task id of the dependency
    * @return {Mixed} The id of the source task for the dependency
    */
    getSourceId : function() {
        return this.get(this.fromField);
    },

    /**
    * Sets the source task id of the dependency
    * @param {Mixed} The id of the source task for the dependency
    */
    setSourceId : function(id) {
        this.set(this.fromField, id);
    },

    /**
    * Returns the target task id of the dependency
    * @return {Mixed} The id of the target task for the dependency
    */
    getTargetId : function() {
        return this.get(this.toField);
    },

    /**
    * Sets the target task id of the dependency
    * @param {Mixed} id The id of the target task for the dependency
    */
    setTargetId : function(id) {
        this.set(this.toField, id);
    },

    /**
    * @method getType
    * 
    * Returns the dependency type
    * @return {Mixed} The type of the dependency
    */

    /**
    * @method setType
    * 
    * Sets the dependency type
    * @param {Mixed} id The type of the dependency
    */

    /**
    * @method getLag
    * 
    * Returns the amount of lag for the dependency
    * @return {Int} id The amount of lag for the dependency
    */

    /**
    * @method setLag
    * 
    * Sets the amount of lag for the dependency
    * @param {Int} id The amount of lag for the dependency
    */

    /**
     * @method getCls
     * 
     * Returns the name of field holding the CSS class for each rendered dependency element
     * 
     * @return {String} The cls field
     */

    /**
     * Returns true if the linked tasks have been persisted (e.g. neither of them are 'phantoms')
     * 
     * @return {Boolean} true if this model can be persisted to server.
     */
    isPersistable : function() {
        var source = this.getSourceTask(),
            target = this.getTargetTask();

        return source && !source.phantom && target && !target.phantom;
    },

    
    /**
     * Returns `true` if the dependency is valid. Note, this method assumes that the model is part of a {@link Gnt.data.DependencyStore}.
     * Invalid dependencies are: 
     * - a task linking to itself
     * - a dependency between a child and one of its parent 
     * - transitive dependencies, e.g. if A -> B, B -> C, then A -> C is not valid 
     * 
     * @return {Boolean}
     */
    isValid : function (askStore) {
        var valid = this.callParent(arguments);
            
        if (valid && this.stores[ 0 ]) {
            valid = this.stores[ 0 ].isValidDependency(this.getSourceId(), this.getTargetId(), true);
        }

        return valid;
    }
});
/**

@class Gnt.model.Resource
@extends Sch.model.Resource

This class represents a single Resource in your gantt chart. 
The inheritance hierarchy of this class includes {@link Sch.model.Customizable} and {@link Ext.data.Model} classes.
Please refer to the documentation of those classes to become familar with the base interface of this class.

A Resource has only 2 mandatory fields - `Id` and `Name`. If you want to add some fields, describing resources - subclass this class:

    Ext.define('MyProject.model.Resource', {
        extend      : 'Gnt.model.Resource',
        
        fields      : [
            // `Id` and `Name` fields are already provided by the superclass
            { name: 'Company',          type : 'string' }
        ],
        
        getCompany : function () {
            return this.get('Company') 
        },
        ...
    })

The name of any field can be customized in the subclass. Please refer to {@link Sch.model.Customizable} for details.

See also: {@link Gnt.model.Assignment}, {@link Gnt.column.ResourceAssignment}

*/

Ext.define('Gnt.model.Resource', {
    extend      : 'Sch.model.Resource',
    
    customizableFields : [
        'CalendarId'
    ],
    
    /**
     * @cfg {String} calendarIdField The name of the field defining the id of the calendar for this specific resource.
     */
    calendarIdField         : 'CalendarId',
    
    getTaskStore : function () {
        return this.stores[ 0 ].getTaskStore();
    },

    getEventStore : function () {
        return this.getTaskStore();
    },
    
    /**
     * Returns an array of tasks associated with this resource 
     * @return {Array[Sch.model.Event]}
     */
    getEvents : function() {
        return this.getTasks();
    },

    /**
     * Returns an array of tasks associated with this resource 
     * @return {Array[Gnt.model.Task]}
     */
    getTasks : function() {
        var tasks = [];
        this.forEachAssignment(function(ass) { 
            var t = ass.getTask();
            if (t) {
                tasks.push(t); 
            }
        });
        return tasks;
    },

    
    /**
     * Returns the calendar, based on which is performed the schedule calculations for associated tasks.
     * It will be either the own calendar of this resource (if any) or the calendar of the whole project.
     * 
     * @param {Boolean} ownCalendar Pass `true` to return only own calendar. 
     * 
     * @return {Gnt.data.Calendar} The instance of calendar
     */ 
    getCalendar: function (ownCalendar) {
        var calendar    = this.getCalendarId();

        // our own calendar
        calendar        = calendar ? Gnt.data.Calendar.getCalendar(calendar) : null;
        
        if (ownCalendar || calendar) {
            return calendar;
        } 
        
        return this.stores[ 0 ].getTaskStore().getCalendar();
    },

    /*
    * TODO ADD DOCS
    */
    setCalendar: function (calendar) {
        // TODO IMPLEMENT
    },
    
    // We'll be using `internalId` for Id substitution when dealing with phantom records
    getInternalId : function () {
        return this.getId() || this.internalId;
    },
    
    
    /**
     * Assigns this resource to a given task. A new {@link Gnt.model.Assignment assignment} will be created
     * and added to the {@link Gnt.data.AssignmentStore} of the project.  
     * 
     * @param {Gnt.model.Task/Number} taskOrId Either instance of {@link Gnt.model.Task} or id of the task
     * @param {Number} units The value for the "Units" field
     */
    assignTo : function (taskOrId, units) {
        var task    = taskOrId instanceof Gnt.model.Task ? taskOrId : this.getTaskStore().getById(taskOrId);
        
        return task.assign(this, units);
    },
    
    
    unassignFrom : function () {
        return this.unAssignFrom.apply(this, arguments);
    },
    

    /**
     * Un assigns this resource from the given task. The corresponding {@link Gnt.model.Assignment assignment} record
     * will be removed from the {@link Gnt.data.AssignmentStore} of the project.
     * 
     * @param {Gnt.model.Task/Number} taskOrId Either instance of {@link Gnt.model.Task} or id of the task
     */
    unAssignFrom : function (taskOrId) {
        var task    = taskOrId instanceof Gnt.model.Task ? taskOrId : this.getTaskStore().getById(taskOrId);
        
        task.unAssign(this);
    },
    
    
    /**
     * Iterator for each assignment, associated with this resource.
     * 
     * @param {Function} func The function to call. This function will receive an {@link Gnt.model.Assignment assignment} instance
     * as the only argument
     * 
     * @param {Object} scope The scope to run the function in.
     */
    forEachAssignment : function (func, scope) {
        scope       = scope || this;
        
        var id      = this.getInternalId(); 
        
        this.getTaskStore().getAssignmentStore().each(function (assignment) {
            if (assignment.getResourceId() == id) {
                return func.call(scope, assignment);
            }
        });
    },
    
    
    collectAvailabilityIntervalPoints : function (intervals, getStartPoint, getEndPoint, pointsByTime, pointTimes) {
        for (var k = 0; k < intervals.length; k++) {
            var interval            = intervals[ k ];
            
            var intervalStartDate   = interval.startDate - 0;
            var intervalEndDate     = interval.endDate - 0;
            
            if (!pointsByTime[ intervalStartDate ]) {
                pointsByTime[ intervalStartDate ] = [];
                
                pointTimes.push(intervalStartDate);
            }
            
            pointsByTime[ intervalStartDate ].push(getStartPoint(intervalStartDate));
            
            
            if (!pointsByTime[ intervalEndDate ]) {
                pointsByTime[ intervalEndDate ] = [];
                
                pointTimes.push(intervalEndDate);
            }
            
            pointsByTime[ intervalEndDate ].push(getEndPoint(intervalEndDate));
        }
    },
    
    
    forEachAvailabilityIntervalWithTasks : function (options, func, scope) {
        scope                       = scope || this;
        
        var startDate               = options.startDate;
        var endDate                 = options.endDate;
        
        if (!startDate || !endDate) throw "Both `startDate` and `endDate` are required for `forEachAvailabilityIntervalWithTasks`";
        
        var cursorDate              = new Date(startDate);
        var includeAllIntervals     = options.includeAllIntervals;
                 
        var resourceCalendar        = this.getCalendar();
        
        var assignments             = [];
        var tasks                   = [];
        var tasksCalendars          = [];
        
        this.forEachAssignment(function (assignment) {
            var task        = assignment.getTask();
            
            // filter the tasks out of provided [ startDate, endDate ) interval
            if (task.getStartDate() > endDate || task.getEndDate() < startDate) return;
            
            tasks.push(task);
            tasksCalendars.push(task.getCalendar());
            
            assignments.push(assignment);
        });
        
        // if there are no tasks - then there are no common intervals naturally
        if (!tasks.length) return;
        
        var DATE            = Sch.util.Date;
        
        var pointTimes      = [ startDate - 0, endDate - 0 ];
        var pointsByTime    = {};
        
        pointsByTime[ startDate - 0 ]   = [ { type  : '00-intervalStart' } ];
        pointsByTime[ endDate - 0 ]     = [ { type  : '00-intervalEnd' } ];
        
        var i;
        
        while (cursorDate < endDate) {
            
            this.collectAvailabilityIntervalPoints(
                resourceCalendar.getAvailabilityIntervalsFor(cursorDate),
                function () {
                    return {
                        type    : '00-resourceAvailailabilityStart'
                    };
                },
                function () {
                    return {
                        type    : '01-resourceAvailailabilityEnd'
                    };
                },
                pointsByTime,
                pointTimes
            );
            
            // using "for" instead of "each" should be blazing fast! :)
            for (i = 0; i < tasksCalendars.length; i++) {
                
                this.collectAvailabilityIntervalPoints(
                    tasksCalendars[ i ].getAvailabilityIntervalsFor(cursorDate),
                    function () {
                        return {
                            type        : '02-taskAvailailabilityStart',
                            assignment  : assignments[ i ],
                            taskId      : tasks[ i ].getInternalId(),
                            units       : assignments[ i ].getUnits()
                        };
                    },
                    function () {
                        return {
                            type        : '03-taskAvailailabilityEnd',
                            taskId      : tasks[ i ].getInternalId()
                        };
                    },
                    pointsByTime,
                    pointTimes
                );
            }
            
            // does not perform cloning internally!
            cursorDate       = DATE.getStartOfNextDay(cursorDate);
        }
            
        pointTimes.sort();
        
        var inResource          = false;
        var currentAssignments  = {};
        var taskCounter         = 0;
        
        for (i = 0; i < pointTimes.length - 1; i++) {
            var points      = pointsByTime[ pointTimes[ i ] ];
            
            points.sort(function (a, b) {
                return a.type < b.type;
            });
            
            for (var k = 0; k < points.length; k++) {
                var point       = points[ k ];
                
                if (point.type == '00-resourceAvailailabilityStart') {
                    inResource      = true;
                }
                
                if (point.type == '01-resourceAvailailabilityEnd') {
                    inResource      = false;
                }
                
                if (point.type == '02-taskAvailailabilityStart') {
                    currentAssignments[ point.taskId ] = point;
                    taskCounter++;
                }
                
                if (point.type == '03-taskAvailailabilityEnd') {
                    delete currentAssignments[ point.taskId ];
                    taskCounter--;
                }
            }
            
            if (includeAllIntervals || inResource && taskCounter) {
                var intervalStartDate       = pointTimes[ i ];
                var intervalEndDate         = pointTimes[ i + 1 ];
                
                // availability interval is out of [ startDate, endDate )
                if (intervalStartDate > endDate || intervalEndDate < startDate) continue;
                
                if (intervalStartDate < startDate) intervalStartDate = startDate - 0;
                if (intervalEndDate > endDate) intervalEndDate = endDate - 0;
                
                if (func.call(scope, intervalStartDate, intervalEndDate, currentAssignments) === false) return false;
            }
        }
    },
    
    
    /**
     * This method will generate a report about the resource allocation in the given timeframe.
     * The start and end dates of the timeframe are provided as the "startDate/endDate" properties of the `options` parameter.
     * Options may also contain additional property: `includeAllIntervals` which includes the intervals w/o any
     * assignments in the ouput (see the example below).
     * 
     * For example, this resource `R1` has the availability from 10:00 till 17:00 on 2012/06/01 and from 12:00 till 15:00 on 2012/06/02.
     * It is also assigned on 50% to two tasks:
     * 
     * - `T1` has availability from 11:00 till 16:00 on 2012/06/01 and from 13:00 till 17:00 on 2012/06/02. 
     *   It starts at 11:00 2012/06/01 and ends at 17:00 2012/06/02
     * - `T2` has availability from 15:00 till 19:00 on 2012/06/01 and from 09:00 till 14:00 on 2012/06/02. 
     *   It starts at 15:00 2012/06/01 and ends at 14:00 2012/06/02
     * 
     * So the allocation information for the period 2012/06/01 - 2012/06/03 (note the 03 in day - it means 2012/06/02 inclusive)
     * will looks like the following (to better understand this example you might want to draw all the information on the paper):
     * 

    [
        {
            startDate       : new Date(2012, 5, 1, 11),
            endDate         : new Date(2012, 5, 1, 15),
            totalAllocation : 50,
            assignments     : [ assignmentForTask1 ] 
        },
        {
            startDate       : new Date(2012, 5, 1, 15),
            endDate         : new Date(2012, 5, 1, 16),
            totalAllocation : 100,
            assignments     : [ assignmentForTask1, assignmentForTask2 ] 
        },
        {
            startDate       : new Date(2012, 5, 1, 16),
            endDate         : new Date(2012, 5, 1, 17),
            totalAllocation : 50,
            assignments     : [ assignmentForTask2 ] 
        },
        {
            startDate       : new Date(2012, 5, 2, 12),
            endDate         : new Date(2012, 5, 2, 13),
            totalAllocation : 50,
            assignments     : [ assignmentForTask2 ] 
        },
        {
            startDate       : new Date(2012, 5, 2, 13),
            endDate         : new Date(2012, 5, 2, 14),
            totalAllocation : 100,
            assignments     : [ assignmentForTask1, assignmentForTask2 ] 
        },
        {
            startDate       : new Date(2012, 5, 2, 14),
            endDate         : new Date(2012, 5, 2, 15),
            totalAllocation : 50,
            assignments     : [ assignmentForTask1 ] 
        },
    ]

     * 
     * As you can see its quite detailed information - every distinct timeframe is included in the report.
     * You can aggregate this information as you need.
     * 
     * Setting the `includeAllIntervals` option to true, will include intervals w/o assignments in the report, so the in the 
     * example above, the report will start with:
     *

    [
        {
            startDate       : new Date(2012, 5, 1, 00),
            endDate         : new Date(2012, 5, 1, 11),
            totalAllocation : 0,
            assignments     : [] 
        },
        {
            startDate       : new Date(2012, 5, 1, 11),
            endDate         : new Date(2012, 5, 1, 15),
            totalAllocation : 50,
            assignments     : [ assignmentForTask1 ] 
        },
        ...
    ]


     * 
     * @param {Object} options Object with the following properties:
     * 
     * - "startDate" - start date for the report timeframe
     * - "endDate" - end date for the report timeframe
     * - "includeAllIntervals" - whether to include the intervals w/o assignments in the report
     */
    getAllocationInfo : function (options) {
        var info        = [];
        
        this.forEachAvailabilityIntervalWithTasks(options, function (intervalStartDate, intervalEndDate, currentAssignments) {
            var totalAllocation     = 0;
            var assignments         = [];
            
            for (var i in currentAssignments) {
                totalAllocation += currentAssignments[ i ].units;
                assignments.push(currentAssignments[ i ].assignment);
            }
            
            info.push({
                startDate           : new Date(intervalStartDate),
                endDate             : new Date(intervalEndDate),
                
                totalAllocation     : totalAllocation,
                assignments         : assignments
            });
        });
        
        return info;
    }
});
/**

@class Gnt.model.Task
@extends Sch.model.Range

This class represents a single task in your Gantt chart. 

The inheritance hierarchy of this class includes {@link Sch.model.Customizable} and {@link Ext.data.Model} classes.
This class will also receive a set of methods and additional fields that stem from the {@link Ext.data.NodeInterface}.
Please refer to the documentation of those classes to become familar with the base interface of this class.

By default, a Task has the following fields as seen below. 

Fields
------

- `Id` - (mandatory) a unique identifier of the task
- `Name` - the name of the task (task title)
- `StartDate` - the start date of the task in the ISO 8601 format. See {@link Ext.Date} for a formats definitions.
- `EndDate` - the end date of the task in the ISO 8601 format, **see "Start and End dates" section for important notes**
- `Duration` - the numeric part of the task duration (the number of units)
- `DurationUnit` - the unit part of the task duration (corresponds to units defined in `Sch.util.Date`), defaults to "d" (days)
- `Effort` - the numeric part of the task effort (the number of units)
- `EffortUnit` - the unit part of the task effort (corresponds to units defined in `Sch.util.Date`), defaults to "h" (hours)
- `PercentDone` - the current status of a task, expressed as the percentage completed (integer from 0 to 100)
- `Cls` - A CSS class that will be applied to each rendered task DOM element
- `BaselineStartDate` - the baseline start date of the task in the ISO 8601 format. See {@link Ext.Date} for a formats definitions.
- `BaselineEndDate` - the baseline end date of the task in the ISO 8601 format, **see "Start and End dates" section for important notes**
- `BaselinePercentDone` - the baseline status of a task, expressed as the percentage completed (integer from 0 to 100)
- `CalendarId` - the id of the calendar, assigned to task. Allows you to set the time when task can be performed.
   Should be only provided for specific tasks - all tasks by default are assigned to the project calendar, provided as the 
   {@link Gnt.data.TaskStore#calendar} option. 
- `SchedulingMode` - the field, defining the scheduling mode for the task. Based on this field some fields of the task
   will be "fixed" (should be provided) and some - computed. See {@link #schedulingModeField} for details.
- `ManuallyScheduled` - **deprecated field**, use `SchedulingMode = Manual` instead. When set to `true`, 
   the `StartDate` of the task will not be changed by any of its incoming dependecies. 
   Additionally, a manually scheduled task can be scheduled to start/end on a weekend or a calendar holiday, iow - will ignore
   any holidays when scheduling.


If you want to add new fields or change the name/options for the existing fields,
you can do that by subclassing this class (see example below). 

Subclassing the Task class
--------------------

The name of any field can be customized in the subclass. Please refer to {@link Sch.model.Customizable} for details.

    Ext.define('MyProject.model.Task', {
        extend      : 'Gnt.model.Task',
        
        nameField           : 'myName', 
        percentDoneField    : 'percentComplete', 

        isAlmostDone : function () {
            return this.get('percentComplete') > 80;
        },
        ...
    })

Start and End dates
-------------------

For all tasks, the range between start date and end date is supposed to be not-inclusive on the right side: StartDate <= date < EndDate.
So, for example, the task which starts at 2011/07/18 and has 2 days duration, should have the end date: 2011/07/20, **not** 2011/07/19 23:59:59.

Such convention simplifies the calculations, since you don't have to constantly change the end date to ends with those "59:59" but should always be
considered, when writing the application. For example a 1 day task, which starts at 2011/07/18 00:00:00, will end at 2011/07/19 00:00:00, and so on. 


Conversion to "days" duration unit
-----------------------------------

Some duration units cannot be converted to "days" consistenly. For example a month may have 28, 29, 30 or 31 days. The year may have 365 or 366 days and so on.
So in such conversion operations, we will always assume that a task with a duration of 1 month will have a duration of 30 days. 
This is {@link Gnt.data.Calendar#daysPerMonth a configuration option} of the calendar class.

Task API
--------

One important thing to consider is that, if you are using the availability/scheduling modes feature, then you need to use the task API call to update the fields like `StartDate / EndDate / Duration`.
Those calls will calculate the correct value of each the field, taking into account the information from calendar/assigned resources.  

Server-side integration
-----------------------

Also, at least for now you should not use the "save" method of the model available in Ext 4:

    task.save() // WON'T WORK
    
This is because there are some quirks in using CRUD for Ext tree stores. These quirks are fixed in the TaskStore. To save the changes in task to server
use the "sync" method of the task store:

    taskStore.sync() // OK

*/
Ext.define('Gnt.model.Task', {
    extend              : 'Sch.model.Range',

    requires            : [
        'Sch.util.Date',
        'Ext.data.NodeInterface'
    ],

    idProperty          : "Id",

    customizableFields     : [
        { name: 'Id' },
        { name: 'Duration', type: 'number', useNull: true },
        { name: 'Effort', type: 'number', useNull: true },
        { name: 'EffortUnit', type: 'string', defaultValue: 'h'},
        { name: 'CalendarId', type: 'string'},

        {
            name: 'DurationUnit',
            type: 'string',
            defaultValue: "d",
            // make sure the default value is applied when user provides empty value for the field, like "" or null
            convert: function (value) {
                return value || "d";
            }
        },
        { name: 'PercentDone', type: 'int', defaultValue: 0 },
        { name: 'ManuallyScheduled', type: 'boolean', defaultValue: false },
        { name: 'SchedulingMode', type: 'string', defaultValue: 'Normal' },
        
        { name: 'BaselineStartDate', type: 'date', dateFormat: 'c' },
        { name: 'BaselineEndDate', type: 'date', dateFormat: 'c' },
        { name: 'BaselinePercentDone', type: 'int', defaultValue: 0 },
        { name: 'Draggable', type: 'boolean', persist: false, defaultValue : true },   // true or false
        { name: 'Resizable', persist: false }                                          // true, false, 'start' or 'end'
    ],

    /**
    * @cfg {String} draggableField The name of the field specifying if the event should be draggable in the timeline
    */
    draggableField: 'Draggable',

    /**
    * @cfg {String} resizableField The name of the field specifying if/how the event should be resizable.
    */
    resizableField: 'Resizable',

    /**
    * @method isDraggable
    * 
    * Returns true if event can be drag and dropped
    * @return {Mixed} The draggable state for the event.
    */
    isDraggable: function () {
        return this.getDraggable();
    },

    /**
    * @method setDraggable
    * 
    * Sets the new draggable state for the event
    * @param {Boolean} draggable true if this event should be draggable
    */

    /**
    * @method isResizable
    * 
    * Returns true if event can be resized, but can additionally return 'start' or 'end' indicating how this event can be resized. 
    * @return {Mixed} The resource Id
    */
    isResizable: function () {
        return this.getResizable();
    },

    /**
    * @method setResizable
    * 
    * Sets the new resizable state for the event. You can specify true/false, or 'start'/'end' to only allow resizing one end of an event.
    * @param {Boolean} resizable true if this event should be resizable
    */
    
    /**
    * @cfg {String} nameField The name of the field that holds the task name. Defaults to "Name".
    */
    nameField               : 'Name',

    /**
    * @cfg {String} durationField The name of the field holding the task duration.
    */ 
    durationField           : 'Duration',
    
    /**
    * @cfg {String} durationUnitField The name of the field holding the task duration unit.
    */ 
    durationUnitField       : 'DurationUnit',
    
    /**
    * @cfg {String} effortField The name of the field holding the value of task effort.
    */ 
    effortField             : 'Effort',
    
    /**
    * @cfg {String} effortUnitField The name of the field holding the task effort unit.
    */ 
    effortUnitField         : 'EffortUnit',
    

    /**
    * @cfg {String} percentDoneField The name of the field specifying the level of completion.
    */ 
    percentDoneField        : 'PercentDone',

    /**
    * @cfg {String} manuallyScheduledField The name of the field defining if a task is manually scheduled or not.
    * **This field is deprecated** in favor of "schedulingModeField". 
    * To specify that task is manually scheduled set the value of "schedulingModeField" to "Manual"
    */ 
    manuallyScheduledField  : 'ManuallyScheduled',
    
    /**
    * @cfg {String} schedulingModeField The name of the field defining the scheduling mode of the task. Should be one of the 
    * following strings:
    * 
    * - `Normal` is the default (and backward compatible) mode. It means the task will be scheduled based only on information 
    * about its start/end dates and project calendar. The individual calendars of tasks and resources will be ignored,
    * the effort and assigned resources of the task won't have any influence on its scheduling.  
    * 
    * - `FixedDuration` mode means, that task has fixed start and end dates, but its effort will be computed dynamically,
    * based on the assigned resources information. Typical example of such task is - meeting. Meetings typicaly have
    * pre-defined start and end dates and the more people are participating in the meething, the more effort is spent on the task.
    * When duration of such task increases, its effort is increased too (and vice-versa).
    * 
    * - `EffortDriven` mode means, that task has fixed effort and computed duration. The more resources will be assigned 
    * to this task, the less the duration will be. Typical example will be "paint the walls" task - 
    * several painters will complete it faster.  
    * 
    * - `DynamicAssignment` mode can be used when both duration and effort of the task are fixed. The computed value in this
    * case will be - the assignment units of the resources. In this mode, the assignment level of all assigned resources
    * will be updated to evenly distribute the task's workload among them.
    * 
    * - `Manual` mode disables any additional calculations and task will be scheduled based only on information about 
    * its start/end dates. Incoming dependencies also won't affect the task. This scheduling mode is superseding the 
    * `ManuallyScheduled` field.
    */ 
    schedulingModeField     : 'SchedulingMode',
    
    /**
     * @cfg {String} calendarIdField The name of the field defining the id of the calendar for this specific task. Task calendar has the highest priority.
     */
    calendarIdField         : 'CalendarId',
    
    /**
    * @cfg {String} baselineStartDateField The name of the field that holds the task baseline start date.
    */
    baselineStartDateField  : 'BaselineStartDate',
    
    /**
    * @cfg {String} baselineEndDateField The name of the field that holds the task baseline end date.
    */
    baselineEndDateField    : 'BaselineEndDate',
    
    /**
    * @cfg {String} baselinePercentDoneField The name of the field specifying the baseline level of completion.
    */ 
    baselinePercentDoneField    : 'BaselinePercentDone',

    /**
    * @cfg {Gnt.data.Calendar} calendar 
    * Optional. An explicitly provided {@link Gnt.data.Calendar calendar} instance. Usually will be retrieved by the task from the {@link Gnt.data.TaskStore task store}.
    */
    calendar                : null,

    /**
    * @cfg {Gnt.data.DependencyStore} dependencyStore 
    * Optional. An explicitly provided {@link Gnt.data.DependencyStore} with dependencies information. Usually will be retrieved by the task from the {@link Gnt.data.TaskStore task store}.
    */
    dependencyStore         : null,

    /**
    * @cfg {Gnt.data.TaskStore} taskStore 
    * Optional. An explicitly provided Gnt.data.TaskStore with tasks information. Usually will be set by the {@link Gnt.data.TaskStore task store}.
    */
    taskStore               : null,

    normalized              : false,
    
    recognizedSchedulingModes   : [ 'Normal', 'Manual', 'FixedDuration', 'EffortDriven', 'DynamicAssignment' ],

    
    constructor : function () {
        // hack that significantly speed up initial rendering, because
        // thousands of expensive `getModifiedFieldNames` calls (due to `isDate` check) will be skipped 
        this.getModifiedFieldNames = function () {
            if (this.__isFilling__) return [];
            
            delete this.getModifiedFieldNames;
            
            return this.getModifiedFieldNames();
        };
        
        this.callParent(arguments);
    },
    
    // should be called once after initial loading - will convert the "EndDate" field to "Duration"
    // the model should have the link to calendar
    normalize: function () {
        var duration        = this.getDuration(),
            durationUnit    = this.getDurationUnit(),
            startDate       = this.getStartDate(),
            endDate         = this.getEndDate(),
            schedulingMode  = this.getSchedulingMode(),
            data            = this.data;

        // for all scheduling modes
        if (duration == null && startDate && endDate) {
            data[ this.durationField ] = this.calculateDuration(startDate, endDate, durationUnit);
        }

        if ((schedulingMode == 'Normal' || this.isManuallyScheduled()) && endDate == null && startDate && duration) {
            data[ this.endDateField ] = this.calculateEndDate(startDate, duration, durationUnit);
        }
        
        if (schedulingMode == 'EffortDriven' || schedulingMode == 'FixedDuration' ){
            var effort          = this.getEffort(),
                effortUnit      = this.getEffortUnit();

             if (effort == null && startDate && endDate) {
                data[ this.effortField ] = this.calculateEffort(startDate, endDate, effortUnit);
            }
        
            if (endDate == null && startDate && effort) {
                data[ this.endDateField ]  = this.calculateEffortDrivenEndDate(startDate, effort, effortUnit);
            
                // for "effortDriven" task user can only provide StartDate and Effort - thats all we need
                if (duration == null) {
                    data[ this.durationField ] = this.calculateDuration(startDate, data[ this.endDateField ], durationUnit);
                }
            }
        }

        // this is weird but this kind of "protection" is slower for 30ms in FF5..
        // write is that expensive?
        this.normalized = true;
    },



    // We'll be using `internalId` for Id substitution when dealing with phantom records
    getInternalId: function(){
        return this.getId() || this.internalId;
    },  


    /**
    * Returns the {@link Gnt.data.Calendar calendar} instance, associated with this task
    * 
    * @return {Gnt.data.Calendar} calendar
    */
    getCalendar: function (ownCalendar) {
        var calendar    = this.get(this.calendarIdField);
        
        // our own calendar
        calendar        = calendar ? Gnt.data.Calendar.getCalendar(calendar) : this.calendar;
        
        if (ownCalendar || calendar) {
            return calendar;
        } else {
            var store   = this.stores[ 0 ];
            
            calendar    = store && store.getCalendar && store.getCalendar() || this.parentNode && this.parentNode.getCalendar();           
        }

        if (!calendar) {
            Ext.Error.raise("Can't find a calendar in `getCalendar`");
        }

        return calendar;
    },

    /*
    * Sets the {@link Gnt.data.Calendar calendar} instance, associated with this task
    */    
    setCalendar: function(calendar){
        // TODO IMPLEMENT
    
        this.calendar = calendar;
    },


    /**
     * Returns the dependency store, associated with this task.
     * 
     * @return {Gnt.data.DependencyStore} The dependency store instance
     */
    getDependencyStore: function () {
        var dependencyStore = this.dependencyStore || this.getTaskStore().dependencyStore;

        if (!dependencyStore) {
            Ext.Error.raise("Can't find a dependencyStore in `getDependencyStore`");
        }

        return dependencyStore;
    },
    
    
    /**
     * Returns the resource store, associated with this task.
     * 
     * @return {Gnt.data.Resource} The resource store instance
     */
    getResourceStore : function () {
        return this.getTaskStore().getResourceStore();
    },
    
    
    /**
     * Returns the assignment store, associated with this task.
     * 
     * @return {Gnt.data.AssignmentStore} The assignment store instance
     */
    getAssignmentStore : function () {
        return this.getTaskStore().getAssignmentStore();
    },


    /**
    * Returns the {@link Gnt.data.TaskStore task store} instance, associated with this task
    * 
    * @return {Gnt.data.TaskStore} task store
    */
    getTaskStore: function (ignoreAbsense) {
        if (this.taskStore) return this.taskStore;

        var taskStore = this.stores[0] && this.stores[0].taskStore || this.parentNode && this.parentNode.getTaskStore();

        if (!taskStore && !ignoreAbsense) {
            Ext.Error.raise("Can't find a taskStore in `getTaskStore`");
        }

        return this.taskStore = taskStore;
    },


    /**
    * Returns true if the task is manually scheduled.
    * 
    * @return {Boolean} The value of the ManuallyScheduled field
    */
    isManuallyScheduled: function () {    
        return this.get(this.schedulingModeField) == 'Manual' || this.get(this.manuallyScheduledField);
    },

    /**
    * Sets the task manually scheduled status. Calling this method will also update the "SchedulingMode" field.
    * If that field was set to "Manual", calling this method with false value will set the scheduling mode to "Normal".
    * 
    * @param {Boolean} The new value of the ManuallyScheduled field
    */
    setManuallyScheduled: function (value) {
        if (value) {
            this.set(this.schedulingModeField, 'Manual');
        } else {
            if (this.get(this.schedulingModeField) == 'Manual') {
                this.set(this.schedulingModeField, 'Normal');
            }
        }
        
        return this.set(this.manuallyScheduledField, value);
    },
    
    
    /**
    * @method getSchedulingMode
    * 
    * Returns the scheduling mode of this task
    * 
    * @return {String} scheduling mode string
    */
    
    
    /**
     * Sets the scheduling mode for this task.
     * 
     * @param {String} value Name of the scheduling mode. See {@link #schedulingModeField} for details.
     */
    setSchedulingMode : function (value) {
        if (Ext.Array.indexOf(this.recognizedSchedulingModes, value) == -1) throw "Unrecognized scheduling mode: " + value;
        
        this.beginEdit();
        
        this.set(this.schedulingModeField, value);
        
//       TODO
//       if (value == 'Normal' || value == 'Manual') {}
         
        if (value === 'FixedDuration') {
            this.updateEffortBasedOnDuration();
        }
        
        if (value === 'EffortDriven') {
            this.updateDurationBasedOnEffort();
        }
        
        this.endEdit();
    },
    

    /**
    * @method getStartDate
    * 
    * Returns the start date of this task
    * 
    * @return {Date} start date
    */

    
    
    /**
    * Depending from the arguments, set either `StartDate + EndDate` fields of this task, or `StartDate + Duration` 
    * considering the weekends/holidays rules. The modifications are wrapped with `beginEdit/endEdit` calls.
    * 
    * @param {Date} date Start date to set
    * @param {Boolean} keepDuration Pass `true` to keep the duration of the task ("move" the task), `false` to change the duration ("resize" the task). 
    * Default is `true`
    * 
    * @param {Boolean} skipNonWorkingTime Pass `true` to automatically move the start date to the next working day (if it falls on weekend/holiday).
    * Default is `false`
    */
    setStartDate: function (date, keepDuration, skipNonWorkingTime) {
        this.beginEdit();
        
        var calendar = this.getCalendar();

        if (skipNonWorkingTime && !this.isManuallyScheduled()) {
            // do not skip non-working time for milestones, if it starts on a working day
            if (!this.isMilestone() || calendar.isHoliday(date - 1)) {
                date = calendar.skipNonWorkingTime(date, true);
            }
        }

        if (keepDuration !== false) {
            var duration = this.getDuration();
            
            if (Ext.isNumber(duration)) {
                this.set(this.startDateField, date);
                this.set(this.endDateField, this.calculateEndDate(date, duration, this.getDurationUnit()));
            } else {
                this.set(this.startDateField, date);
            }
        } else {
            this.set(this.startDateField, date);
            if (this.getEndDate()) {
                this.set(this.durationField, this.calculateDuration(date, this.getEndDate(), this.getDurationUnit()));
            } 
        }
        
        this.onPotentialEffortChange();

        this.endEdit();
    },


    /**
    * @method getEndDate
    * 
    * Returns the end date of this task
    * 
    * @return {Date} end date
    */


    /**
    * Depending from the arguments, set either `StartDate + EndDate` fields of this task, or `EndDate + Duration` 
    * considering the weekends/holidays rules. The modifications are wrapped with `beginEdit/endEdit` calls.
    * 
    * @param {Date} date End date to set
    * @param {Boolean} keepDuration Pass `true` to keep the duration of the task ("move" the task), `false` to change the duration ("resize" the task). 
    * Default is `true`
    * 
    * @param {Boolean} skipNonWorkingTime Pass `true` to automatically move the start date to the previous working day (if it falls on weekend/holiday).
    * Default is `false`
    */
    setEndDate: function (date, keepDuration, skipNonWorkingTime) {
        this.beginEdit();

        var cal = this.getCalendar();

        if (skipNonWorkingTime && !this.isManuallyScheduled()) {
            // do not skip non-working time for milestones, if it starts on a working day
            if ((keepDuration || date - this.getStartDate() > 0) && cal.isHoliday(date)) {
               date = cal.skipNonWorkingTime(date, false);
            }
        }

        if (keepDuration !== false) {
            var duration = this.getDuration();
            
            if (Ext.isNumber(duration)) {
                this.set(this.startDateField, this.calculateStartDate(date, duration, this.getDurationUnit()));
                this.set(this.endDateField, date);
            } else {
                this.set(this.endDateField, date);
            }
        } else {
            this.set(this.endDateField, date);
            if (this.getStartDate()) {
                this.set(this.durationField, this.calculateDuration(this.getStartDate(), date, this.getDurationUnit()));
            }
        }
        
        this.onPotentialEffortChange();

        this.endEdit();
    },


    /**
    * Sets the `StartDate / EndDate / Duration` fields of this task, considering the availability/holidays information. 
    * The modifications are wrapped with `beginEdit/endEdit` calls.
    * 
    * @param {Date} startDate Start date to set
    * @param {Date} endDate End date to set
    * @param {Boolean} skipNonWorkingTime Pass `true` to automatically move the start/end dates to the next/previous working day (if they falls on weekend/holiday).
    * Default is `false`
    */
    setStartEndDate: function (startDate, endDate, skipNonWorkingTime) {
        this.beginEdit();
        var cal = this.getCalendar();

        if (skipNonWorkingTime && !this.isManuallyScheduled()) {
            startDate = startDate && cal.skipNonWorkingTime(startDate, true);
            endDate = endDate && cal.skipNonWorkingTime(endDate, false);
        }

        this.set(this.startDateField, startDate);
        this.set(this.endDateField, endDate);
        this.set(this.durationField, this.calculateDuration(startDate, endDate, this.getDurationUnit()));
        
        this.onPotentialEffortChange();

        this.endEdit();
    },


    /**
    * Returns the duration of the task expressed in the unit passed as the only parameter (or as specified by the DurationUnit for the task). 
    * 
    * @param {String} unit Unit to return the duration in. Defaults to the `DurationUnit` field of this task
    * 
    * @return {Number} duration
    */
    getDuration: function (unit) {
        if (!unit) return this.get(this.durationField);

        var calendar        = this.getCalendar(),
            durationInMS    = calendar.convertDurationToMs(this.get(this.durationField), this.get(this.durationUnitField));

        return calendar.convertMSDurationToUnit(durationInMS, unit);
    },
    
    
    /**
    * Returns the effort of the task expressed in the unit passed as the only parameter (or as specified by the EffortUnit for the task). 
    * 
    * @param {String} unit Unit to return the duration in. Defaults to the `EffortUnit` field of this task
    * 
    * @return {Number} duration
    */
    getEffort: function (unit) {
        if (!unit) return this.get(this.effortField);
        
        var calendar        = this.getCalendar(),
            durationInMS    = calendar.convertDurationToMs(this.get(this.effortField), this.get(this.effortUnitField));

        return calendar.convertMSDurationToUnit(durationInMS, unit);
    },
    
    
    /**
    * Sets the `Effort + EffortUnit` fields of this task. In case the task has the `EffortDriven`
    * {@link #schedulingModeField scheduling mode} will also update the duration of the task accordingly.
    * In case of `DynamicAssignment` mode - will update the assignments.
    *  
    * The modifications are wrapped with `beginEdit/endEdit` calls.
    * 
    * @param {Number} number The number of duration units
    * @param {String} unit The unit of the duration. Defaults to the `DurationUnit` field of this task
    */
    setEffort: function (number, unit) {
        unit = unit || this.get(this.effortUnitField);

        this.beginEdit();

        this.set(this.effortField, number);
        this.set(this.effortUnitField, unit);
        
        if (this.getSchedulingMode() == 'EffortDriven') {
            this.updateDurationBasedOnEffort();
        }
        
        if (this.getSchedulingMode() == 'DynamicAssignment') {
            this.updateAssignments();
        }
        
        this.endEdit();
    },
    

    /**
    * Returns the "raw" calendar duration (difference between end and start date) of this task in the given units. 
    * 
    * Please refer to the "Task durations" section for additional imporant details about duration units.
    * 
    * @param {String} unit Unit to return return the duration in. Defaults to the `DurationUnit` field of this task
    * 
    * @return {Number} duration
    */
    getCalendarDuration: function (unit) {
        return this.getCalendar().convertMSDurationToUnit(this.getEndDate() - this.getStartDate(), unit || this.get(this.durationUnitField));
    },

    
    /**
    * Sets the `Duration + DurationUnit + EndDate` fields of this task, considering the weekends/holidays rules. 
    * The modifications are wrapped with `beginEdit/endEdit` calls.
    * 
    * May also update additional fields, depending from the {@link #schedulingModeField scheduling mode}.
    * 
    * @param {Number} number The number of duration units
    * @param {String} unit The unit of the duration. Defaults to the `DurationUnit` field of this task
    */
    setDuration: function (number, unit) {
        unit = unit || this.get(this.durationUnitField);

        this.beginEdit();

        this.set(this.endDateField, this.calculateEndDate(this.getStartDate(), number, unit));
        this.set(this.durationField, number);
        this.set(this.durationUnitField, unit);
        
        this.onPotentialEffortChange();

        this.endEdit();
    },

    
    calculateStartDate: function (endDate, duration, unit) {
        unit = unit || this.getDurationUnit();

        if (this.isManuallyScheduled()) {
            return Sch.util.Date.add(startDate, unit, -duration);
        } else {
            return this.getCalendar().calculateStartDate(endDate, duration, unit);
        }
    },

    
    calculateEndDate: function (startDate, duration, unit) {
        unit = unit || this.getDurationUnit();

        if (this.isManuallyScheduled()) {
            return Sch.util.Date.add(startDate, unit, duration);
        } else {
            return this.getCalendar().calculateEndDate(startDate, duration, unit);
        }
    },

    
    calculateDuration: function (startDate, endDate, unit) {
        unit = unit || this.getDurationUnit();

        if (!startDate || !endDate) {
            return 0;
        }

        if (this.isManuallyScheduled()) {
            return this.getCalendar().convertMSDurationToUnit(endDate - startDate, unit);
        } else {
            return this.getCalendar().calculateDuration(startDate, endDate, unit);
        }
    },
    
    
    // iterates over the common availability intervals for tasks and resources in between `startDate/endDate`
    // note, that function will receive start/end dates as number, not dates (for optimization purposes)
    // this method is not "normalized" intentionally because of performance considerations
    forEachAvailabilityIntervalWithResources : function (options, func, scope) {
        scope                       = scope || this;
        
        var startDate               = options.startDate;
        var endDate                 = options.endDate;
        
        var cursorDate              = new Date(startDate);
        var includeEmptyIntervals   = options.includeEmptyIntervals;
                 
        
        var taskCalendar            = this.getCalendar();
        var assignments             = this.getAssignments();
        
        // if there are no assignments - then there are no resources and resource availability at all
        if (!assignments.length) return;
        
        var resources               = [];
        var resourcesCalendars      = [];
        
        Ext.each(assignments, function (assignment) {
            var resource    = assignment.getResource();
            
            resources.push(resource);
            resourcesCalendars.push(resource.getCalendar());
        });
        
        var DATE            = Sch.util.Date;
        
        var i, k, interval, intervalStartDate, intervalEndDate;
        
        while (!endDate || cursorDate < endDate) {
            var taskIntervals       = taskCalendar.getAvailabilityIntervalsFor(cursorDate);
            
            var pointsByTime        = {};
            var pointTimes          = [];
            
            // using "for" instead of "each" should be blazing fast! :)
            for (k = 0; k < taskIntervals.length; k++) {
                interval            = taskIntervals[ k ];
                intervalStartDate   = interval.startDate - 0;
                intervalEndDate     = interval.endDate - 0;
                
                if (!pointsByTime[ intervalStartDate ]) {
                    pointsByTime[ intervalStartDate ] = [];
                    
                    pointTimes.push(intervalStartDate);
                }
                pointsByTime[ intervalStartDate ].push({
                    type        : '00-taskAvailailabilityStart'
                });
                
                pointTimes.push(intervalEndDate);
                
                pointsByTime[ intervalEndDate ] = pointsByTime[ intervalEndDate ] || [];
                pointsByTime[ intervalEndDate ].push({
                    type        : '01-taskAvailailabilityEnd'
                });
            }
            
            // using "for" instead of "each" should be blazing fast! :)
            for (i = 0; i < resourcesCalendars.length; i++) {
                var resourceIntervals       = resourcesCalendars[ i ].getAvailabilityIntervalsFor(cursorDate);
                
                // using "for" instead of "each" should be blazing fast! :)
                for (k = 0; k < resourceIntervals.length; k++) {
                    interval            = resourceIntervals[ k ];
                    intervalStartDate   = interval.startDate - 0;
                    intervalEndDate     = interval.endDate - 0;
                    
                    if (!pointsByTime[ intervalStartDate ]) {
                        pointsByTime[ intervalStartDate ] = [];
                        
                        pointTimes.push(intervalStartDate);
                    }
                    pointsByTime[ intervalStartDate ].push({
                        type        : '02-resourceAvailailabilityStart',
                        assignment  : assignments[ i ],
                        resourceId  : resources[ i ].getInternalId(),
                        units       : assignments[ i ].getUnits()
                    });
                    
                    if (!pointsByTime[ intervalEndDate ]) {
                        pointsByTime[ intervalEndDate ] = [];
                        
                        pointTimes.push(intervalEndDate);
                    }
                    pointsByTime[ intervalEndDate ].push({
                        type        : '03-resourceAvailailabilityEnd',
                        resourceId  : resources[ i ].getInternalId()
                    });
                }
            }
            
            pointTimes.sort();
            
            var inTask              = false;
            var currentResources    = {};
            var resourceCounter     = 0;
            
            for (i = 0; i < pointTimes.length; i++) {
                var points      = pointsByTime[ pointTimes[ i ] ];
                
                points.sort(function (a, b) {
                    return a.type < b.type;
                });
                
                for (k = 0; k < points.length; k++) {
                    var point       = points[ k ];
                    
                    if (point.type == '00-taskAvailailabilityStart') {
                        inTask      = true;
                    }
                    
                    if (point.type == '01-taskAvailailabilityEnd') {
                        inTask      = false;
                    }
                    
                    if (point.type == '02-resourceAvailailabilityStart') {
                        currentResources[ point.resourceId ] = point;
                        resourceCounter++;
                    }
                    
                    if (point.type == '03-resourceAvailailabilityEnd') {
                        delete currentResources[ point.resourceId ];
                        resourceCounter--;
                    }
                }
                
                if (inTask && (resourceCounter || includeEmptyIntervals)) {
                    intervalStartDate       = pointTimes[ i ];
                    intervalEndDate         = pointTimes[ i + 1 ];
                    
                    // availability interval is out of [ startDate, endDate )
                    if (intervalStartDate > endDate || intervalEndDate < startDate) continue;
                    
                    if (intervalStartDate < startDate) intervalStartDate = startDate - 0;
                    if (intervalEndDate > endDate) intervalEndDate = endDate - 0;
                    
                    if (func.call(scope, intervalStartDate, intervalEndDate, currentResources) === false) return false;
                }
            }
            
            // does not perform cloning internally!
            cursorDate       = DATE.getStartOfNextDay(cursorDate);
        }
    },
    
    
    calculateEffortDrivenEndDate : function (startDate, effort, unit) {
        var effortInMS      = this.getCalendar().convertDurationToMs(effort, unit || this.getEffortUnit());
        
        var endDate         = new Date(startDate);
        
        this.forEachAvailabilityIntervalWithResources({ startDate : startDate }, function (intervalStartDate, intervalEndDate, currentResources) {
            var totalUnits          = 0;
            
            for (var i in currentResources) totalUnits += currentResources[ i ].units;
            
            var intervalDuration    = intervalEndDate - intervalStartDate;
            var availableEffort     = totalUnits * intervalDuration / 100;
            
            if (availableEffort >= effortInMS) {
                
                endDate             = new Date(intervalStartDate + effortInMS / availableEffort * intervalDuration); 
                
                return false;
                
            } else {
                effortInMS          -= availableEffort;
            }
        });
        
        return endDate;
    },

    /**
    * Increase the indendation level of this task in the tree 
    */
    indent: function () {
        var prev = this.previousSibling;
        
        if (prev) {
            this.isMove = true;         // HACK, need a mechanism to identify this operation as _not_ being a true remove operation
            prev.appendChild(this);
            delete this.isMove;

            prev.set('leaf', false);
            prev.expand();
        }
    },


    /**
    * Decrease the indendation level of this task in the tree 
    */
    outdent: function () {
        var parent = this.parentNode;

        if (parent && !parent.isRoot()) {
            parent.set('leaf', parent.childNodes.length === 1);
            this.isMove = true;         // HACK, need a mechanism to identify this operation as _not_ being a true remove operation
            if (parent.nextSibling) {
                parent.parentNode.insertBefore(this, parent.nextSibling);
            } else {
                parent.parentNode.appendChild(this);
            }
            delete this.isMove;
        }
    },


    recalculateParents: function () {
        var earliest    = new Date(9999, 0, 0),
            latest      = new Date(0),
            parent      = this.parentNode;
            
        var startChanged, endChanged;
            
        if (parent && !parent.isRoot() && parent.childNodes.length > 0) {
            if (!parent.isManuallyScheduled()) {

                for (var i = 0, l = parent.childNodes.length; i < l; i++) {
                    var r = parent.childNodes[i];

                    earliest = Sch.util.Date.min(earliest, r.getStartDate() || earliest);
                    latest = Sch.util.Date.max(latest, r.getEndDate() || latest);
                }

                startChanged    = earliest - new Date(9999, 0, 0) !== 0 && parent.getStartDate() - earliest !== 0; 
                endChanged      = latest - new Date(0) !== 0 && parent.getEndDate() - latest !== 0;
                
                // special case to only trigger 1 update event and avoid extra "recalculateParents" calls
                // wrapping with `beginEdit / endEdit` is not an option, because they do not nest (one "endEdit" will "finalize" all previous "beginEdit")
                if (startChanged && endChanged) {
                    parent.setStartEndDate(earliest, latest, false);
                } else if (startChanged) {
                    parent.setStartDate(earliest, endChanged, false);
                } else if (endChanged) {
                    parent.setEndDate(latest, false, false);
                }
            }
            
            // if `startChanged` or `endChanged` is true, then propagation to parent task has alreday happened in the
            // `onTaskUpdated` method of the TaskStore (during setStart/EndDate call), otherwise need to propagate it manually
            if (!startChanged && !endChanged) {
                parent.recalculateParents();
            }
        }
    },


    /**
    * Returns true if this task is a milestone (has the same start and end dates).
    * 
    * @return {Boolean} 
    */
    isMilestone: function() {
         return this.getDuration() === 0;
    },


    /**
    * Returns true if this task is a milestone (has the same start and end baseline dates) or false if it's not or the dates are wrong.
    * 
    * @return {Boolean} 
    */
    isBaselineMilestone: function() {
        var baseStart = this.getBaselineStartDate(),
            baseEnd   = this.getBaselineEndDate();
            
        if(baseStart && baseEnd){
            return baseEnd - baseStart === 0;
        }
        return false;
    },     


    /**
    * Returns all dependencies of this task (both incoming and outgoing)
    * 
    * @param {Ext.data.Store} dependencyStore (optional)
    * 
    * @return {Array[Gnt.model.Dependency]} 
    */
    getAllDependencies: function (dependencyStore) {
        dependencyStore = dependencyStore || this.getDependencyStore();

        return dependencyStore.getDependenciesForTask(this);
    },

    /**
    * Returns true if this task has at least one incoming dependency
    * 
    * @param dependencyStore Optional
    * 
    * @return {Array[Gnt.model.Dependency]} 
    */
    hasIncomingDependencies: function (dependencyStore) {
        var id = this.getId() || this.internalId;
        dependencyStore = dependencyStore || this.getDependencyStore();

        var res = dependencyStore.findBy(function(dep) { return dep.getTargetId() == id; });
        return res >= 0;
    },

    /**
    * Returns all incoming dependencies of this task
    * 
    * @param {Ext.data.Store} dependencyStore (optional)
    * 
    * @return {Array[Gnt.model.Dependency]} 
    */
    getIncomingDependencies: function (dependencyStore) {
        dependencyStore = dependencyStore || this.getDependencyStore();

        return dependencyStore.getIncomingDependenciesForTask(this);
    },


    /**
    * Returns all outcoming dependencies of this task
    * 
    * @param {Ext.data.Store} dependencyStore (optional)
    * 
    * @return {Array[Gnt.model.Dependency]} 
    */
    getOutgoingDependencies: function (dependencyStore) {
        dependencyStore = dependencyStore || this.getDependencyStore();

        return dependencyStore.getOutgoingDependenciesForTask(this);
    },


    getConstrainContext: function (providedTaskStore) {
        var incomingDependencies = this.getIncomingDependencies();

        if (!incomingDependencies.length) {
            return null;
        }

        var taskStore = providedTaskStore || this.getTaskStore(),
            DepType = Gnt.model.Dependency.Type,
            earliestStartDate = new Date(0),
            earliestEndDate = new Date(0),
            ExtDate = Ext.Date,
            calendar = this.getCalendar(),
            constrainingTask;

        Ext.each(incomingDependencies, function (dependency) {
            var fromTask = dependency.getSourceTask();

            if (fromTask) {
                var lag = dependency.getLag() || 0,
                    start = fromTask.getStartDate(),
                    end = fromTask.getEndDate();

                switch (dependency.getType()) {
                    case DepType.StartToEnd:
                        start = calendar.skipWorkingDays(start, lag);
                        if (earliestEndDate < start) {
                            earliestEndDate = start;
                            constrainingTask = fromTask;
                        }
                        break;

                    case DepType.StartToStart:
                        start = calendar.skipWorkingDays(start, lag);
                        if (earliestStartDate < start) {
                            earliestStartDate = start;
                            constrainingTask = fromTask;
                        }
                        break;

                    case DepType.EndToStart:
                        end = calendar.skipWorkingDays(end, lag);
                        if (earliestStartDate < end) {
                            earliestStartDate = end;
                            constrainingTask = fromTask;
                        }
                        break;

                    case DepType.EndToEnd:
                        end = calendar.skipWorkingDays(end, lag);
                        if (earliestEndDate < end) {
                            earliestEndDate = end;
                            constrainingTask = fromTask;
                        }
                        break;

                    default:
                        throw 'Invalid dependency type: ' + dependency.getType();
                }
            }
        });

        return {
            startDate: earliestStartDate > 0 ? earliestStartDate : null,
            endDate: earliestEndDate > 0 ? earliestEndDate : null,

            constrainingTask: constrainingTask
        };
    },


    /**
    * @private
    * Internal method, called recursively to query for the longest duration of the chain structure
    * @return {Array} chain The chain of linked tasks
    */
    getCriticalPaths: function () {
        var cPath = [this],
            ctx = this.getConstrainContext();

        while (ctx) {
            cPath.push(ctx.constrainingTask);

            ctx = ctx.constrainingTask.getConstrainContext();
        }

        return cPath;
    },


    
    /**
    * @private
    * Internal method, constrains the task according to its incoming dependencies
    * @param {Gnt.data.TaskStore} taskStore The task store
    * @return {Boolean} true if the task was updated as a result.
    */
    constrain: function (taskStore) {
        if (this.isManuallyScheduled()) {
            return false;
        }

        var changed = false;

        taskStore = taskStore || this.getTaskStore();

        var constrainContext = this.getConstrainContext(taskStore);

        if (constrainContext) {
            var startDate = constrainContext.startDate;
            var endDate = constrainContext.endDate;

            if (startDate && startDate - this.getStartDate() !== 0) {
                this.setStartDate(startDate, true, taskStore.skipWeekendsDuringDragDrop);
                changed = true;
            } else if (endDate && endDate - this.getEndDate() !== 0) {
                this.setEndDate(endDate, true, taskStore.skipWeekendsDuringDragDrop);
                changed = true;
            }
        }

        return changed;
    },


    cascadeChanges: function (taskStore, context) {
        taskStore = taskStore || this.getTaskStore();

        if (this.isLeaf()) {
            if (this.constrain(taskStore)) {
                this.recalculateParents();
                context.nbrAffected++;
            }
        }

        Ext.each(this.getOutgoingDependencies(), function (dependency) {

            var toTaskRecord = dependency.getTargetTask();

            if (toTaskRecord && !toTaskRecord.isManuallyScheduled()) {
                toTaskRecord.cascadeChanges(taskStore, context);
            }
        });
    },

    // @NICK, these seem required for propagation of update events etc from nodestore to taskstore? 
    // Dual update events fired if uncommented in 4.1 b2, after drag drop. solution?
    //
    // OWN_UPDATE
    afterEdit: function (modifiedFieldNames) {
        
        // If a node is bound to a store, 'update' will be fired from the task store.
        // Required because of the Ext lazy loading of tree nodes.
        // See http://www.sencha.com/forum/showthread.php?180406-4.1B2-TreeStore-inconsistent-firing-of-update
        if (this.stores.length > 0 || !this.normalized) {
            this.callParent(arguments);
        } else {
            var taskStore = this.taskStore || this.getTaskStore(true);

            if (taskStore && !taskStore.isFillingRoot) {
                taskStore.afterEdit(this, modifiedFieldNames);
            }
            this.callParent(arguments);
        }
    },


    //OWN_UPDATE
    afterCommit: function () {
        this.callParent(arguments);

        // If a node is bound to a store, 'update' will be fired from the task store.
        // Required because of the Ext lazy loading of tree nodes.
        // See http://www.sencha.com/forum/showthread.php?180406-4.1B2-TreeStore-inconsistent-firing-of-update
        if (this.stores.length > 0 || !this.normalized) {
            return;
        }

        var taskStore = this.taskStore || this.getTaskStore(true);

        if (taskStore && !taskStore.isFillingRoot) {
            taskStore.afterCommit(this);
        }
    },


    // OWN_UPDATE
    afterReject: function () {

        // If a node is bound to a store, 'update' will be fired from the task store.
        // Required because of the Ext lazy loading of tree nodes.
        // See http://www.sencha.com/forum/showthread.php?180406-4.1B2-TreeStore-inconsistent-firing-of-update
        if (this.stores.length > 0) {
            this.callParent(arguments);
        } else {
            var taskStore = this.getTaskStore(true);

            if (taskStore && !taskStore.isFillingRoot) {
                taskStore.afterReject(this);
            }
            this.callParent(arguments);
        }
    },

    /**
    * Returns the duration unit of the task.  
    * @return {String} the duration unit
    */
    getDurationUnit: function () {
        return this.get(this.durationUnitField) || 'd';
    },
    
    /**
    * @method setDurationUnit
    * 
    * Updates the duration unit of the task.  
    * 
    * @param {String} unit New duration unit
    * @return {String} the duration unit
    */
    
    
    /**
    * Returns the effort unit of the task.  
    * @return {String} the effort unit
    */
    getEffortUnit: function () {
        return this.get(this.effortUnitField) || 'd';
    },
    
    /**
    * @method setEffortUnit
    * 
    * Updates the effort unit of the task.  
    * 
    * @param {String} unit New effort unit
    * @return {String} the effort unit
    */

    
    
    /**
    * Adds the passed task to the collection of child tasks.  
    * @param {Gnt.model.Task} subtask The new subtask
    */
    addSubtask : function(subtask) {
        this.set('leaf', false);
        this.appendChild(subtask);
        
        this.expand();
    },


    /**
    * Adds the passed task as a successor and creates a new dependency between the two tasks.  
    * @param {Gnt.model.Task} (optional) successor The new successor
    */
    addSuccessor : function (successor) {
        var task        = this.rec,
            taskStore   = this.getTaskStore(),
            depStore    = this.getDependencyStore();
        
        successor = successor || new this.self();
        successor.calendar = successor.calendar || this.getCalendar();
        successor.setStartDate(this.getEndDate(), true, taskStore.skipWeekendsDuringDragDrop);
        successor.setDuration(1, Sch.util.Date.DAY);

        this.addTaskBelow(successor);
        
        var newDependency = new depStore.model({
             fromTask   : this,
             toTask     : successor,
             type       : depStore.model.Type.EndToStart
        });
       
        depStore.add(newDependency);
    },

    /**
    * Adds the passed task as a milestone below this task.
    * @param {Gnt.model.Task} (optional) milestone The milestone
    */
    addMilestone : function(milestone) {
        var taskStore = this.getTaskStore();
        milestone = milestone || new this.self();

        var date = this.getEndDate();
        if (date) {
            milestone.calendar = milestone.calendar || this.getCalendar();
            milestone.setStartEndDate(date, date, taskStore.skipWeekendsDuringDragDrop);
        }
        this.addTaskBelow(milestone);
   },

    /**
    * Adds the passed task as a predecessor and creates a new dependency between the two tasks.  
    * @param {Gnt.model.Task} (optional) successor The new successor
    */
    addPredecessor : function(predecessor) {
        var depStore    = this.getDependencyStore();
        
        predecessor = predecessor || new this.self();
        predecessor.calendar = predecessor.calendar || this.getCalendar();
        
        predecessor.beginEdit();
        predecessor.set(this.startDateField, predecessor.calculateStartDate(this.getStartDate(), 1, Sch.util.Date.DAY));
        predecessor.set(this.endDateField, this.getStartDate());
        predecessor.set(this.durationField, 1);
        predecessor.set(this.durationUnitField, Sch.util.Date.DAY);
        predecessor.endEdit();
        
        this.addTaskAbove(predecessor);
        
        var newDependency = new depStore.model({
             fromTask   : predecessor,
             toTask     : this,
             type       : depStore.model.Type.EndToStart
        });

        depStore.add(newDependency);
    },

    /**
    * Returns all tasks that are dependent on this task
    * 
    * @return {Array[Gnt.model.Task]} 
    */
    getSuccessors: function () {
        var id = this.getId() || this.internalId;
        var dependencyStore = dependencyStore || this.getDependencyStore();

        var store = this.getTaskStore(),
            res = [];

        for (var i = 0, len = dependencyStore.getCount(); i < len; i++) {
            var dependency = dependencyStore.getAt(i);

            if (dependency.getSourceId() == id) {
                var task = dependency.getTargetTask();
                
                if (task) {
                    res.push(task);
                }
            }
        }

        return res;
    },

    /**
    * Returns all tasks that this task depends on.
    * 
    * @return {Array[Gnt.model.Task]} 
    */
    getPredecessors: function () {
        var id = this.getId() || this.internalId;
        var dependencyStore = dependencyStore || this.getDependencyStore();

        var store = this.getTaskStore(),
            res = [];

        for (var i = 0, len = dependencyStore.getCount(); i < len; i++) {
            var dependency = dependencyStore.getAt(i);

            if (dependency.getTargetId() == id) {
                res.push(dependency.getSourceTask());
            }
        }

        return res;
    },

    /**
     * @method setPercentDone
     * 
     * Sets the percent complete value of the task
     * 
     * @param {Int} value The new value
     */

    /**
     * @method getPercentDone
     * 
     * Gets the percent complete value of the task
     * @return {Int} The percent complete value of the task
     */

    /**
     * @method getCls
     * 
     * Returns the name of field holding the CSS class for each rendered task element
     * 
     * @return {String} cls The cls field
     */

    /**
     * Adds the passed task (or creates a new task) before itself
     * @param {Gnt.model.Task} (optional) The task to add
     */
    addTaskAbove : function (task) {
        task = task || new this.self();
        
        this.parentNode.insertBefore(task, this);
    },
    
    /**
     * Adds the passed task (or creates a new task) after itself
     * @param {Gnt.model.Task} task (optional) The task to add
     */
    addTaskBelow : function (task) {
        task = task || new this.self();
        
        if (this.nextSibling) {
            this.parentNode.insertBefore(task, this.nextSibling);
        } else {
            this.parentNode.appendChild(task);
        }
    },

    /**
    * @method getBaselineStartDate
    * 
    * Returns the baseline start date of this task
    * 
    * @return {Date} The baseline start date
    */

    /**
    * @method setBaselineStartDate
    * 
    * Sets the baseline start date of this task
    * 
    * @param {Date} date
    */

    /**
    * @method getBaselineEndDate
    * 
    * Returns the baseline end date of this task
    * 
    * @return {Date} The baseline end date
    */

    /**
    * @method setBaselineEndDate
    * 
    * Sets the baseline end date of this task
    * 
    * @param {Date} date
    */

    /**
     * @method setBaselinePercentDone
     * 
     * Sets the baseline percent complete value
     * 
     * @param {Int} value The new value
     */

    /**
     * Gets the baseline percent complete value
     * @return {Int} The percent done level of the task
     */
    getBaselinePercentDone : function() {
        return this.get(this.baselinePercentDoneField) || 0;
    },

    /**
     * Returns true if the Task can be persisted (e.g. task and resource are not 'phantoms')
     * 
     * @return {Boolean} true if this model can be persisted to server.
     */
    isPersistable : function() {
        var parent = this.parentNode;

        return !parent.phantom;
    },

    /**
     * Returns an array of Gnt.model.Resource instances assigned to this Task.
     * 
     * @return {[Gnt.model.Resource]} resources
     */
    getResources : function () {
        var taskStore           = this.getTaskStore(),
            id                  = this.getInternalId(),
            resourceStore       = taskStore.getResourceStore();

        var resources = [];

        taskStore.getAssignmentStore().each(function (assignment) {
            if (assignment.getTaskId() == id) {
                resources.push(assignment.getResource());
            }
        });
        
        return resources;
    },

    
    /**
     * Returns an array of Gnt.model.Assignment instances associated with this Task.
     * 
     * @return {[Gnt.model.Assignment]} resources
     */
    getAssignments : function () {
        var taskStore       = this.getTaskStore(),
            id              = this.getInternalId();

        var assignments     = [];
            
        taskStore.getAssignmentStore().each(function (assignment) {
            if (assignment.getTaskId() == id) {
                assignments.push(assignment);
            }
        });

        return assignments;       
    },
    
    
    /**
     * If given resource is assigned to this task, returns a Gnt.model.Assignment record.
     * Otherwise returns `null`
     * 
     * @param {Gnt.model.Resource/Number} resourceOrId The instance of {@link Gnt.model.Resource} or resource id 
     * 
     * @return {Gnt.model.Assignment} resources
     */
    getAssignmentFor : function (resource) {
        var taskStore       = this.getTaskStore(),
            id              = this.getInternalId(),
            resourceId      = resource instanceof Gnt.model.Resource ? resource.getInternalId() : resource;

        var found;
            
        taskStore.getAssignmentStore().each(function (assignment) {
            if (assignment.getTaskId() == id && assignment.getResourceId() == resourceId) {
                found = assignment;
                
                return false;
            }
        });

        return found || null;       
    },

    
    unassign : function () {
        return this.unAssign.apply(this, arguments);
    },
    
    
    /**
     * Un-assign given resource from this task
     * 
     * @param {Gnt.model.Resource/Number} resourceOrId The instance of {@link Gnt.model.Resource} or resource id
     */
    unAssign : function (resource) {
        var assignmentStore     = this.getAssignmentStore();

        var resourceId          = resource instanceof Gnt.model.Resource ? resource.getInternalId() : resource;
        
        assignmentStore.removeAt(assignmentStore.find('ResourceId', resourceId));
    },
    

    /**
     * Assign given resource to this task.
     * 
     * @param {Gnt.model.Resource/Number} resourceOrId The instance of {@link Gnt.model.Resource} or resource id
     * @param {Number} units The integer value for the {@link #unitsField Units field} of the assignment record.
     */
    assign : function (resource, units) {
        var taskStore       = this.getTaskStore(),
            id              = this.getInternalId(),
            assignmentStore = taskStore.getAssignmentStore(),
            resourceStore   = taskStore.getResourceStore();

        var resourceId      = resource instanceof Gnt.model.Resource ? resource.getInternalId() : resource;

        assignmentStore.each(function (assignment) {
            
            if (assignment.getTaskId() == id && assignment.getResourceId() == resourceId) {
                throw "Resource can't be assigned twice to the same task";
            }            
        });
        
        // add resource to the resource store if its not there (probably a phantom resource record) 
        if (resource instanceof Gnt.model.Resource && resourceStore.indexOf(resource) == -1) {
            resourceStore.add(resource);
        }
        
        // Ext.create('Gnt.model.Assignment') is out of fashion in 4.1.0
        var newAssignment   = new Gnt.model.Assignment({
            'TaskId'        : id,
            'ResourceId'    : resourceId,
            'Units'         : units
        });

        assignmentStore.add(newAssignment);
        
        return newAssignment;
    },
    
    
    // side-effects free method - suitable for use in "normalization" stage
    // calculates the effort based on the assignments information
    calculateEffort : function (startDate, endDate, unit) {
        var totalEffort     = 0;
        
        this.forEachAvailabilityIntervalWithResources({ startDate : startDate, endDate : endDate }, function (intervalStartDate, intervalEndDate, currentAssignments) {
            var totalUnits          = 0;
            
            for (var i in currentAssignments) totalUnits += currentAssignments[ i ].units;
            
            totalEffort             += (intervalEndDate - intervalStartDate) * totalUnits / 100;
        });
        
        return this.getCalendar().convertMSDurationToUnit(totalEffort, unit || this.getEffortUnit());
    },
    
    
    updateAssignments : function () {
        var totalDurationByResource     = {};
        
        var startDate                   = this.getStartDate();
        var endDate                     = this.getEndDate();
        
        var totalTime                   = 0;
        
        this.forEachAvailabilityIntervalWithResources({ startDate : startDate, endDate : endDate }, function (intervalStartDate, intervalEndDate, currentAssignments) {
            
            for (var resourceId in currentAssignments) {
                totalTime               += intervalEndDate - intervalStartDate;
            }
        });
        
        // no available resources?
        if (!totalTime) {
            return; 
        }
        
        var effortInMS      = this.getEffort(Sch.util.Date.MILLI);
        
        Ext.Array.each(this.getAssignments(), function (assignment) {
            assignment.setUnits(effortInMS / totalTime * 100);
        });
    },
    
    
    updateEffortBasedOnDuration : function () {
        this.setEffort(this.calculateEffort(this.getStartDate(), this.getEndDate()));
    },
    
    
    updateDurationBasedOnEffort : function () {
        this.setEndDate(this.calculateEffortDrivenEndDate(this.getStartDate(), this.getEffort(), this.getEffortUnit()), false);
    },
    
    
    onPotentialEffortChange : function () {
        if (this.getSchedulingMode() == 'FixedDuration') {
            this.updateEffortBasedOnDuration();
        }
        
        if (this.getSchedulingMode() == 'DynamicAssignment') {
            this.updateAssignments();
        }
    },
    
    
    onAssignmentMutation : function () {
        if (this.getSchedulingMode() == 'FixedDuration') {
            this.updateEffortBasedOnDuration();
        }
        
        if (this.getSchedulingMode() == 'EffortDriven') {
            this.updateDurationBasedOnEffort();
        }
    },
    
    
    onAssignmentStructureMutation : function () {
        if (this.getSchedulingMode() == 'FixedDuration') {
            this.updateEffortBasedOnDuration();
        }
        
        if (this.getSchedulingMode() == 'EffortDriven') {
            this.updateDurationBasedOnEffort();
        }
        
        if (this.getSchedulingMode() == 'DynamicAssignment') {
            this.updateAssignments();
        }
    },
    
    
    adjustToCalendar : function() {
        if (this.get('leaf') && !this.isManuallyScheduled()) {
            var hasIncoming = this.hasIncomingDependencies();
            
            if (hasIncoming) {
                this.constrain();
            } else {
                this.setStartDate(this.getStartDate(), true, true);
            }
        }
    },
    
    
    /**
     * Checks if given field is editable considering the scheduling mode of this task. For example for 
     * "FixedDuration" mode, the "Effort" field is calculated and should not be updated by user directly. 
     * 
     * @param {String} fieldName Name of the field
     * @return {Boolean} Boolean value, indicating whether the given field is editable
     */
    isEditable : function (fieldName) {
        if ((fieldName === this.durationField || fieldName === this.endDateField) && this.getSchedulingMode() === 'EffortDriven') {
            return false;
        }
        
        if (fieldName === this.effortField && this.getSchedulingMode() === 'FixedDuration') {
            return false;
        }
        
        return true;
    },
    

    ensureSingleSyncForMethod : function() {
        return function() {
            var taskStore = this.getTaskStore(true);
            var weSuspended;

            if (taskStore && taskStore.autoSync && !taskStore.autoSyncSuspended) {
                weSuspended = true;
                taskStore.suspendAutoSync();
            }

            var retVal = this.callParent(arguments);
            
            if (weSuspended) {
                taskStore.resumeAutoSync();
                taskStore.sync();
            }

            return retVal;
        };
    },

    // @PATCH to solve this:
    // http://www.sencha.com/forum/showthread.php?210476-4.1.1-RC1-TreeStore-root-node-issue&p=814781#post814781
    getId : function() {
        var id = this.data[this.idProperty];
        return id && id !== 'root' ? id : null;
    }

}, function() {
    // Do this first to be able to override NodeInterface methods
    Ext.data.NodeInterface.decorate(this);
    
    var potentialBulkUpdateMethods = ['addPredecessor', 'addSubtask', 'addSuccessor', 'indent', 'outdent', 'remove', 'insertBefore', 'appendChild'];
    
    // Manual override of this method, after NodeInterface has decorated our model
    this.override({
        remove : function() {
            var parent = this.parentNode;
            var value = this.callParent(arguments);

            // If the parent has no other children, change it to a leaf task
            if (parent.childNodes.length === 0 && this.getTaskStore().recalculateParents) {
                parent.set('leaf', true);
            }
            
            return value;
        }
    });

    Ext.each(potentialBulkUpdateMethods, function(name) {
        var cfg = {};
        cfg[name] = this.prototype.ensureSingleSyncForMethod(this.prototype[name]);
        this.override(cfg);
    }, this);
});


/**

@class Gnt.data.Calendar
@extends Ext.data.Store

A class representing a customizable calendar with weekends, holidays and availability information for any day. 
Internally, its just a subclass of Ext.data.Store which is supposed to be loaded with a collection 
of {@link Gnt.model.CalendarDay} instances.

* **Note, that this calendar class is configured for backward compatibility and sets whole 24 hours of every day,
as available time. If you are looking for calendar with normal business hours availability, use {@link Gnt.data.calendar.BusinessTime}**


A calendar can be instantiated like this for example: 

    var calendar        = new Gnt.data.Calendar({
        data    : [
            {
                Date            : new Date(2010, 0, 13),
                Cls             : 'gnt-national-holiday'
            },
            {
                Date            : new Date(2010, 1, 1),
                Cls             : 'gnt-company-holiday'
            },
            {
                Date            : new Date(2010, 0, 16),
                IsWorkingDay    : true
            }
        ]
    });
    
It should then be provided as the {@link Gnt.data.TaskStore#calendar configuration option} for the {@link Gnt.data.TaskStore}.

*/
Ext.define('Gnt.data.Calendar', {
    extend      : 'Ext.data.Store',
        
    requires    : [
        'Ext.Date',
        'Gnt.model.CalendarDay',
        'Sch.model.Range',
        'Sch.util.Date'
    ],
    
    model       : 'Gnt.model.CalendarDay',
    
    /**
     * Number of days per month. Will be used when converting the big duration units like month/year to days.
     * 
     * @cfg {Number} daysPerMonth
     */
    daysPerMonth        : 30,
    
    /**
     * Number of days per week. Will be used when converting the duration in weeks to days.
     * 
     * @cfg {Number} daysPerWeek
     */
    daysPerWeek         : 7,
    
    /**
     * Number of hours per day. Will be used when converting the duration in days to hours.
     * 
     * @cfg {Number} hoursPerDay
     */
    hoursPerDay         : 24,
    
    unitsInMs           : null,
    
    defaultNonWorkingTimeCssCls     : 'gnt-holiday',
    
    /**
     * @cfg {Boolean} weekendsAreWorkdays Setting this option to `true` will treat *all* days as working. Default value is `false`.
     * This option can also be specified as the {@link Gnt.panel.Gantt#weekendsAreWorkdays config} of the gantt panel.
     */
    weekendsAreWorkdays             : false,
    
    /**
     * @cfg {Number} weekendFirstDay The index of the first day in weekend, 0 for Sunday, 1 for Monday, 2 for Tuesday, and so on.
     * Default value is 6 - Saturday
     */
    weekendFirstDay                 : 6,
    
    /**
     * @cfg {Number} weekendSecondDay The index of the second day in weekend, 0 for Sunday, 1 for Monday, 2 for Tuesday, and so on.
     * Default value is 0 - Sunday
     */
    weekendSecondDay                : 0,
    
    holidaysCache                   : null,
    availabilityIntervalsCache      : null,
    
    // default availability times for a week, either provided in the config or loaded from server
    // these are "persistent" values, if they will be provided by user, then they'll be added to the store
    weekAvailability                : null,
    
    // the "very default" availability, provided by the class itself - can't be modified on the instance level
    // these are not persistent values and not stored in the store
    defaultWeekAvailability         : null,
    
    nonStandardWeeksByStartDate     : null,
    nonStandardWeeksStartDates      : null,
    
    /**
     * @cfg {String} calendarId The unique id for the calendar. Will be used as the `storeId` internally
     */
    calendarId                      : null,
    
    /**
     * @cfg {String/Gnt.data.Calendar} parent The parent calendar. Can be provided as the calendar id or calendar instance itself. 
     */
    parent                          : null,
    
    /**
     * @cfg {Array[String]} defaultAvailability The array of default availability intervals (in the format of the `Availability` field
     * in the {@link Gnt.model.CalendarDay}) for each working weekday (Monday-Friday). Defaults to whole day (00-24) for backward
     * compatibility.  
     */
    defaultAvailability             : [ '00:00-24:00' ],
    
    /**
     * @cfg {String} name The name of this calendar 
     */
    name                            : null,
    

    statics: {
        getCalendar: function (id) {
            if (id instanceof Gnt.data.Calendar) return id;
            
            return Ext.data.StoreManager.lookup('GNT_CALENDAR:' + id);
        },
        
        
        getAllCalendars : function () {
            var result  = [];
            
            Ext.data.StoreManager.each(function (store) {
                if (store instanceof Gnt.data.Calendar) { 
                    result.push(store); 
                }
            });
            
            return result;
        }
    },   
    
    
    constructor : function (config) {
        if (config.calendarId) {
            this.storeId = 'GNT_CALENDAR:' + config.calendarId;
        }       

        this.callParent(arguments);

        var me          = this;
        var parent      = this.parent = Gnt.data.Calendar.getCalendar(config.parent);
        
        if (config.parent && !this.parent) {
            throw new Error("Invalid parent specified for calendar");
        }

        this.unitsInMs = {
            MILLI       : 1,
            SECOND      : 1000,
            MINUTE      : 60 * 1000,
            HOUR        : 60 * 60 * 1000,
            DAY         : this.hoursPerDay * 60 * 60 * 1000,
            WEEK        : this.daysPerWeek * this.hoursPerDay * 60 * 60 * 1000,
            MONTH       : this.daysPerMonth * this.hoursPerDay * 60 * 60 * 1000,
            QUARTER     : 3 * this.daysPerMonth * 24 * 60 * 60 * 1000,
            YEAR        : 4 * 3 * this.daysPerMonth * 24 * 60 * 60 * 1000
        };
        
        this.defaultWeekAvailability    = this.getDefaultWeekAvailability(this.weekendsAreWorkdays);
        
        Ext.Array.each(config.weekAvailability || [], function (defaultDay, index) {
            if (defaultDay) {
                defaultDay.setDate(new Date(0, 0, index));
                defaultDay.set(defaultDay.idProperty, 'WEEKDAY:' + index);
            }
            
            me.add(defaultDay);
        });
        
        this.holidaysCache                  = {};
        this.availabilityIntervalsCache     = {};

        this.on({
            clear       : this.clearCache,
            datachanged : this.clearCache,
            
            load        : this.updateAvailability,
            
            scope       : this
        });
        parent && parent.on('clearcache', this.clearCache, this);
        
        this.updateAvailability();
    },
    
    
    getDefaultWeekAvailability : function (weekendsAreWorkdays) {
        var availability        = this.defaultAvailability;
        var weekendFirstDay     = this.weekendFirstDay;
        var weekendSecondDay    = this.weekendSecondDay;
        
        var res                 = [];
        
        for (var i = 0; i < 7; i++) {
            res.push(
                weekendsAreWorkdays || i != weekendFirstDay && i != weekendSecondDay ? 
                    new Gnt.model.CalendarDay({Availability    : Ext.Array.clone(availability), IsWorkingDay : true })
                        :
                    new Gnt.model.CalendarDay({Availability    : []  })
            );
        }
        
        return res;
    },
    
    
    // will scan through all calendar days in the store and save references to special ones to the properties, for speedup
    updateAvailability : function () {
        var weekAvailability                = this.weekAvailability             = [];
        var nonStandardWeeksStartDates      = this.nonStandardWeeksStartDates   = [];
        var nonStandardWeeksByStartDate     = this.nonStandardWeeksByStartDate  = {};
        
        this.each(function (calendarDay) {
            var id          = calendarDay.getId();
            var match       = /^(\d)-(\d\d\d\d\/\d\d\/\d\d)-(\d\d\d\d\/\d\d\/\d\d)$/.exec(id);
            
            var weekDay;
            
            if (match) {
                var startDate       = Ext.Date.parse(match[ 2 ], 'Y/m/d') - 0;
                var endDate         = Ext.Date.parse(match[ 3 ], 'Y/m/d') - 0;
                weekDay             = match[ 1 ];
                
                if (!nonStandardWeeksByStartDate[ startDate ]) {
                    nonStandardWeeksByStartDate[ startDate ] = {
                        startDate           : new Date(startDate),
                        endDate             : new Date(endDate),
                        name                : calendarDay.getName(),
                        weekAvailability    : []
                    };

                    nonStandardWeeksStartDates.push(startDate);
                }
                
                nonStandardWeeksByStartDate[ startDate ].weekAvailability[ weekDay ] = calendarDay;
            }
            
            match       = /^WEEKDAY:(\d+)$/.exec(id);
            
            if (match) {
                weekDay             = match[ 1 ];
            
                if (weekDay < 0 || weekDay > 6) { throw new Error("Incorrect week day index"); }
                
                weekAvailability[ weekDay ] = calendarDay;
            }
        });
        
        nonStandardWeeksStartDates.sort();
    },
    
    
    intersectsWithCurrentWeeks : function (startDate, endDate) {
        var nonStandardWeeksStartDates      = this.nonStandardWeeksStartDates;
        var nonStandardWeeksByStartDate     = this.nonStandardWeeksByStartDate;
        
        var result                          = false;
        
        Ext.Array.each(nonStandardWeeksStartDates, function (nonStandardWeekStartDate) {
            var weekStartDate       = nonStandardWeeksByStartDate[ nonStandardWeekStartDate ].startDate;
            var weekEndDate         = nonStandardWeeksByStartDate[ nonStandardWeekStartDate ].endDate;
            
            if (weekStartDate <= startDate && startDate < weekEndDate || weekStartDate < endDate && endDate <= weekEndDate) {
                result      = true;
                
                // stop the iteration
                return false;
            }
        });
        
        return result;
    },
    
    
    addNonStandardWeek : function (startDate, endDate, weekAvailability) {
        startDate       = Ext.Date.clearTime(new Date(startDate));
        endDate         = Ext.Date.clearTime(new Date(endDate));
        
        if (this.intersectsWithCurrentWeeks(startDate, endDate)) {
            throw new Error("Can not add intersecting week");
        }
        
        Ext.Array.each(weekAvailability, function (day, index) {
            if (day) {
                day.set(day.idProperty, index + '-' + Ext.Date.format(startDate, 'Y/m/d') + '-' + Ext.Date.format(endDate, 'Y/m/d'));
            }
        });
        
        startDate       = startDate - 0;
        endDate         = endDate - 0;
        
        this.nonStandardWeeksStartDates.push(startDate);
        this.nonStandardWeeksStartDates.sort();
        
        this.nonStandardWeeksByStartDate[ startDate ] = {
            startDate           : new Date(startDate),
            endDate             : new Date(endDate),
            weekAvailability    : weekAvailability
        };
        
        this.add(Ext.Array.clean(weekAvailability));
    },
    
    
    getNonStandardWeekByStartDate : function (startDate) {
        return this.nonStandardWeeksByStartDate[ Ext.Date.clearTime(new Date(startDate)) - 0 ];
    },
    
    
    getNonStandardWeekByDate : function (timeDate) {
        timeDate        = Ext.Date.clearTime(new Date(timeDate)) - 0;
        
        var nonStandardWeeksStartDates      = this.nonStandardWeeksStartDates;
        var nonStandardWeeksByStartDate     = this.nonStandardWeeksByStartDate;
        
        for (var i = 0; i < nonStandardWeeksStartDates.length; i++){
            var week                = nonStandardWeeksByStartDate[ nonStandardWeeksStartDates[ i ] ];
            
            if (week.startDate <= timeDate && timeDate <= week.endDate) {
                return week;
            }
        }
        
        return null;
    },
    
    
    removeNonStandardWeek : function (startDate) {
        startDate       = Ext.Date.clearTime(new Date(startDate)) - 0;
        
        var week        = this.getNonStandardWeekByStartDate(startDate);
        
        if (!week) return;
        
        this.remove(Ext.Array.clean(week.weekAvailability));
        
        delete this.nonStandardWeeksByStartDate[ startDate ];
        
        Ext.Array.remove(this.nonStandardWeeksStartDates, startDate);
    },
    
    
    clearCache : function () {
        this.holidaysCache                  = {};
        this.availabilityIntervalsCache     = {};

        //to clear the cache in child calendars
        this.fireEvent('clearcache', this);
    },

    
    /**
     * Returns a corresponding {@link Gnt.model.CalendarDay} instance for the given date
     * 
     * @param {Date} timeDate A date (can contain time portion which will be ignored)
     *  
     * @return {Gnt.model.CalendarDay}
     */
    getCalendarDay : function (timeDate) {
        timeDate        = typeof timeDate == 'number' ? new Date(timeDate) : timeDate;
        
        var calendarDay = this.getOverrideDay(timeDate);
        
        if (calendarDay) {
            return calendarDay;
        }
        
        return this.getDefaultCalendarDay(timeDate.getDay(), timeDate);
    },
    
    
    getOverrideDay : function (timeDate) {
        var ownDay      = this.getOwnCalendarDay(timeDate);
        
        if (ownDay) {
            return ownDay;
        }
        
        if (this.parent) {
            return this.parent.getOverrideDay(timeDate);
        }
        
        return null;
    },
    
    
    getOwnCalendarDay : function (timeDate) {
        timeDate        = typeof timeDate == 'number' ? new Date(timeDate) : timeDate;
        
        return this.getById(Ext.Date.clearTime(timeDate, true) - 0);
    },
    
    
    getDefaultCalendarDay : function (weekDayIndex, timeDate) {
        // if 2nd argument is provided then try to search in non-standard weeks first
        if (timeDate) {
            var week        = this.getNonStandardWeekByDate(timeDate);
            
            if (week && week.weekAvailability[ weekDayIndex ]) return week.weekAvailability[ weekDayIndex ];
        }
        
        if (this.weekAvailability[ weekDayIndex ]) {
            return this.weekAvailability[ weekDayIndex ];
        }
        
        if (this.parent) {
            return this.parent.getDefaultCalendarDay(weekDayIndex);
        }
        
        return this.defaultWeekAvailability[ weekDayIndex ];
    },
    
    
    /**
     * Returns a boolean indicating whether a passed date falls on the weekend or holiday.
     * 
     * @param {Date} timeDate A given date (can contain time portion)
     *  
     * @return {Boolean}
     */
    isHoliday : function (timeDate) {
        var secondsSinceEpoch       = timeDate - 0;
        var holidaysCache           = this.holidaysCache;

        if (holidaysCache[ secondsSinceEpoch ] != null) {
            return holidaysCache[ secondsSinceEpoch ];
        }

        timeDate        = typeof timeDate == 'number' ? new Date(timeDate) : timeDate;
        
        var day         = this.getCalendarDay(timeDate);
        
        if (!day) throw "Can't find day for " + timeDate;
        
        return holidaysCache[ secondsSinceEpoch ] = !day.getIsWorkingDay();
    },

    
    isWeekend : function (timeDate) {
        var dayIndex = timeDate.getDay();
        return dayIndex === this.weekendFirstDay || dayIndex === this.weekendSecondDay;
    },
    
    
    /**
     * Returns a boolean indicating whether a passed date is a working day.
     * 
     * @param {Date} timeDate A given date (can contain time portion which will be ignored)
     *  
     * @return {Boolean}
     */
    isWorkingDay : function (timeDate) {
        return !this.isHoliday(timeDate);
    },
    
    
    /**
     * Convert the duration given in milliseconds to a given unit. Uses the {@link #daysPerMonth} configuration option.
     * 
     * @param {Number} durationInMs Duration in milliseconds
     * @param {String} unit Duration unit to which the duration should be converted
     * 
     * @return {Number} converted value
     */
    convertMSDurationToUnit : function (durationInMs, unit) {
        return durationInMs / this.unitsInMs[ Sch.util.Date.getNameOfUnit(unit) ];
    },
    
    
    /**
     * Convert the duration given in some unit to milliseconds. Uses the {@link #daysPerMonth} configuration option.
     * 
     * @param {Number} durationInMs
     * @param {String} unit
     * 
     * @return {Number} converted value
     */
    convertDurationToMs : function (duration, unit) {
        return duration * this.unitsInMs[ Sch.util.Date.getNameOfUnit(unit) ];
    },
    
    
    /**
     * Returns an array of ranges for non-working days between `startDate` and `endDate`. For example normally, given a full month,
     * it will return an array from 4 `Sch.model.Range` instances, containing ranges for the weekends. If some holiday lasts for several days
     * and all {@link Gnt.model.CalendarDay} instances have the same `Cls` value then all days will be combined in single range. 
     * 
     * @param {Date} startDate - A start date of the timeframe to extract the holidays from 
     * @param {Date} endDate - An end date of the timeframe to extract the holidays from 
     * 
     * @return {Array[Sch.model.Range]}
     */
    getHolidaysRanges : function (startDate, endDate, includeWeekends) {
        if (startDate > endDate) {
            Ext.Error.raise("startDate can't be bigger than endDate");
        }
        
        startDate       = Ext.Date.clearTime(startDate, true);
        endDate         = Ext.Date.clearTime(endDate, true);
        
        var ranges          = [],
            currentRange,
            date;
        
        for (date = startDate; date < endDate; date = Sch.util.Date.add(date, Sch.util.Date.DAY, 1)) {
            
            if (this.isHoliday(date) || (this.weekendsAreWorkdays && includeWeekends && this.isWeekend(date))) {
                var day         = this.getCalendarDay(date);
                var cssClass    = day && day.getCls() || this.defaultNonWorkingTimeCssCls;
                
                var nextDate    = Sch.util.Date.add(date, Sch.util.Date.DAY, 1);
                
                // starts new range
                if (!currentRange) {
                    currentRange    = { 
                        StartDate   : date, 
                        EndDate     : nextDate, 
                        Cls         : cssClass
                    };
                } else {
                    // checks if the range is still the same 
                    if (currentRange.Cls == cssClass) {
                        currentRange.EndDate    = nextDate; 
                    } else {
                        ranges.push(currentRange);
                        
                        currentRange    = { 
                            StartDate   : date, 
                            EndDate     : nextDate, 
                            Cls         : cssClass
                        };
                    }
                }
            } else {
                if (currentRange) {
                    ranges.push(currentRange);
                    currentRange = null;
                }
            }
        }
        
        if (currentRange) {
            ranges.push(currentRange);
        }
        
        var models = [];
        
        Ext.each(ranges, function (range) {
            models.push(Ext.create("Sch.model.Range", {
                StartDate       : range.StartDate,
                EndDate         : range.EndDate,
                Cls             : range.Cls
            }));
        });
        
        return models;
    },
    
    
    // monotonically scan through all the availability intervals in the [ startDate, endDate ) range
    forEachAvailabilityInterval : function (startDate, endDate, func, scope) {
        scope       = scope || this;
        startDate   = new Date(startDate);
        
        var DATE    = Sch.util.Date;
        
        while (!endDate || startDate < endDate) {
            var intervals       = this.getAvailabilityIntervalsFor(startDate);
            
            for (var i = 0; i < intervals.length; i++) {
                if (func.call(scope, intervals[ i ]) === false) return false;
            }
            startDate   = DATE.getStartOfNextDay(startDate);
        }
    },
    
    
    // monotonically scan through all the availability intervals starting from endDate in backward direction
    // the endDate here is not inclusive - 02/10/2012 means the end of 02/09/2012
    forEachAvailabilityIntervalBackward : function (endDate, func, scope) {
        scope       = scope || this;
        endDate     = new Date(endDate);
        
        var DATE    = Sch.util.Date;
        
        while (true) {
            // - 1 ensures that we are checking correct day (see comment above)
            var intervals       = this.getAvailabilityIntervalsFor(endDate - 1);
            
            for (var i = 0; i < intervals.length; i++) {
                if (func.call(scope, intervals[ i ]) === false) return false;
            }
            endDate   = DATE.getEndOfPreviousDay(endDate);
        }
    },

    
    // return the duration between 2 dates, taking into account the availability/holidays information
    calculateDuration : function (startDate, endDate, unit) {
        if (startDate > endDate) { 
            Ext.Error.raise("startDate can't be bigger than endDate");
        }
        
        var duration        = 0;
        
        this.forEachAvailabilityInterval(startDate, endDate, function (interval) {
            var intervalStartDate       = interval.startDate;
            var intervalEndDate         = interval.endDate;
            
            // availability interval is out of [ startDate, endDate )
            if (intervalStartDate > endDate || intervalEndDate < startDate) return;
            
            var countingFrom            = intervalStartDate > startDate ? intervalStartDate : startDate;
            var countingTill            = intervalEndDate > endDate ? endDate : intervalEndDate;
            
            duration                    += countingTill - countingFrom;
        });
            
        return this.convertMSDurationToUnit(duration, unit);
    },
    
    
    calculateEndDate : function (startDate, duration, unit) {
        // if duration is 0 - return the same date
        if (!duration) {
            return new Date(startDate);
        }
        
        var endDate;
        
        duration        = this.convertDurationToMs(duration, unit);
        
        var startFrom   = 
            // milestone case, which we don't want to re-schedule to the next business days
            // milestones should starte/end in the same day as its incoming dependency
            duration === 0 && Ext.Date.clearTime(startDate, true) - startDate === 0 ?
            
            Sch.util.Date.add(startDate, Sch.util.Date.DAY, -1) 
                : 
            startDate;
        
        this.forEachAvailabilityInterval(startFrom, null, function (interval) {
            var intervalStartDate       = interval.startDate;
            var intervalEndDate         = interval.endDate;
            
            // availability interval is before our startDate - do nothing
            if (intervalEndDate < startDate) return;
            
            // maximum amount we can count from this interval
            var countingFrom            = intervalStartDate > startDate ? intervalStartDate : startDate;
            var countingTill            = intervalEndDate;
            
            if (countingTill - countingFrom >= duration) {
                endDate                 = new Date(countingFrom - 0 + duration);
                
                return false;
            } else
                duration                -= countingTill - countingFrom;
        });
        
        return endDate;
    },
    

    calculateStartDate : function (endDate, duration, unit) {
        // if duration is 0 - return the same date
        if (!duration) {
            return new Date(endDate);
        }
        
        var startDate;   
        
        duration        = this.convertDurationToMs(duration, unit);
        
        this.forEachAvailabilityIntervalBackward(endDate, function (interval) {
            var intervalStartDate       = interval.startDate;
            var intervalEndDate         = interval.endDate;
            
            // availability interval is before our startDate - do nothing
            if (intervalStartDate > endDate) return;
            
            // maximum amount we can count from this interval
            var countingFrom            = intervalStartDate; 
            var countingTill            = intervalEndDate < endDate ? intervalEndDate : endDate;
            
            if (countingTill - countingFrom >= duration) {
                startDate               = new Date(countingTill - duration);
                
                return false;
            } else
                duration                -= countingTill - countingFrom;
        });
        
        return startDate;
    },

    skipNonWorkingTime : function (date, isForward) {
        while (this.isHoliday(date - (isForward ? 0 : 1))) {
            
            if (isForward) {
                date    = Sch.util.Date.getStartOfNextDay(date, true);
            } else {
                date    = Sch.util.Date.getEndOfPreviousDay(date);
            }
        }
        
        return date;
    },
    
    skipWorkingDays : function(date, amount) {
        var count = 0,
            isForward = amount > 0,
            cursor = Ext.Date.clone(date);
        
        amount = Math.abs(amount);

        while (count < amount) {
            if (!this.isHoliday(cursor - (isForward ? 0 : 1))) {
                count++;
                if (isForward) {
                    cursor    = Sch.util.Date.getStartOfNextDay(cursor, true);
                } else {
                    cursor    = Sch.util.Date.getEndOfPreviousDay(cursor);
                }
            }
            if (isForward || count < amount) {
                cursor = this.skipNonWorkingTime(cursor, isForward);
            }
        }

        // Apply the 'source' hours, minutes etc to the resulting Date
        cursor.setHours(date.getHours());
        cursor.setMinutes(date.getMinutes());
        cursor.setSeconds(date.getSeconds());
        cursor.setMilliseconds(date.getMilliseconds());
        
        return cursor;
    },
    
    
    /**
     * Returns the availability intervals of the concrete day. Potentially can consult a parent calendar. 
     * 
     * @param {Date} timeDate
     * @return {Array[Object]} Array of objects, like:

    {
        startDate       : new Date(...),
        endDate         : new Date(...)
    }
     */
    getAvailabilityIntervalsFor : function (timeDate) {
        timeDate        = Ext.Date.clearTime(new Date(timeDate)) - 0;
        
        if (this.availabilityIntervalsCache[ timeDate ]) return this.availabilityIntervalsCache[ timeDate ]; 
        
        return this.availabilityIntervalsCache[ timeDate ] = this.getCalendarDay(timeDate).getAvailabilityIntervalsFor(timeDate);
    },

    
    getParentableCalendars : function() {
        var me          = this,
            result      = [],
            calendars   = Gnt.data.Calendar.getAllCalendars();

        var isChildOfThis = function (calendar) {
            if (!calendar.parent) return false;

            if (calendar.parent == me) return true;

            return isChildOfThis(calendar.parent);
        };

        Ext.Array.each(calendars, function(calendar){
            if (calendar === me) return;

            if (!isChildOfThis(calendar))
                result.push({Id: calendar.calendarId, Name: calendar.name || calendar.calendarId});
        });

        return result;
    }

});
/**

@class Gnt.data.calendar.BusinessTime
@extends Gnt.data.Calendar

A class representing a customizable calendar with weekends, holidays and availability information for any day. 

This class is basically a subclass of {@link Gnt.data.Calendar}, configured for normal business hours availability, 
you can fine-tune its setting if needed. Default availability hours for every day are 08:00-12:00 and 13:00-17:00 
(can be configured with {@link #defaultAvailability} property.

See also {@link Gnt.data.Calendar} for additional information.

*/
Ext.define('Gnt.data.calendar.BusinessTime', {
    extend              : 'Gnt.data.Calendar',
    
    /**
     * Number of days per month. Will be used when converting the big duration units like month/year to days.
     * 
     * @cfg {Number} daysPerMonth
     */
    daysPerMonth        : 20,

    /**
     * Number of days per week. Will be used when converting the duration in weeks to days.
     * 
     * @cfg {Number} daysPerWeek
     */
    daysPerWeek         : 5,

    /**
     * Number of hours per day. Will be used when converting the duration in days to hours.
     * 
     * @cfg {Number} hoursPerDay
     */
    hoursPerDay         : 8,
    
    /**
     * @cfg {Array[String]} defaultAvailability The array of default availability intervals (in the format of the `Availability` field
     * in the {@link Gnt.model.CalendarDay}) for each working weekday (Monday-Friday). 
     */
    defaultAvailability : [ '08:00-12:00', '13:00-17:00' ]
});
/**

@class Gnt.data.TaskStore
@extends Ext.data.TreeStore

A class representing the tree of tasks in the gantt chart. An individual task is represented as an instance of the {@link Gnt.model.Task} class. The store
expects the data loaded to be hierarchical. Each parent node should contain its children in a property called 'children' (please note that this is different from the old 1.x
version where the task store expected a flat data structure)

Parent tasks
------------

By default, when the start or end date of a task gets changed, its parent task(s) will optionally also be updated. Parent tasks always start at it earliest child and ends
at the end date of its latest child. So be prepared to see several updates and possibly several requests to server. You can batch them with the {@link Ext.data.proxy.Proxy#batchActions} configuration
option.

Overall, this behavior can be controlled with the {@link #recalculateParents} configuration option (defaults to true).

Cascading
---------

In the similar way, when the start/end date of the task gets changed, gantt *can* update any dependent tasks, so they will start on the earliest date possible. 
This behavior is called "cascading" and is enabled or disabled using the {@link #cascadeChanges} configuration option.   

Integration notes
---------

When integrating the Gantt panel with your database, you should persist at least the following properties seen in the class diagram below.

{@img gantt/images/gantt-class-diagram.png}

The bottom 3 properties (`index`, `parentId`, `depth`) of the Task class stem from the {@link Ext.data.NodeInterface} and are required to place the tasks correctly in the tree structure. 

If you store your data in a relational database, below is a suggested Task table definition:

{@img gantt/images/gantt-task-table.png}

 ...as well as a Dependency table definition:

{@img gantt/images/gantt-dependency-table.png}

The types for the fields doesn't have to be as seen above, it's merely a simple suggestion. You could for instance use 'string' or a UID as the type of the Id field.

Your server should respond with a hierarchical structure where parent nodes contain an array or their child nodes in a `children` property. If you don't have any local
sorters, defined on the task store, these child nodes should be sorted by their `index` property before the server responds. 

When creating new task nodes or updating existing ones, the server should always respond with an array of the created/updated tasks. Each task should contain *all* fields. 

*/
Ext.define('Gnt.data.TaskStore', {
    extend      : 'Ext.data.TreeStore',
    
    requires    : [
        'Gnt.model.Task',
        'Gnt.data.Calendar'
    ],
    
    model           : 'Gnt.model.Task',
    
    /**
     * @cfg {Gnt.data.Calendar} calendar A {@link Gnt.data.Calendar calendar} instance to use for this task store. **Should be loaded prior the task store**. 
     * This option can be also specified as the configuration option for the gantt panel. If not provided, a default calendar, containig the weekends
     * only (no holidays) will be created.  
     *  
     */
    calendar        : null,
    
    /**
     * @cfg {Ext.data.Store} dependencyStore A `Ext.data.Store` instance with dependencies information. 
     * This option can be also specified as a configuration option for the gantt panel.  
     *  
     */
    dependencyStore : null,


    resourceStore   : null,
    assignmentStore : null,
    
    /**
     * @cfg {Boolean} weekendsAreWorkdays This option will be translated to the {@link Gnt.data.Calendar#weekendsAreWorkdays corresponding option} of the calendar.  
     *  
     */
    weekendsAreWorkdays    : false,
    

    /**
     * @cfg {Boolean} buffered Set this option to `true` to activate the "buffered" mode. When using this option, your gantt 
     * will only render a part of the whole dataset, effectively allowing you to have unlimited number of tasks in the project.
     *  
     */
    // will only be used in Lockable mixin to setup the NodeStores on tree views as buffered
    buffered        : false,
    
    
    /**
     * @cfg {Number} pageSize When using `buffered : true` this option will allow you to specify the size of the page - ie how many 
     * rows should be rendered in the gantt. When scrolling, new rows will replaces the old ones.
     */
    pageSize        : null,
    
    /**
     * @cfg {Boolean} cascadeChanges A boolean flag indicating whether a change in some task should be propagated to its depended tasks. Defaults to `false`.
     * This option can be also specified as the configuration option for the gantt panel.  
     */
    cascadeChanges          : false,

    /**
     * @cfg {Boolean} batchSync true to batch sync request for 500ms allowing cascade operations, or any other task change with side effects to be batched into one sync call. Defaults to true.
     */
    batchSync : true,

    /**
     * @cfg {Boolean} recalculateParents A boolean flag indicating whether a change in some task should update its parent task. Defaults to `true`.
     * This option can be also specified as the configuration option for the gantt panel.  
     */
    recalculateParents      : true,
    
    /**
     * @cfg {Boolean} skipWeekendsDuringDragDrop A boolean flag indicating whether a task should be moved to the next working day if it falls on holiday,
     * during move/resize operations. Defaults to `true`.
     * This option can be also specified as the configuration option for the gantt panel.  
     */
    skipWeekendsDuringDragDrop  : true,
    
    /**
    * @cfg {Int} cascadeDelay If you usually have deeply nested dependencies, it might be a good idea to add a small delay
    * to allow the modified record to be refreshed in the UI right away and then handle the cascading
    */
    cascadeDelay    : 0,
    cascading       : false,
    
    isFillingRoot   : false,
    
    
    
    constructor : function (config) {
        this.addEvents(
            'root-fill-start', 
            'root-fill-end',
            
            /**
             * Will be fired on the call to `filter` method
             * @event filter
             * @param {Gnt.data.TaskStore} self This task store
             * @param {Object} args The arguments passed to `filter` method
             */
            'filter',
            
            /**
             * Will be fired on the call to `clearFilter` method
             * @event clearfilter
             * @param {Gnt.data.TaskStore} self This task store
             * @param {Object} args The arguments passed to `clearFilter` method
             */
            'clearfilter',

            /**
            * @event beforecascade
            * Fires before a cascade operation is initiated
            * @param {Gnt.data.Store} store The task store
            */
            'beforecascade',

            /**
            * @event cascade
            * Fires when after a cascade operation has completed
            * @param {Gnt.data.Store} store The task store
            * @param {Object} context A context object revealing details of the cascade operation, such as 'nbrAffected' - how many tasks were affected.
            */
            'cascade'
        );
        
        config      = config || {};
        
        if (!config.calendar) {
            var calendarConfig  = {};
            
            if (config.hasOwnProperty('weekendsAreWorkdays')) {
                calendarConfig.weekendsAreWorkdays = config.weekendsAreWorkdays;
            } else {
                 if (this.self.prototype.hasOwnProperty('weekendsAreWorkdays') && this.self != Gnt.data.TaskStore) {
                    calendarConfig.weekendsAreWorkdays = this.weekendsAreWorkdays;
                 }
            }
            
            config.calendar     = new Gnt.data.Calendar(calendarConfig);
        }
        
        // need to init the "hasListeners" hash
        this.hasListeners = {};
        
        this.on({
            remove      : this.onTaskDeleted,
            beforesync  : this.onTaskStoreBeforeSync,
            write       : this.onTaskStoreWrite,
            
            scope       : this
        });
        
        var dependencyStore = config.dependencyStore;

        if (dependencyStore) {
            delete config.dependencyStore;
            
            this.setDependencyStore(dependencyStore);
        }

        var resourceStore = config.resourceStore;
        
        if (resourceStore) {
            delete config.resourceStore;
            
            this.setResourceStore(resourceStore);
        }

        var assignmentStore = config.assignmentStore;
        
        if (assignmentStore) {
            delete config.assignmentStore;
            
            this.setAssignmentStore(assignmentStore);
        }
        
        var calendar        = config.calendar;
        
        if (calendar) {
            delete config.calendar;
            
            this.setCalendar(calendar);
        }
        
        this.callParent([ config ]);
        
        if (Ext.data.reader.Xml && this.getProxy().getReader() instanceof Ext.data.reader.Xml) {
            Ext.override(this.getProxy().getReader(), {
                // http://www.sencha.com/forum/showthread.php?136404-INFOREQ-4.0.2-RC3-Returning-nested-XML-data-for-a-Tree-doesn-t-work...
                extractData: function(root) {
                    var recordName = this.record;
        
                    if (recordName != root.nodeName) {
                        root = Ext.DomQuery.select('>' + recordName, root);
                    } else {
                        root = [root];
                    }
                    return Ext.data.reader.Xml.superclass.extractData.apply(this, [root]);
                }
            });
        }

        if (this.autoSync && this.batchSync) {
            // Prevent operations with side effects to create lots of individual server requests
            this.sync = Ext.Function.createBuffered(this.sync, 500);
        }
    },

    onNodeAdded : function (parent, node) {
        if (!node.normalized && !node.isRoot()) {
            node.normalize();
        }
        // IE breaks when loading nested xml nodes
        if (Ext.isIE) {
            var me = this,
                proxy = me.getProxy(),
                reader = proxy.getReader(),
                data = node.raw || node[node.persistenceProperty],
                dataRoot;

            Ext.Array.remove(me.removed, node);

            if (!node.isLeaf()) {
                dataRoot = reader.getRoot(data);
                if (dataRoot) {
                    me.fillNode(node, reader.extractData(dataRoot));
                    if (data[reader.root]) {        // MODIFIED, ADDED IF CHECK
                        delete data[reader.root];
                    }
                }
            }

            if (me.autoSync && !me.autoSyncSuspended && (node.phantom || node.dirty)) {
                me.sync();
            }
        } else {
            this.callParent(arguments);
        }
    },
    
    
    setRootNode : function () {
        var me      = this;
        
        this.tree.setRootNode = Ext.Function.createInterceptor(this.tree.setRootNode, function (rootNode) {
            
            Ext.apply(rootNode, {
                calendar            : me.calendar,
                taskStore           : me,
                dependencyStore     : me.dependencyStore,
                
                // HACK Prevent tree store from trying to 'create' the root node
                phantom             : false,
                dirty               : false
            });
        });
        
        var res = this.callParent(arguments);
        
        delete this.tree.setRootNode;
        
        return res;
    },
    
    
    // much faster implementation of `fillNode` method for buffered case which uses `node.appendChild` with `suppressEvent` option
    // and bypasses all the events fireing/bubbling machinery, calling the `onNodeAdded` directly
    fillNode : function (node, records) {
        // To be able to prevent recalculating parents after an incremental parent node load
        this.isFillingNode = true;

        if (node.isRoot()) {
            this.isFillingRoot = true;
            
//            console.profile('fillRoot')
//            console.time('fillRoot')
            
            // only monitor the updates after the initial loading (performance for buffered case)
            this.un({
                remove      : this.onNodeUpdated,
                append      : this.onNodeUpdated,
                insert      : this.onNodeUpdated,
                
                update      : this.onTaskUpdated,
                
                scope       : this
            });
            
            this.fireEvent('root-fill-start', this, node, records);
        }
        
        var me = this,
            ln = records ? records.length : 0,
            i = 0, sortCollection;

        if (ln && me.sortOnLoad && !me.remoteSort && me.sorters && me.sorters.items) {
            sortCollection = Ext.create('Ext.util.MixedCollection');
            sortCollection.addAll(records);
            sortCollection.sort(me.sorters.items);
            records = sortCollection.items;
        }
        
        node.set('loaded', true);
        
        if (this.buffered) {
        
            for (; i < ln; i++) {
                var record              = records[ i ];
                record.__isFilling__    = true;
                
                // suppress the events -------|
                //                           \/            
                node.appendChild(record, true, true);
                
                // directly call 'onNodeAdded'
                this.onNodeAdded(null, record);
                
                // register the node in tree (for `getNodeById` to work properly)
                this.tree.registerNode(record);
            }
        } else {
            for (; i < ln; i++) {
                // this will prevent `getModifiedFieldNames` from doing costly
                // isDate comparison 100 thousands times (for 1000 tasks store)
                // see the override trick for `getModifiedFieldNames` in Gnt.model.Task
                records[ i ].__isFilling__    = true;
                
                node.appendChild(records[i], false, true);
            }
        }
            
        if (node.isRoot()) {
            this.getRootNode().cascadeBy(function (record) {
                delete record.__isFilling__;
            });
            
            this.isFillingRoot = false;
            
//            console.profileEnd('fillRoot')
//            console.timeEnd('fillRoot')
            
            // only monitor the updates after the initial loading (performance for buffered case)
            this.on({
                remove      : this.onNodeUpdated,
                append      : this.onNodeUpdated,
                insert      : this.onNodeUpdated,
                
                update      : this.onTaskUpdated,
                
                scope       : this
            });
            
            this.fireEvent('root-fill-end', this, node, records);
        }
        
        delete this.isFillingNode;
        return records;
    },
    
    
    /**
     * Returns a task by its `id`, should be removed in 2.2 since 4.1.1 adds support for this in TreeStore
     * 
     * @param {String} id
     * @return {Gnt.model.Task}
     */
    getById : function (id) {
        return this.tree.getNodeById(id);
    },
    
    
    /**
     * Sets the dependency store for this task store
     * 
     * @param {Ext.data.Store} dependencyStore
     */
    setDependencyStore : function (dependencyStore) {
        if (this.dependencyStore) {
            this.dependencyStore.un({
                add         : this.onDependencyAddOrUpdate,
                update      : this.onDependencyAddOrUpdate,
                beforesync  : this.onBeforeDependencySync,
                
                scope       : this
            });
        }
        
        this.dependencyStore    = Ext.StoreMgr.lookup(dependencyStore);
        
        if (dependencyStore) {
            dependencyStore.taskStore   = this;
            
            dependencyStore.on({
                add         : this.onDependencyAddOrUpdate,
                update      : this.onDependencyAddOrUpdate,

                scope       : this
            });
        }
        
        
//        var root                = this.getRootNode();
//        
//        if (root) {
//            root.dependencyStore    = dependencyStore;
//        }
    },

    /**
     * Sets the resource store for this task store
     * 
     * @param {Ext.data.Store} resourceStore
     */
    setResourceStore : function (resourceStore) {
        this.resourceStore    = Ext.StoreMgr.lookup(resourceStore);
        
        resourceStore.taskStore = this;        
        
//        var root                = this.getRootNode();
//        
//        if (root) {
//            root.resourceStore    = resourceStore;
//        }        
    },

    getResourceStore : function(){
        return this.resourceStore || null;
    },
    
    
    /**
     * Sets the assignment store for this task store
     * 
     * @param {Ext.data.Store} assignmentStore
     */
    setAssignmentStore : function (assignmentStore) {
        if (this.assignmentStore) {
            this.assignmentStore.un({
                add         : this.onAssignmentStructureMutation,
                update      : this.onAssignmentMutation,
                remove      : this.onAssignmentStructureMutation,
                
                scope       : this
            });
        }
        
        this.assignmentStore    = Ext.StoreMgr.lookup(assignmentStore);
        
        assignmentStore.taskStore = this;
        
        assignmentStore.on({
            add         : this.onAssignmentStructureMutation,
            update      : this.onAssignmentMutation,
            remove      : this.onAssignmentStructureMutation,
            
            scope       : this
        });

//        var root                = this.getRootNode();
//        
//        if (root) {
//            root.assignmentStore    = assignmentStore;
//        }         
    },
    
    getAssignmentStore : function(){
        return this.assignmentStore || null;
    },
    
    
    /**
     * Call this method if you want to adjust the tasks according to the calendar dates.
     */
    renormalizeTasks : function() {
        this.getRootNode().cascadeBy(function(node) {
            node.adjustToCalendar();
        });
    },
    
     
    getCalendar: function(){
        return this.calendar || null;    
    },
    
    /**
     * Sets the calendar for this task store
     * 
     * @param {Gnt.data.Calendar} calendar
     */
    setCalendar : function (calendar) {
        var listeners = {
            datachanged : this.renormalizeTasks,
            clear       : this.renormalizeTasks,
            
            scope       : this
        };

        if (this.calendar) {
            this.calendar.un(listeners);
        }

        this.calendar           = calendar;
        
        calendar.on(listeners);

//        var root                = this.getRootNode();
//        
//        if (root) {
//            root.calendar       = calendar;
//        }
    },
    
    
    /**
     * Will just fire the `filter` event for now, as there's no native TreeStore filtering in ExtJS. The gantt chart however listens
     * this event and performs filtering on the underlying NodeStore. So the filtering will work, but it requires the presence of
     * the gantt panel.
     */
    filter : function () {
        this.fireEvent('filter', this, arguments);
    },
    
    
    /**
     * Will just fire the `clearfilter` event for now, as there's no native TreeStore filtering in ExtJS. The gantt chart however listens
     * this event and performs filtering on the underlying NodeStore. So, the filtering will work, but it requires the presence of
     * gantt panel.
     */
    clearFilter : function () {
        this.fireEvent('clearfilter', this);
    },
    
    
    /**
    * Returns the critical path(s) that can affect the end date of the project
    * @return {Array} paths An array of arrays (containing task chains)
    */
    getCriticalPaths: function () {
        // Grab task id's that don't have any "incoming" dependencies
        var root                = this.getRootNode(),
            finalTasks          = [],
            lastTaskEndDate     = new Date(0);

        root.cascadeBy(function (task) {
            lastTaskEndDate = Sch.util.Date.max(task.getEndDate(), lastTaskEndDate);
        });

        root.cascadeBy(function (task) { 
            if (lastTaskEndDate - task.getEndDate() === 0 && !task.isRoot()) {
                finalTasks.push(task);
            } 
        });
        
        var cPaths  = [];
            
        Ext.each(finalTasks, function (task) {
            cPaths.push(task.getCriticalPaths());
        });
        
        return cPaths;
    },
    
    onNodeUpdated : function (parent, node) {
        if (!this.cascading && this.recalculateParents && !this.isFillingNode) {
            node.recalculateParents();
        }
    },
    
    onTaskUpdated: function (store, task, operation) {
        var prev = task.previous;
        
        // We're only interested in operations that affect the start/end dates
        if (!this.cascading && !this.isFillingNode &&
            operation !== Ext.data.Model.COMMIT &&
            (prev && (task.startDateField in prev || task.endDateField in prev || "parentId" in prev))) {
            
            if (this.cascadeChanges) {
                Ext.Function.defer(this.cascadeChangesForTask, this.cascadeDelay, this, [ task ]);
            }  
            
            if (this.recalculateParents) {
                task.recalculateParents();
            }
        }
    },

    /**
     * Cascade the updates to the depended tasks of given `task` (re-schedule them as soon as possible). 
     * 
     * @param {Gnt.model.Task} task
     */
    cascadeChangesForTask : function (task) {
        
        var me      = this,
            context = { nbrAffected : 0 } ;
        
        Ext.each(task.getOutgoingDependencies(), function (dependency) {
            
            var dependentTask = dependency.getTargetTask();
            
            if (dependentTask) {
                if (!me.cascading) {
                    me.fireEvent('beforecascade', me);

//                    for now, there's no reason to suspend events on the TaskStore, as they'll be suspended on the "NodeStore"
//                    however if at some day Sencha will merge the NodeStore to task store
//                    this should be uncommented
//                    me.suspendEvents(true);
                }
                
                me.cascading = true;
                
                dependentTask.cascadeChanges(me, context);
            }
        });

//        me.resumeEvents();
        
        if (me.cascading) {
            me.cascading = false;
            
            me.fireEvent('cascade', me, context);
        }
    },
    
    
    onTaskDeleted: function (node, removedNode) {
        if (!removedNode.isReplace && !removedNode.isMove) {
            var dependencyStore     = this.dependencyStore;

            dependencyStore.remove(removedNode.getAllDependencies(dependencyStore));
        }
    },
    
    
    onAssignmentMutation : function (assignmentStore, assignments) {
        var me      = this;
        
        Ext.each(assignments, function (assignment) {
            // Taskstore could be filtered etc.
            var t = assignment.getTask(me);
            if (t) {
                t.onAssignmentMutation(assignment);
            }
        });
    },
    
    
    onAssignmentStructureMutation : function (assignmentStore, assignments) {
        var me      = this;
        
        Ext.each(assignments, function (assignment) {
            assignment.getTask(me).onAssignmentStructureMutation(assignment);
        });
    },
    
    
    onDependencyAddOrUpdate: function (store, dependencies) {
        // If cascade changes is activated, adjust the connected task start/end date
        if (this.cascadeChanges) {
            var me      = this,
                task;
            
            Ext.each(dependencies, function (dependency) {
                task = dependency.getTargetTask();
                if (task) {
                    task.constrain(me);
                }
            });
        }
    },
    
    // pass "this" to filter function
    getNewRecords: function() {
        return Ext.Array.filter(this.tree.flatten(), this.filterNew, this);
    },

    // pass "this" to filter function
    getUpdatedRecords: function() {
        return Ext.Array.filter(this.tree.flatten(), this.filterUpdated, this);
    },
    
    
    // ignore root
    filterNew: function(item) {
        // only want phantom records that are valid
        return item.phantom === true && item.isValid() && item != this.tree.root;
    },
    
    
    // ignore root
    filterUpdated: function(item) {
        // only want dirty records, not phantoms that are valid
        return item.dirty === true && item.phantom !== true && item.isValid() && item != this.tree.root;
    },
    
    onTaskStoreBeforeSync: function (records, options) {
        var recordsToCreate     = records.create;
        
        if (recordsToCreate) {
            for (var r, i = recordsToCreate.length - 1; i >= 0; i--) {
                r = recordsToCreate[i];
                
                // HACK, save the phantom id to be able to replace the task phantom task id's in the dependency store
                if (r.isPersistable()) {
                    r._phantomId = r.internalId;
                } else {
                    // Remove records that cannot yet be persisted (if parent is a phantom)
                    Ext.Array.remove(recordsToCreate, r);
                }
            }

            // Prevent empty create request 
            if (recordsToCreate.length === 0) {
                delete records.create;
            }
        }
        return Boolean((records.create  && records.create.length  > 0) ||
                        (records.update  && records.update.length  > 0) || 
                        (records.destroy && records.destroy.length > 0));
    },

    onTaskStoreWrite : function(store, operation) {
        
        if (operation.action !== 'create') {
            return;
        }
        
        var records = operation.getRecords(),
            dependencyStore = this.dependencyStore,
            taskId;

        Ext.each(records, function(task) {
            taskId = task.getId();

            if (!task.phantom && taskId !== task._phantomId) {
                Ext.each(dependencyStore.getNewRecords(), function (dep) {
                    var from = dep.getSourceId();
                    var to = dep.getTargetId();
                        
                    // If dependency store is configured with autoSync, the 'set' operations below will trigger a Create action 
                    // to setup the new "proper" dependencies
                    if (from === task._phantomId) {
                        dep.setSourceId(taskId);
                    } else if (to === task._phantomId) {
                        dep.setTargetId(taskId);
                    }
                });

                Ext.each(task.childNodes, function(child) {
                    if (child.phantom) {
                        child.set('parentId', taskId);
                    }
                });

                delete task._phantomId;
            }
        });
    },

    /**
     * Returns an object defining the earliest start date and the latest end date of all the tasks in the store.
     * 
     * @return {Object} An object with 'start' and 'end' Date properties.
     */
    getTotalTimeSpan : function() {
        var earliest = new Date(9999,0,1), latest = new Date(0), D = Sch.util.Date;
        
        this.getRootNode().cascadeBy(function(r) {
            if (r.getStartDate()) {
                earliest = D.min(r.getStartDate(), earliest);
            }
            if (r.getEndDate()) {
                latest = D.max(r.getEndDate(), latest);
            }
        });

        earliest = earliest < new Date(9999,0,1) ? earliest : null;
        latest = latest > new Date(0) ? latest : null;

        return {
            start : earliest,
            end : latest || earliest || null
        };
    },

    /**
     * Cascades the tree and counts all nodes.  Please note, this method will not count nodes that are supposed to be loaded lazily - it will only count nodes "physically" present in the store.
     * 
     * @return {Boolean} (optional) ignoreRoot true to ignore counting the root node of the tree (defaults to true)
     * @return {Int} The number of tasks currently loaded in the store
     */
    getCount : function(ignoreRoot) {
        var count = ignoreRoot === false ? 0 : -1;
        this.getRootNode().cascadeBy(function() { count++; });
        return count;
    },

    /**
     * Returns an array of all the tasks in this store.
     * 
     * @return {[Gnt.model.Task]} The tasks currently loaded in the store
     */
    toArray : function() {
        var tasks = [];

        this.getRootNode().cascadeBy(function(t) {
            tasks.push(t);
        });

        return tasks;
    },

    /**
     * Removes one or more tasks from the store
     * 
     * @param {Gnt.model.Task/Gnt.model.Task[]} tasks The task(s) to remove
     */
    remove : function(records) {
        Ext.each(records, function(t) {
            t.remove();
        });
    },

    /**
    * Increase the indendation level of one or more tasks in the tree 
    * @param {Gnt.model.Task/Gnt.model.Task[]} tasks The task(s) to indent
    */
    indent: function (nodes) {
        nodes = Ext.isArray(nodes) ? nodes : [nodes];
        var sorted = Ext.Array.sort(nodes, function(a, b) { return a.data.index > b.data.index; });
        
        Ext.each(sorted, function(node) { node.indent(); });
    },


    /**
    * Decrease the indendation level of one or more tasks in the tree 
    * @param {Gnt.model.Task/Gnt.model.Task[]} tasks The task(s) to outdent
    */
    outdent: function (nodes) {
        var sorted = Ext.Array.sort(nodes, function(a, b) { return a.data.index > b.data.index; });
        Ext.each(sorted, function(node) { node.indent(); });

        Ext.each(nodes, function(node) { node.outdent(); });
    },

    /**
    * Returns the tasks associated with a resource
    * @param {Gnt.model.Resource} resource
    * @return {Gnt.model.Task[]} the tasks assigned to this resource
    */
    getTasksForResource: function (resource) {
        return resource.getTasks();
    },

    getEventsForResource: function (resource) {
        return this.getTasksForResource(resource);
    },

    ensureSingleSyncForMethod : function() {
        return function() {
            var weSuspended;

            if (this.autoSync && !this.autoSyncSuspended) {
                weSuspended = true;
                this.suspendAutoSync();
            }

            var retVal = this.callParent(arguments);
            
            if (weSuspended) {
                this.resumeAutoSync();
                this.sync();
            }

            return retVal;
        };
    }
}, function() {
    
    // Methods that can have side effects
    var potentialBulkUpdateMethods = ['indent', 'outdent', 'afterEdit', 'remove'];
    
    Ext.each(potentialBulkUpdateMethods, function(name) {
        var cfg = {};
        cfg[name] = this.prototype.ensureSingleSyncForMethod(this.prototype[name]);
        this.override(cfg);
    }, this);
});
/**

@class Gnt.data.DependencyStore
@extends Ext.data.Store

A class representing the collection of the dependencies between the tasks in the {@link Gnt.data.TaskStore}.

Contains the collection of {@link Gnt.model.Dependency} records.

*/
Ext.define('Gnt.data.DependencyStore', {
    extend      : 'Ext.data.Store',
    
    model           : 'Gnt.model.Dependency',
    
    constructor : function() {
        this.callParent(arguments);
        this.init();
    },

    init : function() {
        this.on({
            beforesync  : this.onBeforeSyncOperation,
            scope : this
        });
    },

    onBeforeSyncOperation: function (records, options) {
        if (records.create) {
            for (var r, i = records.create.length - 1; i >= 0; i--) {
                r = records.create[i];
                    
                // Remove records that cannot yet be persisted (involving phantom tasks)
                if (!r.isPersistable()) {
                    Ext.Array.remove(records.create, r);
                }
            }

            // Prevent empty create request 
            if (records.create.length === 0) {
                delete records.create;
            }
        }

        return Boolean((records.create  && records.create.length  > 0) ||
                       (records.update  && records.update.length  > 0) || 
                       (records.destroy && records.destroy.length > 0));
    },

    /**
    * Returns all dependencies of for a certain task (both incoming and outgoing)
    * 
    * @param {Gnt.model.Task} task
    * 
    * @return {Array[Gnt.model.Dependency]} 
    */
    getDependenciesForTask : function(task) {
        var id = task.getId() || task.internalId;
        
        var res = [],
            me = this;

        for (var i = 0, len = me.getCount(); i < len; i++) {
            var dependency = me.getAt(i);

            if (dependency.getSourceId() == id || dependency.getTargetId() == id) {
                res.push(dependency);
            }
        }

        return res;
    },

    /**
    * Returns all incoming dependencies of this task
    * 
    * @param {Gnt.model.Task} task
    * 
    * @return {Array[Gnt.model.Dependency]} 
    */
    getIncomingDependenciesForTask: function (task) {
        var id = task.getId() || task.internalId;

        var res = [],
            me = this;

        for (var i = 0, len = me.getCount(); i < len; i++) {
            var dependency = me.getAt(i);

            if (dependency.getTargetId() == id) {
                res.push(dependency);
            }
        }

        return res;
    },


    /**
    * Returns all outcoming dependencies of a task
    * 
    * @param {Gnt.model.Task} task
    * 
    * @return {Array[Gnt.model.Dependency]} 
    */
    getOutgoingDependenciesForTask: function (task) {
        var id = task.getId() || task.internalId;

        var res = [],
            me = this;

        for (var i = 0, len = me.getCount(); i < len; i++) {
            var dependency = me.getAt(i);

            if (dependency.getSourceId() == id) {
                res.push(dependency);
            }
        }

        return res;
    },

    /**
     * Returns `true` if there is a dependency (either "normal" or "transitive") between tasks
     * with `sourceId` and `targetId`
     * 
     * @param {String} sourceId
     * @param {String} targetId
     * @return {Boolean}
     */
    hasTransitiveDependency: function (sourceId, targetId, depRecord) {
        var me = this;
        
        return this.findBy(function (dependency) {
            
            var toId    = dependency.getTargetId();
            
            if (dependency.getSourceId() === sourceId) {
                return (toId === targetId && dependency !== depRecord) ? true : me.hasTransitiveDependency(dependency.getTargetId(), targetId, depRecord);
            }
        }) >= 0;
    },

    /**
     * Returns `true` if a proposed link between two tasks is valid.
     * These scenarios are considered invalid: 
     * - a task linking to itself
     * - a dependency between a child and one of its parent 
     * - transitive dependencies, e.g. if A -> B, B -> C, then A -> C is not valid 
     * 
     * @param {Gnt.model.Dependency/Mixed} dependencyOrFromId Either a dependency or the source task id
     * @param {Mixed} toId The target task id
     * @return {Boolean}
     */
    isValidDependency : function (dependencyOrFromId, toId, fromModel) {
        var valid = true;
        var fromId, fromTask, toTask;
            
        // Normalize input
        if (dependencyOrFromId instanceof Gnt.model.Dependency) {
            fromId = dependencyOrFromId.getSourceId();
            fromTask = this.getSourceTask(fromId);
            toId = dependencyOrFromId.getTargetId();
            toTask = this.getTargetTask(toId);
        } else {
            fromId = dependencyOrFromId;
            fromTask = this.getSourceTask(fromId);
            toTask = this.getTargetTask(toId);
        }

        if (!fromModel && dependencyOrFromId instanceof Gnt.model.Dependency) {
            valid = dependencyOrFromId.isValid();
        } else {
            valid = fromId && toId && fromId !== toId;
        }

        if (valid) {
            if (fromTask && toTask && (fromTask.contains(toTask) || toTask.contains(fromTask))) {
                valid = false;
            }

            var modelInput = fromModel || (dependencyOrFromId instanceof Gnt.model.Dependency);

            if (valid && ((!modelInput && this.areTasksLinked(fromId, toId)) || this.hasTransitiveDependency(toId, fromId, modelInput ? dependencyOrFromId : null))) {
                valid = false;
            }
        }

        return valid;
    },

    /**
    * Returns true if there is a direct dependency between the two tasks
    * @param {Gnt.model.Dependency} fromTaskOrId The source task or id
    * @param {Gnt.model.Dependency} toTaskOrId The target task or id
    * @return {Boolean} 
    */
    areTasksLinked : function(fromTaskOrId, toTaskOrId) {
        var me = this;
        
        fromTaskOrId = fromTaskOrId instanceof Gnt.model.Task ? (fromTaskOrId.getId() || fromTaskOrId.internalId) : fromTaskOrId;
        toTaskOrId = toTaskOrId instanceof Gnt.model.Task ? (toTaskOrId.getId() || toTaskOrId.internalId) : toTaskOrId;

        return this.findBy(function (dependency) {
            
            var toId    = dependency.getTargetId(),
                fromId = dependency.getSourceId();
            
            if ((fromId === fromTaskOrId && toId === toTaskOrId) ||  
                (fromId === toTaskOrId && toId === toTaskOrId)) {
                return true;
            }
        }) >= 0;
    },

    /**
    * Returns the source task of the dependency
    * @param {Gnt.model.Dependency} The dependency
    * @return {Gnt.model.Task} The source task of this dependency
    */
    getSourceTask : function(dependencyOrId) {
        var id = dependencyOrId instanceof Gnt.model.Dependency ? dependency.getSourceId() : dependencyOrId;
        return this.getTaskStore().getById(id);
    },

    /**
    * Returns the target task of the dependency
    * @param {Gnt.model.Dependency} The dependency
    * @return {Gnt.model.Task} The target task of this dependency
    */
    getTargetTask : function(dependencyOrId) {
        var id = dependencyOrId instanceof Gnt.model.Dependency ? dependency.getSourceId() : dependencyOrId;
        return this.getTaskStore().getById(id);
    },

    
    /**
     * Returns the {@link Gnt.data.TaskStore} instance, to which this dependency store is attached.
     * @return {Gnt.data.TaskStore}
     */
    getTaskStore : function() {
        return this.taskStore;
    }
});
/**
@class Gnt.data.ResourceStore
@extends Sch.data.ResourceStore

A class representing the collection of the resources - {@link Gnt.model.Resource} records.

*/

Ext.define('Gnt.data.ResourceStore', {
    
    requires    : [
        'Gnt.model.Resource'
    ],
    
    extend      : 'Sch.data.ResourceStore',
    
    
    model       : 'Gnt.model.Resource',
    
    
    /**
     * @property {Gnt.data.TaskStore} taskStore The task store to which this resource store is associated.
     * Usually is configured automatically, by the task store itself.   
     */
    taskStore   : null,
    

    /**
     * Returns the associated task store instance.
     * 
     * @return {Gnt.data.TaskStore}
     */
    getTaskStore: function(){
        return this.taskStore || null;
    },

    
    /**
     * Returns the associated assignment store instance.
     * 
     * @return {Gnt.data.AssignmentStore}
     */
    getAssignmentStore: function(){
        return this.assignmentStore || null;
    },
    
    
    getByInternalId : function (id) {
        return this.data.getByKey(id) || this.getById(id);
    }
});
/**
@class Gnt.data.AssignmentStore
@extends Ext.data.Store

A class representing the collection of the assignments between the tasks in the {@link Gnt.data.TaskStore} and resources
in the {@link Gnt.data.ResourceStore}.

Contains the collection of {@link Gnt.model.Assignment} records.

*/

Ext.define('Gnt.data.AssignmentStore', {
    
    requires    : [
        'Gnt.model.Assignment'
    ],
    
    extend      : 'Ext.data.Store',
    
    
    model       : 'Gnt.model.Assignment',

    /**
     * @property {Gnt.data.TaskStore} taskStore The task store to which this assignment store is associated.
     * Usually is configured automatically, by the task store itself.   
     */
    taskStore   : null,
    

    /**
     * Returns the associated task store instance.
     * 
     * @return {Gnt.data.TaskStore}
     */
    getTaskStore: function(){
        return this.taskStore;
    },

    
    /**
     * Returns the associated resource store instance.
     * 
     * @return {Gnt.data.ResourceStore}
     */
    getResourceStore: function(){
        return this.getTaskStore().resourceStore;
    },
    
    
    getByInternalId : function (id) {
        return this.data.getByKey(id) || this.getById(id);
    }
});
/*
@class Gnt.template.Task
@extends Ext.XTemplate
@private

Private class used internally to render a regular task.
*/
Ext.define("Gnt.template.Task", {
    extend : 'Ext.XTemplate',

    constructor : function (cfg) {
        this.callParent([
                 '<div class="sch-event-wrap ' + cfg.baseCls + ' x-unselectable" style="left:{leftOffset}px;">' +
                    // Left label 
                    (cfg.leftLabel ? '<div class="sch-gantt-labelct sch-gantt-labelct-left"><label class="sch-gantt-label sch-gantt-label-left">{leftLabel}</label></div>' : '')+
                    
                    // Task bar
                    '<div id="' + cfg.prefix + '{id}" class="sch-gantt-item sch-gantt-task-bar {cls}" unselectable="on" style="width:{width}px;{style}">'+
                        // Left terminal
                        (cfg.enableDependencyDragDrop ? '<div unselectable="on" class="sch-gantt-terminal sch-gantt-terminal-start"></div>' : '') +
                        ((cfg.resizeHandles === 'both' || cfg.resizeHandles === 'left') ? '<div class="sch-resizable-handle sch-gantt-task-handle sch-resizable-handle-west"></div>' : '') +
                
                        '<div class="sch-gantt-progress-bar" style="width:{percentDone}%;{progressBarStyle}" unselectable="on">&#160;</div>' +

                        ((cfg.resizeHandles === 'both' || cfg.resizeHandles === 'right') ? '<div class="sch-resizable-handle sch-gantt-task-handle sch-resizable-handle-east"></div>' : '') +
                        // Right terminal
                        (cfg.enableDependencyDragDrop ? '<div unselectable="on" class="sch-gantt-terminal sch-gantt-terminal-end"></div>' : '') +
                        (cfg.enableProgressBarResize ? '<div style="left:{percentDone}%" class="sch-gantt-progressbar-handle"></div>': '') +
                    '</div>' +
                   
                    // Right label 
                    (cfg.rightLabel ? '<div class="sch-gantt-labelct sch-gantt-labelct-right" style="left:{width}px"><label class="sch-gantt-label sch-gantt-label-right">{rightLabel}</label></div>' : '') +
                '</div>',
            {
                compiled: true,      
                disableFormats: true 
            }
        ]);
    }
});
/*
@class Gnt.template.Milestone
@extends Ext.XTemplate
@private

Private class used internally to render a milestone task.
*/
Ext.define("Gnt.template.Milestone", {
    extend : 'Ext.XTemplate',

    constructor : function (cfg) {
        this.callParent([
                '<div class="sch-event-wrap ' + cfg.baseCls + ' x-unselectable" style="left:{leftOffset}px">'+
                    // Left label 
                    (cfg.leftLabel ? '<div class="sch-gantt-labelct sch-gantt-labelct-left"><label class="sch-gantt-label sch-gantt-label-left">{leftLabel}</label></div>' : '')+
                    
                    (cfg.printable ? (
                        // Milestone indicator
                        '<img id="' + cfg.prefix + '{id}" src="' + cfg.imgSrc + '" class="sch-gantt-item sch-gantt-milestone-diamond {cls}" unselectable="on" style="{style}" />') : (
                        // Milestone indicator
                        '<div id="' + cfg.prefix + '{id}" class="sch-gantt-item sch-gantt-milestone-diamond {cls}" unselectable="on" style="{style}">'+
                            // Dependency terminals
                            (cfg.enableDependencyDragDrop ? '<div class="sch-gantt-terminal sch-gantt-terminal-start"></div><div class="sch-gantt-terminal sch-gantt-terminal-end"></div>' : '') +
                        '</div>' )) +
                    
                    // Right label 
                    (cfg.rightLabel ? '<div class="sch-gantt-labelct sch-gantt-labelct-right" style="left:{width}px"><label class="sch-gantt-label sch-gantt-label-right">{rightLabel}</label></div>' : '') +
                '</div>',
            {
                compiled: true,      
                disableFormats: true 
            }
        ]);
    }
});
/*
@class Gnt.template.ParentTask
@extends Ext.XTemplate
@private

Private class used internally to render a parent task.
*/
Ext.define("Gnt.template.ParentTask", {
    extend : 'Ext.XTemplate',

    constructor : function (cfg) {
        this.callParent([
                 '<div class="sch-event-wrap ' + cfg.baseCls + ' x-unselectable" style="left:{leftOffset}px;width:{width}px">'+
                    // Left label 
                    (cfg.leftLabel ? '<div class="sch-gantt-labelct sch-gantt-labelct-left"><label class="sch-gantt-label sch-gantt-label-left">{leftLabel}</label></div>' : '')+
                    
                    // Task bar
                    '<div id="' + cfg.prefix + '{id}" class="sch-gantt-item sch-gantt-parenttask-bar {cls}" style="{style}">'+
                        // Left terminal
                        
                        '<div class="sch-gantt-progress-bar" style="width:{percentDone}%;{progressBarStyle}">&#160;</div>'+
                        (cfg.enableDependencyDragDrop ? '<div class="sch-gantt-terminal sch-gantt-terminal-start"></div>' : '') +
                        
                        '<div class="sch-gantt-parenttask-arrow sch-gantt-parenttask-leftarrow"></div>'+
                        '<div class="sch-gantt-parenttask-arrow sch-gantt-parenttask-rightarrow"></div>'+
                        // Right terminal
                        (cfg.enableDependencyDragDrop ? '<div class="sch-gantt-terminal sch-gantt-terminal-end"></div>' : '') +
                    '</div>'+
                    
                    // Right label 
                    (cfg.rightLabel ? '<div class="sch-gantt-labelct sch-gantt-labelct-right" style="left:{width}px"><label class="sch-gantt-label sch-gantt-label-right">{rightLabel}</label></div>' : '') +
                '</div>',
            {
                compiled: true,      
                disableFormats: true 
            }
        ]);
    }
});

/*
@class Gnt.Tooltip
@extends Ext.ToolTip
@private

Internal plugin showing task start/end information.
*/
Ext.define("Gnt.Tooltip", {
    extend : 'Ext.ToolTip',
    requires : [
        'Ext.Template'
    ],
    
    /**
     * @cfg {String} startText The text to show before the start date. Defaults to 'Starts:'.
     */
    startText       : 'Starts: ',
    
    /**
     * @cfg {String} endText The text to show before the end date. Defaults to 'Ends:'.
     */
    endText         : 'Ends: ',
    
    /**
     * @cfg {String} durationText The text to show before the duration text during a resize operation. Defaults to 'Duration:'.
     */
    durationText    : 'Duration:',
    
    /**
     * @cfg {String} mode "startend" or "duration"
     */
    mode            : 'startend', 


    cls             : 'sch-tip',
    
    height          : 40,
    
    autoHide        : false,
    anchor          : 'b-tl',
    maskOnDisable   : false,
    
    initComponent : function() {    
       
        if (this.mode === 'startend' && !this.startEndTemplate) {
            this.startEndTemplate = new Ext.Template(
                '<div class="sch-timetipwrap {cls}">' +
                '<div>' +
                    this.startText + '{startText}' +
                '</div>' +
                '<div>' +
                    this.endText + '{endText}' +
                '</div>' +
            '</div>'
            ).compile();
        }

        if (this.mode === 'duration' && !this.durationTemplate) {
            this.durationTemplate = new Ext.Template(
                '<div class="sch-timetipwrap {cls}">',
                    '<div>' + this.startText + ' {startText}</div>',
                    '<div>' + this.durationText + ' {duration} {unit}' + '</div>',
                '</div>'
            ).compile();
        }
        
        this.callParent(arguments);
    },
    
    
    
    update : function (start, end, valid, taskRecord) {
        var content;
        if (this.mode === 'duration') {
            content = this.getDurationContent(start, end, valid, taskRecord);
        } else {
            content = this.getStartEndContent(start, end, valid, taskRecord);
        }
        this.callParent([content]);
    },
     
    
    // private
    getStartEndContent : function(start, end, valid, taskRecord) {
        var gantt       = this.gantt,
            startText   = gantt.getFormattedDate(start),
            endText     = startText,
            roundedEnd;
        
        if (end - start > 0) {
            endText = gantt.getFormattedEndDate(end, start);
        }
        
        var retVal = {
            cls         : valid ? 'sch-tip-ok' : 'sch-tip-notok',
            startText   : startText,
            endText     : endText
        };
        
        if (this.showClock) {
            Ext.apply(retVal, {
                startHourDegrees        : roundedStart.getHours() * 30, 
                startMinuteDegrees      : roundedStart.getMinutes() * 6
            });
            
            if (end) {
                Ext.apply(retVal, {
                    endHourDegrees      : roundedEnd.getHours() * 30, 
                    endMinuteDegrees    : roundedEnd.getMinutes() * 6
                });
            }
        }
        return this.startEndTemplate.apply(retVal);
    },
    
    
    getDurationContent : function(start, end, valid, taskRecord) {
        var unit        = taskRecord.getDurationUnit() || Sch.util.Date.DAY;
        var duration    = taskRecord.calculateDuration(start, end, unit);
        
        return this.durationTemplate.apply({
            cls         : valid ? 'sch-tip-ok' : 'sch-tip-notok',
            startText   : this.gantt.getFormattedDate(start),
            duration    : parseFloat(Ext.Number.toFixed(duration, 1)),
            unit        : Sch.util.Date.getReadableNameOfUnit(unit, duration > 1)
        });
    },

    
    show : function(el) {
        if (el) {
            this.setTarget(el);
        }
        
        this.callParent([]);
    }
}); 

/*
 * @class Gnt.feature.TaskDragDrop
 * @extends Ext.dd.DragZone
 * @private
 * 
 * Internal plugin enabling drag and drop for tasks
 */
Ext.define("Gnt.feature.TaskDragDrop", {
    extend : "Ext.dd.DragZone", 

    requires : [
        'Gnt.Tooltip',
        'Ext.dd.StatusProxy',
        'Ext.dd.ScrollManager'
    ],

    // Don't seem to need these
    onDragEnter : Ext.emptyFn,
    onDragOut : Ext.emptyFn,

    constructor : function(config) {
        config = config || {};
        Ext.apply(this, config);
        
        this.proxy = this.proxy || Ext.create("Ext.dd.StatusProxy", {
            shadow : false,
            dropAllowed : "sch-gantt-dragproxy",
            dropNotAllowed : "sch-gantt-dragproxy",
            ensureAttachedToBody : Ext.emptyFn
        });

        var me = this,
            g = me.gantt;
            
        if (me.useTooltip) {
            me.tip = Ext.create("Gnt.Tooltip", { gantt : g });
        }

        me.callParent([g.el, Ext.apply(config, {
            ddGroup : me.gantt.id+'-task-dd'
        })]);

        me.scroll = false;
        me.isTarget = true;
        me.ignoreSelf = false;

        // Stop task drag and drop when a resize handle, a terminal or a parent task is clicked
        me.addInvalidHandleClass('sch-resizable-handle');
        me.addInvalidHandleClass('x-resizable-handle');
        me.addInvalidHandleClass('sch-gantt-terminal');
        me.addInvalidHandleClass('sch-gantt-progressbar-handle');

        Ext.dd.ScrollManager.register(me.gantt.el);
        
        me.gantt.ownerCt.el.appendChild(this.proxy.el);

        me.gantt.on({
            destroy : me.cleanUp,
            scope : me
        });
    },

    /**
      * @cfg useTooltip {Boolean} false to not show a tooltip while dragging
      */
    useTooltip : true,
    
    /**
     * An empty function by default, but provided so that you can perform custom validation on 
     * the item being dragged. This function is called during the drag and drop process and also after the drop is made
     * @param {Ext.data.Model} record The record being dragged
     * @param {Date} date The date corresponding to the current start date
     * @param {Int} duration The duration of the item being dragged, in minutes
     * @param {Ext.EventObject} e The event object
     * @return {Boolean} true if the drop position is valid, else false to prevent a drop
     */
    validatorFn : function(record, date, duration, e) {
        return true;
    },
    
    /**
     * @cfg {Object} validatorFnScope
     * The scope for the validatorFn, defaults to the gantt view instance
     */
    validatorFnScope : null,
    
    cleanUp : function() {
        if (this.gantt.dragZone) {
            this.gantt.dragZone.destroy();
        }

        if (this.tip) {
            this.tip.destroy();
        }
    },
    
    containerScroll : false,
    
    dropAllowed : "sch-gantt-dragproxy",
    dropNotAllowed : "sch-gantt-dragproxy",

    destroy : function(){
        this.callParent(arguments);
        Ext.dd.ScrollManager.unregister(this.gantt.el);
    },
    
    autoOffset: function(x, y) {
        var xy = this.dragData.repairXY, // Original position of the element
            xDelta = x - xy[0],
            yDelta = y - xy[1];
        
        this.setDelta(xDelta, yDelta);
    },

    setXConstraint: function(iLeft, iRight, iTickSize) {
        this.leftConstraint = iLeft;
        this.rightConstraint = iRight;
    
        this.minX = iLeft;
        this.maxX = iRight;
        if (iTickSize) { this.setXTicks(this.initPageX, iTickSize); }
        
        this.constrainX = true;
    },

    setYConstraint: function(iUp, iDown, iTickSize) {
        this.topConstraint = iUp;
        this.bottomConstraint = iDown;
        
        this.minY = iUp;
        this.maxY = iDown;
        if (iTickSize) { this.setYTicks(this.initPageY, iTickSize); }

        this.constrainY = true;
    },
    
    constrainTo : function(constrainingRegion, elRegion){
        this.resetConstraints();
        this.initPageX = constrainingRegion.left;
        this.initPageY = elRegion.top;
        this.setXConstraint(constrainingRegion.left, constrainingRegion.right - (elRegion.right - elRegion.left), this.xTickSize);
        this.setYConstraint(elRegion.top-1, elRegion.top-1, this.yTickSize);
    },

    
    onDragOver: function(e, id){
        var data        = this.dragData,
            task        = data.record,
            gantt       = this.gantt,
            x           = this.proxy.el.getX() + gantt.getXOffset(task), // Adjust x position for certain task types
            newStart    = gantt.getDateFromXY([x, 0], 'round');
               
        if (!data.hidden) {
            Ext.fly(data.sourceNode).hide();
            data.hidden = true;
        }

        if (!newStart || newStart - data.start === 0) return;
                
        data.start = newStart;
        this.valid = this.validatorFn.call(this.validatorFnScope || gantt, 
                                            task, 
                                            newStart, 
                                            data.duration, 
                                            e) !== false;
        if (this.tip) {
            this.tip.update(newStart, task.calculateEndDate(newStart, task.getDuration(), task.getDurationUnit()), this.valid);
        }
    },
            
    
    onStartDrag : function () {
        var rec = this.dragData.record;
        
        if (this.tip) {
            this.tip.enable();
            this.tip.show(Ext.get(this.dragData.sourceNode));
            this.tip.update(rec.getStartDate(), rec.getEndDate(), true);
        }
               
        this.gantt.fireEvent('taskdragstart', this.gantt, rec);
    },
            
    // On receipt of a mousedown event, see if it is within a draggable element.
    // Return a drag data object if so. The data object can contain arbitrary application
    // data, but it should also contain a DOM element in the ddel property to provide
    // a proxy to drag.
    getDragData: function(e) {
        var g = this.gantt,
            sourceNode = e.getTarget(g.eventSelector);
                
        if (sourceNode && !e.getTarget('.sch-gantt-baseline-item')) {
            var sourceNodeEl = Ext.get(sourceNode),
                sourceTaskRecord = g.resolveTaskRecord(sourceNodeEl);
                     
            if (g.fireEvent('beforetaskdrag', g, sourceTaskRecord, e) === false) {
                return null;
            }
                    
            var copy = sourceNode.cloneNode(true),
                increment = g.getSnapPixelAmount(),
                origXY = sourceNodeEl.getXY();
            copy.id = Ext.id();
            
            if (increment <= 1) {
                Ext.fly(copy).setStyle('left', 0);  // Reset any offset applied through CSS
            }
            
            this.constrainTo(Ext.fly(g.findItemByChild(sourceNode)).getRegion(), sourceNodeEl.getRegion());
            
            if (increment >= 1) {
                this.setXConstraint(this.leftConstraint, this.rightConstraint, increment);
            }

            return {
                sourceNode : sourceNode,
                repairXY: origXY,
                ddel: copy,
                record : sourceTaskRecord,
                duration : Sch.util.Date.getDurationInMinutes(sourceTaskRecord.getStartDate(), sourceTaskRecord.getEndDate())
            };
        }
        return null;
    },
            
    // Override, get rid of weird highlight fx in default implementation
    afterRepair : function(){
        Ext.fly(this.dragData.sourceNode).show();
        if (this.tip) {
            this.tip.hide();
        }
        this.dragging = false;
    },

    // Provide coordinates for the proxy to slide back to on failed drag.
    // This is the original XY coordinates of the draggable element.
    getRepairXY: function() {
        this.gantt.fireEvent('afterdnd', this.gantt);
        return this.dragData.repairXY;
    },
            
    onDragDrop: function(e, id){
        var target = this.cachedTarget || Ext.dd.DragDropMgr.getDDById(id),
            data = this.dragData,
            g = this.gantt,
            r = data.record,
            start = data.start;
        
        var wasChanged = false;
        
        if (this.tip) {
            this.tip.disable();
        }
        
        if (this.valid && start && r.getStartDate() - start !== 0) {
            // Done this way since it might be dropped on a holiday, and then gets bumped back to its original value
            this.gantt.taskStore.on('update', function() { wasChanged = true; }, null, { single : true });
            
            r.setStartDate(start, true, this.gantt.taskStore.skipWeekendsDuringDragDrop);

            if (wasChanged) {
                g.fireEvent('taskdrop', g, r);
                 // For our good friend IE9, the pointer cursor gets stuck without the defer
                if (Ext.isIE9) {
                    this.proxy.el.setStyle('visibility', 'hidden');
                    Ext.Function.defer(this.onValidDrop, 10, this, [target, e, id]);
                } else {
                    this.onValidDrop(target, e, id);
                }
            }
        }
        
        if (!wasChanged) {
            this.onInvalidDrop(target, e, id);
        }

        g.fireEvent('aftertaskdrop', g, r);
    }
});


/*
 * @class Gnt.feature.DependencyDragDrop
 * @extends Ext.util.Observable
 * @private
 * Internal class managing the interaction of setting up new dependencies using drag and drop between dependency terminals.
 */
Ext.define("Gnt.feature.DependencyDragDrop", {
    extend : 'Ext.util.Observable',

    constructor : function(config) {
        this.addEvents(
            /**
             * @event beforednd
             * Fires before a drag and drop operation is initiated, return false to cancel it
             * @param {Gnt.feature.DependencyDragDrop} dnd The drag and drop instance
             * @param {Ext.data.Model} fromRecord The task record 
             */ 
            'beforednd', 
        
            /**
             * @event dndstart
             * Fires when a drag and drop operation starts
             * @param {Gnt.feature.DependencyDragDrop} dnd The drag and drop instance
             */
            'dndstart',
        
            /**
             * @event drop
             * Fires after a drop has been made on a receiving terminal
             * @param {Gnt.feature.DependencyDragDrop} dnd The drag and drop instance
             * @param {Mixed} fromId The source dependency task record id
             * @param {Mixed} toId The target dependency task record id
             * @param {Int} type The dependency type, see {@link Gnt.model.Dependency} for more information about possible values.
             */
            'drop',

            /**
             * @event afterdnd
             * Always fires after a dependency drag and drop operation
             * @param {Gnt.feature.DependencyDragDrop} dnd The drag and drop instance
             */
            'afterdnd'
        );
    
        var view = config.ganttView;
    
        Ext.apply(this, {
            el : view.el.parent(),  // Use parent el (panel) to avoid conflicts with regular task dd
            ddGroup : view.id + '-sch-dependency-dd',
            ganttView : view,
            dependencyStore : view.getDependencyStore()
        });

        this.el.on('mousemove', function() {
            this.setupDragZone();
            this.setupDropZone();
        }, this, { single : true });

        this.callParent(arguments);
    },
    
    /**
     * @cfg {String} fromText The text to show before the from task when setting up a dependency. Defaults to 'From:'.
     */
    fromText : 'From: <strong>{0}</strong> {1}<br/>',
    
    /**
     * @cfg {String} toText The text to show before the to task when setting up a dependency. Defaults to 'From:'.
     */
    toText : 'To: <strong>{0}</strong> {1}',
    
    /**
     * @cfg {String} startText The text indicating that a dependency connector is a Start type.
     */
    startText : 'Start',
    
    /**
     * @cfg {String} endText The text indicating whether a dependency connector is an End type.
     */
    endText : 'End',
    
    /**
     * @cfg {Boolean} useLineProxy True to display a line while dragging
     */
    useLineProxy : true,
    
    // private, the terminal CSS selector
    terminalSelector : '.sch-gantt-terminal',
    
    destroy : function() {
        if (this.dragZone) {
            this.dragZone.destroy();
        }

        if (this.dropZone) {
            this.dropZone.destroy();
        }

        if (this.lineProxyEl) {
            this.lineProxyEl.destroy();
        }
    },

    initLineProxy : function(sourceEl, isStart) {
        var lpEl = this.lineProxyEl = this.el.createChild({ cls : 'sch-gantt-connector-proxy' }); 

        lpEl.alignTo(sourceEl, isStart ? 'l' : 'r');
        
        Ext.apply(this, {
            containerTop : this.el.getTop(),
            containerLeft : this.el.getLeft(),
            startXY : lpEl.getXY(),
            startScrollLeft : this.el.dom.scrollLeft,
            startScrollTop : this.el.dom.scrollTop
        });
    },

    updateLineProxy : function(xy) {
        var lineProxy = this.lineProxyEl,
            diffX = xy[0] - this.startXY[0] + this.el.dom.scrollLeft - this.startScrollLeft,
            diffY = xy[1] - this.startXY[1] + this.el.dom.scrollTop - this.startScrollTop,
            newHeight = Math.max(1, Math.sqrt(Math.pow(diffX, 2) + Math.pow(diffY, 2)) - 2),

            // Calculate new angle relative to start XY
            rad = Math.atan2(diffY, diffX) - (Math.PI/2),
            styleBlob;

        if (Ext.isIE) {
            var cos = Math.cos(rad),
                sin = Math.sin(rad),
                matrixString = 'progid:DXImageTransform.Microsoft.Matrix(sizingMethod="auto expand", M11 = ' + cos + ', M12 = ' + (-sin) + ', M21 = ' + sin + ', M22 = ' + cos + ')';
            
            styleBlob = {
                "height"    : newHeight + 'px',
                "top"       : Math.min(0, diffY) + this.startXY[1]  - this.containerTop + (diffY < 0 ? 2 : 0)  + 'px',
                "left"      : Math.min(0, diffX) + this.startXY[0] - this.containerLeft + (diffX < 0 ? 2 : 0) + 'px',
                "filter"    : matrixString,
                "-ms-filter": matrixString
            };
        } else {
            var rotateString = 'rotate(' + rad + 'rad)';
            
            styleBlob = {
                "height"            : newHeight + 'px',
                "-o-transform"      : rotateString,
                "-webkit-transform" : rotateString,
                "-moz-transform"    : rotateString,
                "transform"         : rotateString
            };
        }
        
        lineProxy.show().setStyle(styleBlob);
    },

    // private
    setupDragZone : function() {
        var me = this,
            g = this.ganttView;
        
        // The drag zone behaviour
        this.dragZone = Ext.create("Ext.dd.DragZone", this.el, {
            ddGroup : this.ddGroup,
            
            onStartDrag : function () {
                this.el.addCls('sch-gantt-dep-dd-dragging');
                me.fireEvent('dndstart', me);

                if (me.useLineProxy) {
                    var dd = this.dragData;
                    me.initLineProxy(dd.sourceNode, dd.isStart);
                }
            },
            
            // On receipt of a mousedown event, see if it is within a draggable element.
            // Return a drag data object if so. The data object can contain arbitrary application
            // data, but it should also contain a DOM element in the ddel property to provide
            // a proxy to drag.
            getDragData: function(e) {
                var sourceNode = e.getTarget(me.terminalSelector);

                if (sourceNode) {
                    var sourceTaskRecord = g.resolveTaskRecord(sourceNode);
                    if (me.fireEvent('beforednd', this, sourceTaskRecord) === false) {
                        return null;
                    }
                    
                    var isStart = !!sourceNode.className.match('sch-gantt-terminal-start'),
                        ddel = Ext.core.DomHelper.createDom({
                            cls: 'sch-dd-dependency',
                            children: [
                                {
                                    tag: 'span', 
                                    cls: 'sch-dd-dependency-from', 
                                    html: Ext.String.format(me.fromText, sourceTaskRecord.getName(), isStart ? me.startText : me.endText)
                                },
                                {
                                    tag: 'span', 
                                    cls: 'sch-dd-dependency-to', 
                                    html: Ext.String.format(me.toText, '', '')
                                }
                            ]
                        });
                    
                    return {
                        fromId      : sourceTaskRecord.getId() || sourceTaskRecord.internalId,
                        isStart     : isStart,
                        repairXY    : Ext.fly(sourceNode).getXY(),
                        ddel        : ddel,
                        sourceNode  : Ext.fly(sourceNode).up(g.eventSelector)
                    };
                }
                return false;
            },
            
            // Override, get rid of weird highlight fx in default implementation
            afterRepair : function(){
                this.el.removeCls('sch-gantt-dep-dd-dragging');
                
                this.dragging = false;
                me.fireEvent('afterdnd', this);
            },

            onMouseUp : function() {
                this.el.removeCls('sch-gantt-dep-dd-dragging');
                if (me.lineProxyEl) {
                    if (Ext.isIE) {
                        Ext.destroy(me.lineProxyEl);
                        me.lineProxyEl = null;
                    }
                    else {
                        me.lineProxyEl.animate({
                            to : { height : 0 },
                            duration : 500, 
                            callback : function() {
                                Ext.destroy(me.lineProxyEl);
                                me.lineProxyEl = null;
                            }
                        });
                    }
                }
            },

            // Provide coordinates for the proxy to slide back to on failed drag.
            // This is the original XY coordinates of the draggable element.
            getRepairXY: function() {
                return this.dragData.repairXY;
            }
        });
    },
    
    // private
    setupDropZone : function () {
        var me = this,
            g = this.ganttView;
                    
        // The drop zone behaviour
        this.dropZone = Ext.create("Ext.dd.DropZone", this.el, {
            ddGroup : this.ddGroup,
            
            getTargetFromEvent: function(e) {
                if (me.useLineProxy) {
                    me.updateLineProxy(e.getXY());
                }
                return e.getTarget(me.terminalSelector);
            },
            
            // On entry into a target node, highlight that node.
            onNodeEnter : function(target, dd, e, data){
                var isTargetStart = target.className.match('sch-gantt-terminal-start');
                Ext.fly(target).addCls(isTargetStart ? 'sch-gantt-terminal-start-drophover' : 'sch-gantt-terminal-end-drophover');
            },

            // On exit from a target node, unhighlight that node.
            onNodeOut : function(target, dd, e, data){
                var isTargetStart = target.className.match('sch-gantt-terminal-start');
                Ext.fly(target).removeCls(isTargetStart ? 'sch-gantt-terminal-start-drophover' : 'sch-gantt-terminal-end-drophover');
            },
            
            onNodeOver : function(target, dd, e, data){
                var targetRecord = g.resolveTaskRecord(target),
                    targetId = targetRecord.getId() || targetRecord.internalId,
                    isTargetStart = target.className.match('sch-gantt-terminal-start'),
                    newText = Ext.String.format(me.toText, targetRecord.getName(), isTargetStart ? me.startText : me.endText);
                
                dd.proxy.el.down('.sch-dd-dependency-to').update(newText);
                
                if (me.dependencyStore.isValidDependency(data.fromId, targetId)) {
                    return this.dropAllowed;
                } else {
                    return this.dropNotAllowed;
                }
            },
            
            onNodeDrop : function(target, dd, e, data){
                var type, 
                    retVal      = true,
                    DepType     = Gnt.model.Dependency.Type,
                    targetRec   = g.resolveTaskRecord(target),
                    targetId    = targetRec.getId() || targetRec.internalId;
                
                if (me.lineProxyEl) {
                    Ext.destroy(me.lineProxyEl);
                    me.lineProxyEl = null;
                }
                this.el.removeCls('sch-gantt-dep-dd-dragging');
                
                if (data.isStart) {
                    if (target.className.match('sch-gantt-terminal-start')) {
                        type = DepType.StartToStart;
                    } else {
                        type = DepType.StartToEnd;
                    }
                } else {
                    if (target.className.match('sch-gantt-terminal-start')) {
                        type = DepType.EndToStart;
                    } else {
                        type = DepType.EndToEnd;
                    }
                }
               
                retVal = me.dependencyStore.isValidDependency(data.fromId, targetId);
                
                if (retVal) {
                    me.fireEvent('drop', this, data.fromId, targetId, type);
                }
                me.fireEvent('afterdnd', this);
                return retVal;
            }
        });
    }
});
/*
* @class Gnt.feature.DragCreator
* @private
* 
* An internal class which shows a drag proxy while clicking and dragging.
* Create a new instance of this plugin
*/
Ext.define("Gnt.feature.DragCreator", {
    requires : [
        'Ext.Template',
        'Sch.util.DragTracker',
        'Gnt.Tooltip'
    ],

    constructor : function (config) {
        Ext.apply(this, config || {});

        this.init();
    },

    /**
    * @cfg {Boolean} disabled true to start disabled 
     */
    disabled: false,

    /**
    * @cfg {Boolean} showDragTip true to show a time tooltip when dragging to create a new event
    */
    showDragTip: true,

    /**
    * @cfg {Int} dragTolerance Number of pixels the drag target must be moved before dragging is considered to have started. Defaults to 2.
    */
    dragTolerance: 2,

    /**
    * @cfg {Ext.Template} template The HTML template shown when dragging to create new items
    */
    
    /**
    * Enable/disable the plugin
    * @param {Boolean} disabled True to disable this plugin
    */
    setDisabled: function (disabled) {
        this.disabled = disabled;
        if (this.dragTip) {
            this.dragTip.setDisabled(disabled);
        }
    },

    getProxy : function() {
        if (!this.proxy) {
            // Attach this element to the nested gantt panel element (view el is cleared by refreshes)
            this.proxy = this.template.append(this.ganttView.ownerCt.el, {}, true);
        }
        return this.proxy;
    },

    // private
    onBeforeDragStart: function (e) {
        var s = this.ganttView,
            t = e.getTarget('.' + s.timeCellCls, 2);

        if (t) {
            var taskRecord = s.resolveTaskRecord(t);
            var dateTime = s.getDateFromDomEvent(e);

            if (!this.disabled && 
                t &&
                !taskRecord.getStartDate() && 
                !taskRecord.getEndDate() && 
                s.fireEvent('beforedragcreate', s, taskRecord, dateTime, e) !== false) {

                e.stopEvent();

                // Save record if the user ends the drag outside the current row
                this.taskRecord = taskRecord;
           
                // Start time of the task to be created
                this.originalStart = dateTime;

                // Constrain the dragging within the current row schedule area
                this.rowRegion = s.getScheduleRegion(this.taskRecord, this.originalStart);
               
                // Save date constraints
                this.dateConstraints = s.getDateConstraints(this.resourceRecord, this.originalStart);
                
                // TODO apply xStep or yStep to drag tracker
                return true;
            }
        }
        return false;
    },

    // private
    onDragStart: function () {
        var me = this,
            view = me.ganttView,
            proxy = me.getProxy();

        me.start = me.originalStart;
        me.end = me.start;

        me.rowBoundaries = {
            top : me.rowRegion.top,
            bottom : me.rowRegion.bottom
        };
        
        proxy.setRegion({
            top : me.rowBoundaries.top, 
            right : me.tracker.startXY[0], 
            bottom : me.rowBoundaries.bottom, 
            left : me.tracker.startXY[0]
        });

        proxy.show();

        me.ganttView.fireEvent('dragcreatestart', me.ganttView);
        
        if (me.showDragTip) {
            me.dragTip.update(me.start, me.end, true, this.taskRecord);
            me.dragTip.enable();
            me.dragTip.show(proxy);
        }
    },

    // private
    onDrag: function (e) {
        var me = this,
            view = me.ganttView,
            dragRegion = me.tracker.getRegion().constrainTo(me.rowRegion),
            dates = view.getStartEndDatesFromRegion(dragRegion, 'round');
        
        if (!dates) {
            return;
        }

        me.start = dates.start || me.start;
        me.end = dates.end || me.end;
        
        var dc = me.dateConstraints;

        if (dc) {
            me.end = Sch.util.Date.constrain(me.end, dc.start, dc.end);
            me.start = Sch.util.Date.constrain(me.start, dc.start, dc.end);
        }

        if (me.showDragTip) {
            me.dragTip.update(me.start, me.end, true, this.taskRecord);
        }

        Ext.apply(dragRegion, me.rowBoundaries);

        this.getProxy().setRegion(dragRegion);
    },

    // private
    onDragEnd: function (e) {
        var gv = this.ganttView,
            valid = true;
        
        if (this.showDragTip) {
            this.dragTip.disable();
        }
        
        if (!this.start || !this.end || (this.end < this.start)) {
            valid = false;
        }

        if (valid) {
            this.taskRecord.setStartEndDate(this.start, this.end);
            gv.fireEvent('dragcreateend', gv, this.taskRecord, e);
        }
        this.proxy.hide();

        gv.fireEvent('afterdragcreate', gv);
    },

    // private 
    init: function () {
        var gv = this.ganttView,
            gridViewBodyEl = gv.el,
            bind = Ext.Function.bind;
        
        this.lastTime = new Date();
        this.template = this.template || Ext.create("Ext.Template", 
            '<div class="sch-gantt-dragcreator-proxy"></div>',
            {
                compiled : true,
                disableFormats : true
            } 
        );

        gv.on({
            destroy: this.onGanttDestroy,
            scope: this
        });

        this.tracker = new Sch.util.DragTracker({
            el : gridViewBodyEl,
            tolerance: this.dragTolerance,
            onBeforeStart: bind(this.onBeforeDragStart, this),
            onStart: bind(this.onDragStart, this),
            onDrag: bind(this.onDrag, this),
            onEnd: bind(this.onDragEnd, this)
        });

        if (this.showDragTip) {
            this.dragTip = Ext.create("Gnt.Tooltip", {
                mode : 'duration',
                cls : 'sch-gantt-dragcreate-tip',
                gantt : gv
            });
        }
    },

    onGanttDestroy: function () {
        if (this.dragTip) {
            this.dragTip.destroy();
        }

        if (this.tracker) {
            this.tracker.destroy();
        }

        if (this.proxy) {
            Ext.destroy(this.proxy);
            this.proxy = null;
        }
    }
});

/**
 * @class Gnt.feature.LabelEditor
 * @extends Ext.Editor
 * 
 * Private class used by the Gantt chart internals allowing editing the left and right task labels inline
 */
Ext.define("Gnt.feature.LabelEditor", {
    extend : "Ext.Editor",
    
     /**
     * @cfg {String} labelPosition Identifies which side of task this editor is used for. Possible values: 'left' or 'right'.
     */
    labelPosition : '',

    constructor : function(ganttView, config) {
        this.ganttView = ganttView;
        this.ganttView.on('afterrender', this.onGanttRender, this);
        this.callParent([config]);
    },

    // Programmatically enter edit mode
    edit: function (record) {
        var wrap = this.ganttView.getElementFromEventRecord(record).up(this.ganttView.eventWrapSelector);
        this.record = record;
        this.startEdit(wrap.down(this.delegate), this.dataIndex ? record.get(this.dataIndex) : '');
    },

    // private, must be supplied
    delegate: '',

    // private, must be supplied
    dataIndex: '',

    shadow: false,
    completeOnEnter: true,
    cancelOnEsc: true,
    ignoreNoChange: true,

    onGanttRender: function (ganttView) {
        if (!this.field.width) {
            this.autoSize = 'width';
        }

        this.on({
            beforestartedit: function (editor, el, value) {
                return ganttView.fireEvent('labeledit_beforestartedit', ganttView, this.record, value, editor);
            },
            beforecomplete: function (editor, value, original) {
                return ganttView.fireEvent('labeledit_beforecomplete', ganttView, value, original, this.record, editor);
            },
            complete: function (editor, value, original) {
                this.record.set(this.dataIndex, value);
                ganttView.fireEvent('labeledit_complete', ganttView, value, original, this.record, editor);
            },
            scope: this
        });

        ganttView.el.on('dblclick', function (e, t) {
            this.edit(ganttView.resolveTaskRecord(t));
        }, this, {
            delegate: this.delegate
        });
    }
}); 

/*
* @class Gnt.feature.ProgressBarResize
* @extends Ext.util.Observable
* @private
* 
* Internal plugin enabling resizing of a task progress bar
*/
Ext.define("Gnt.feature.ProgressBarResize", {
    requires : [
        'Ext.QuickTip',
        'Ext.resizer.Resizer'
    ],
    constructor : function(config) {
        Ext.apply(this, config || {}); 
        var g = this.gantt;

        g.on({
            destroy: this.cleanUp,
            scope: this
        });
        g.mon(g.el, 'mousedown', this.onMouseDown, this, { delegate: '.sch-gantt-progressbar-handle' });

        this.callParent(arguments);
    },

    /**
    * @cfg useTooltip {Boolean} false to not show a tooltip while resizing
    */
    useTooltip: true,

    /**
    * @cfg {Int} increment
    * The increment in percent to use during a progress element resize
    */
    increment: 10,

    onMouseDown: function (e, t) {
        var g = this.gantt,
            rec = g.resolveTaskRecord(t);

        if (g.fireEvent('beforeprogressbarresize', g, rec) !== false) {
            var progBar = Ext.fly(t).prev('.sch-gantt-progress-bar');
            e.stopEvent();

            this.createResizable(progBar, rec, e);
            g.fireEvent('progressbarresizestart', g, rec);
        }
    },

    // private
    createResizable: function (el, taskRecord, e) {
        var t = e.getTarget(),
            taskEl = el.up(this.gantt.eventSelector),
            taskWidth = taskEl.getWidth() - 2,
            widthIncrement = taskWidth * this.increment / 100;

        var rz = Ext.create('Ext.resizer.Resizer', {
            target: el,
            taskRecord: taskRecord,
            handles: 'e',
            minWidth: 0,
            maxWidth : taskWidth,
            minHeight : 1, 
            widthIncrement : widthIncrement, 
            listeners : {
                resizedrag : this.partialResize,
                resize : this.afterResize,
                scope : this 
            }
        });
        rz.resizeTracker.onMouseDown(e, rz.east.dom);
        taskEl.select('.x-resizable-handle, .sch-gantt-terminal, .sch-gantt-progressbar-handle').hide();
        

        if (this.useTooltip) {
            if (!this.tip) {
                this.tip = Ext.create("Ext.ToolTip", {
                    autoHide: false,
                    anchor: 'b',
                    html: '%'
                });
            }
            this.tip.setTarget(el);

            this.tip.show();
            this.tip.body.update(taskRecord.getPercentDone() + '%');
        }
    },

    // private
    partialResize: function (rz, newWidth) {
        var percent = Math.round(newWidth * 100 / (rz.maxWidth * this.increment)) * this.increment;
        
        if (this.tip) {
            this.tip.body.update(percent + '%');
        }
    },

    // private
    afterResize: function (rz, w, h, e) {
        var rec = rz.taskRecord;
        
        if (this.tip) {
            this.tip.hide();
        }

        var percent = Math.round(w * 100 / (rz.maxWidth * this.increment)) * this.increment;

        rz.taskRecord.setPercentDone(percent);

        // Destroy resizable 
        rz.destroy();

        this.gantt.fireEvent('afterprogressbarresize', this.gantt, rec);
    },

    cleanUp: function () {
        if (this.tip) {
            this.tip.destroy();
        }
    }
}); 

/**
@class Gnt.feature.TaskResize
@extends Ext.util.Observable

A plugin enabling the task resizing feature. Generally there's no need to manually create it, 
it can be activated with the {@link Gnt.panel.Gantt#resizeHandles} option of the gantt panel. 

 
*/
Ext.define("Gnt.feature.TaskResize", {

    constructor : function(config) {
        Ext.apply(this, config);
        var g = this.gantt;

        g.on({
            destroy : this.cleanUp,
            scope : this
        });

        g.mon(g.el, 'mousedown', this.onMouseDown, this, { delegate : '.sch-resizable-handle' });

        this.callParent(arguments);
    },
    
    /**
     * @cfg {Boolean} showDuration true to show the duration instead of the end date when resizing a task
     */
    showDuration : true,
    
    /**
      * @cfg useTooltip {Boolean} false to not show a tooltip while resizing
      */
    useTooltip : true,
    
    /**
     * An empty function by default, but provided so that you can perform custom validation on 
     * the item being resized.
     * @param {Ext.data.Model} taskRecord The task being resized
     * @param {Date} startDate
     * @param {Date} endDate
     * @param {Event} e The event object
     * @return {Boolean} isValid True if the creation event is valid, else false to cancel
     */
    validatorFn : Ext.emptyFn,
    
    /**
     * @cfg {Object} validatorFnScope
     * The scope for the validatorFn
     */
    validatorFnScope : null,
    
    onMouseDown : function(e) {
        var s = this.gantt,
            domEl = e.getTarget(s.eventSelector),
            rec = s.resolveTaskRecord(domEl);

        if (s.fireEvent('beforetaskresize', s, rec, e) === false) {
            return;
        }
        e.stopEvent();
        this.createResizable(Ext.get(domEl), rec, e);
        s.fireEvent('taskresizestart', s, rec);
    },


    // private
    createResizable : function (el, taskRecord, e) {
       
        var t = e.getTarget(),
            g = this.gantt,
            isStart = !!t.className.match('sch-resizable-handle-west'),
            widthIncrement = g.getSnapPixelAmount(),
            
            currentWidth = el.getWidth(),
            rowRegion = el.up('.x-grid-row').getRegion();

        this.resizable = Ext.create('Ext.resizer.Resizer', {
            startLeft : el.getLeft(),
            startRight : el.getRight(),
            target: el,
            taskRecord : taskRecord,
            handles: isStart ? 'w' : 'e',
            constrainTo : rowRegion,
            minHeight : 1,
            minWidth: widthIncrement,
            widthIncrement : widthIncrement, 
            listeners : {
                resizedrag : this[isStart ? 'partialWestResize' : 'partialEastResize'],
                resize : this.afterResize, 
                scope : this
            }
        });
        
        this.resizable.resizeTracker.onMouseDown(e, this.resizable[isStart ? 'west' : 'east'].dom);

        if (this.useTooltip) {
            if(!this.tip) {
                this.tip = Ext.create("Gnt.Tooltip", {
                    mode : this.showDuration ? 'duration' : 'startend',
                    gantt : this.gantt
                });
            }
            var start = taskRecord.getStartDate(),
                end = taskRecord.getEndDate();
                
            this.tip.show(el);
            this.tip.update(start, end, true, taskRecord);
        }
    },
    
    // private
    partialEastResize : function (resizer, newWidth, oldWidth, e) {
        var s = this.gantt,
            end = s.getDateFromXY([resizer.startLeft + Math.min(newWidth, this.resizable.maxWidth), 0], 'round');
        
        if (!end || resizer.end-end === 0) {
            return;
        }
        
        var start = resizer.taskRecord.getStartDate(),
            valid = this.validatorFn.call(this.validatorFnScope || this, resizer.taskRecord, start, end) !== false;
        
        resizer.end = end;
        
        s.fireEvent('partialtaskresize', s, resizer.taskRecord, start, end, resizer.el, e);
        
        if (this.useTooltip) {
            this.tip.update(start, end, valid, resizer.taskRecord);
        }
    },
    
    partialWestResize : function (resizer, newWidth, oldWidth, e) {
        var s = this.gantt,
            start = s.getDateFromXY([resizer.startRight - Math.min(newWidth, this.resizable.maxWidth), 0], 'round');
        
        if (!start || resizer.start-start === 0) {
            return;
        }

        var end = resizer.taskRecord.getEndDate(),
            valid = this.validatorFn.call(this.validatorFnScope || this, resizer.taskRecord, start, end) !== false;
        
        resizer.start = start;
        
        s.fireEvent('partialtaskresize', s, resizer.taskRecord, start, end, resizer.el, e);
        
        if (this.useTooltip) {
            this.tip.update(start, end, valid, resizer.taskRecord);
        }
    },
    
    // private
    afterResize : function (r, w, h, e) {
        if (this.useTooltip) {
            this.tip.hide();
        }
        var taskRecord = r.taskRecord,
            oldStart = taskRecord.getStartDate(),
            oldEnd = taskRecord.getEndDate(),
            start = r.start || oldStart,
            end = r.end || oldEnd,
            gantt = this.gantt;
            
        // Destroy resizable 
        r.destroy();
        
        if (start && end && (end - start >= 0) && // Input sanity check
            (start - oldStart || end - oldEnd) && // Make sure start OR end changed
            this.validatorFn.call(this.validatorFnScope || this, taskRecord, start, end, e) !== false) {
            
            var skipWeekends    = this.gantt.taskStore.skipWeekendsDuringDragDrop;
                
            if (start - oldStart !== 0) {
                taskRecord.setStartDate(start, false, skipWeekends);
            } else {
                taskRecord.setEndDate(end, false, skipWeekends);  
            }
        } else {
            gantt.refreshKeepingScroll();
        }
        
        gantt.fireEvent('aftertaskresize', gantt, taskRecord);
    },

    cleanUp : function() {
        if (this.tip) {
            this.tip.destroy();
        }
    }
}); 

/**
@class Gnt.feature.WorkingTime
@extends Sch.plugin.Zones

A simple subclass of the {@link Sch.plugin.Zones} which highlights holidays/weekends on the gantt chart. 
Generally, there's no need to instantiate it manually, it can be activated with the {@link Gnt.panel.Gantt#highlightWeekends} configuration option.

{@img gantt/images/plugin-working-time.png}

Note, that the holidays/weekends will only be shown when the resolution of the time axis is weeks or less.

*/
Ext.define("Gnt.feature.WorkingTime", {
    extend : 'Sch.plugin.Zones',
    
    requires : [
        'Ext.data.Store',
        'Sch.model.Range'
    ],
    
    expandToFitView : true,

    /**
     * @cfg {Gnt.data.Calendar} calendar The calendar to extract the holidays from
     */
    calendar : null,
    

    init : function (ganttPanel) {
        if (!this.calendar) {
            Ext.Error.raise("Required attribute 'calendar' missed during initialization of 'Gnt.feature.WorkingTime'");
        }

        this.bindCalendar(this.calendar);
        
        Ext.apply(this, {
            store : new Ext.data.Store({
                model       : 'Sch.model.Range'
            })
        });
        
        this.callParent(arguments);
        
        ganttPanel.on('viewchange', this.onViewChange, this);
        
        // timeAxis should be already fully initialized at this point
        this.onViewChange();
    },

    bindCalendar : function(calendar) {
        var listeners = {
            datachanged     : this.refresh,
            
            scope           : this,
            delay           : 1
        };
        
        if (this.calendar) {
            this.calendar.un(listeners);
        }

        calendar.on(listeners);

        this.calendar = calendar;
    },
    
    onViewChange : function () {
        var DATE    = Sch.util.Date;
        
        if (DATE.compareUnits(this.timeAxis.unit, DATE.WEEK) > 0) {
            this.setDisabled(true);
        } else {
            this.setDisabled(false);
            
            this.refresh();
        }
    },

    
    refresh : function() {
        var view        = this.schedulerView;
        
        this.store.removeAll(true);
        
        this.store.add(this.calendar.getHolidaysRanges(view.getStart(), view.getEnd(), true));
    }
});
/**

@class Gnt.plugin.DependencyEditor
@extends Ext.form.FormPanel

{@img gantt/images/dependency-editor.png}

A plugin which shows the dependency editor panel, when a user double-clicks a dependency line or arrow.

To customize the fields created by this plugin, override the `buildFields` method.

You can add it to your gantt chart like this:

    var gantt = Ext.create('Gnt.panel.Gantt', {
    
        plugins             : [
            Ext.create("Gnt.plugin.DependencyEditor", {
                // default value
                hideOnBlur      : true
            })
        ],
        ...
    })


*/
Ext.define("Gnt.plugin.DependencyEditor", {
    extend : "Ext.form.FormPanel", 
    
    requires : [
        'Ext.form.DisplayField',
        'Ext.form.ComboBox',
        'Ext.form.NumberField',
        'Gnt.model.Dependency'
    ],
    
    /**
     * @cfg {Boolean} hideOnBlur True to hide this panel if a click is detected outside the panel (defaults to true)
     */
    hideOnBlur : true,
    
    /**
     * @cfg {String} fromText The text to before the From label
     */
    fromText : 'From',
    
    /**
     * @cfg {String} toText The text to before the To label
     */
    toText : 'To',

    /**
     * @cfg {String} typeText The text to before the Type field
     */
    typeText : 'Type',

    /**
     * @cfg {String} lagText The text to before the Lag field
     */
    lagText : 'Lag',

    /**
     * @cfg {String} endToStartText The text for `end-to-start` dependency type
     */
    endToStartText : 'Finish-To-Start',

    /**
     * @cfg {String} startToStartText The text for `start-to-start` dependency type 
     */
    startToStartText : 'Start-To-Start',

    /**
     * @cfg {String} endToEndText The text for `end-to-end` dependency type
     */
    endToEndText : 'Finish-To-Finish',

    /**
     * @cfg {String} startToEndText The text for `start-to-end` dependency type
     */
    startToEndText : 'Start-To-Finish',
       
    /**
     * @cfg {Boolean} showLag True to show the lag editor
     */
    showLag         : false,
    
    border          : false,
    
    height          : 150,
    width           : 260,
    
    frame           : true,
    labelWidth      : 60,
    
    
    /**
     * @cfg {Boolean} constrain Pass `true` to enable the constraining - ie editor panel will not exceed the document edges. This option will disable the animation
     * during the expansion. Default value is `false`.  
     */
    constrain           : false,
    

    
    initComponent : function() {
        Ext.apply(this, {
            items       : this.buildFields(),
            
            defaults    : {
                width   : 240
            },

            floating    : true,
            hideMode    : 'offsets'
        });
        this.callParent(arguments);
    },

    beforeRender : function() {
        this.addCls('sch-gantt-dependencyeditor');
        this.callParent(arguments);
    },
    
    
    init : function(cmp) {
        cmp.on('dependencydblclick', this.onDependencyDblClick, this);
        cmp.on('render', this.onGanttRender, this, { delay : 50 });
        
        this.gantt = cmp;
        this.taskStore = cmp.getTaskStore();
    },
    
    onGanttRender : function() {
        this.render(Ext.getBody());

        // Collapse after render, otherwise rendering is messed up
        this.collapse(Ext.Component.DIRECTION_TOP, true);
        this.hide();
         
        if (this.hideOnBlur) {
            // Hide when clicking outside panel
            this.mon(Ext.getBody(), 'click', this.onMouseClick, this);
        }
    },
    
    /** 
     * Expands the editor
     * @param {Record} dependencyRecord The record to show in the editor panel
     * @param {Array} xy the coordinates where the window should be shown
     */
    show : function(dependencyRecord, xy) {
        this.dependencyRecord = dependencyRecord;
        
        // Load form panel fields
        this.getForm().loadRecord(dependencyRecord);
        this.fromLabel.setValue(this.dependencyRecord.getSourceTask().getName());
        this.toLabel.setValue(this.dependencyRecord.getTargetTask().getName());

        this.callParent([]);
        this.el.setXY(xy);
        
        this.expand(!this.constrain);
        
        if (this.constrain) {
            this.doConstrain(Ext.util.Region.getRegion(Ext.getBody()));
        }
    },
    

    /**
     * This method is being called during form initialization. It should return an array of fields, which will be assigned to the `items` property.
     * @return {Array}
     */
    buildFields : function() {
        var me = this,
            depClass = Gnt.model.Dependency,
            DependencyType = depClass.Type,
            fields = [
                this.fromLabel = Ext.create("Ext.form.DisplayField", {
                    fieldLabel : this.fromText
                }),
                    
                this.toLabel = Ext.create("Ext.form.DisplayField", {
                    fieldLabel : this.toText
                }),

                this.typeField = Ext.create("Ext.form.ComboBox", {
                    name : depClass.prototype.nameField,
                    fieldLabel : this.typeText,
                    triggerAction : 'all',
                    queryMode: 'local',
                    valueField : 'value',
                    displayField : 'text',
                    editable : false,
                    store : Ext.create("Ext.data.JsonStore", {
                        fields : ['text', 'value'],
                        data : [{
                            text : this.endToStartText,
                            value : DependencyType.EndToStart
                        },
                        {
                            text : this.startToStartText,
                            value : DependencyType.StartToStart
                        },
                        {
                            text : this.endToEndText,
                            value : DependencyType.EndToEnd
                        },
                        {
                            text : this.startToEndText,
                            value : DependencyType.StartToEnd
                        }]
                    })
                })
            ];

        if (this.showLag) {
            fields.push(
                this.lagField = Ext.create("Ext.form.NumberField", {
                    name : depClass.prototype.lagField,
                    fieldLabel : this.lagText
                })
            );
        }

        return fields;
    },
    
    onDependencyDblClick : function(depView, record, e, t) {
        if (this.lagField) {
            this.lagField.name = record.lagField;
        }

        if (this.typeField) {
            this.typeField.name = record.typeField;
        }

        if (record != this.dependencyRecord) {
            this.show(record, e.getXY());
        }
    },
    
    
    onMouseClick : function(e){
         if (
            this.collapsed || e.within(this.getEl()) || 
            // ignore the click on the menus and combo-boxes (which usually floats as the direct child of <body> and
            // leaks through the `e.within(this.getEl())` check
            e.getTarget('.x-layer') ||
            
            // if clicks should be ignored for any other element - it should have this class
            e.getTarget('.sch-ignore-click')
        ) {        
            return;
        }
        
        this.collapse();
    },

     // Always hide drag proxy on collapse
    afterCollapse : function() {
        delete this.dependencyRecord;
        
        // Currently the header is kept even after collapse, so need to hide the form completely
        this.hide();
        
        this.callParent(arguments);
    }
});

/**
@class Gnt.plugin.TaskContextMenu
@extends Ext.menu.Menu

Plugin for showing a context menu when right clicking a task:

{@img gantt/images/context-menu.png}

You can add it to your gantt chart like this:

    var gantt = Ext.create('Gnt.panel.Gantt', {
    
        plugins             : [
            Ext.create("Gnt.plugin.TaskContextMenu")
        ],
        ...
    })


To customize the content of the menu, subclass this plugin and provide your own implementation of the `createMenuItems` method.
You can also customize various handlers for menu items, like `addTaskAbove`, `deleteTask` etc. For example:

    Ext.define('MyProject.plugin.TaskContextMenu', {
        extend     : 'Gnt.plugin.TaskContextMenu',
        
        createMenuItems : function () {
            return this.callParent().concat({
                text        : 'My handler',
                
                handler     : this.onMyHandler,
                scope       : this
            })
        },
        
        onMyHandler : function () {
            // the task on which the right click have occured
            var task        = this.rec;
            
            ...
        }
    });

    var gantt = Ext.create('Gnt.panel.Gantt', {
        selModel : new Ext.selection.TreeModel({ ignoreRightMouseSelection : false }),
        plugins             : [
            Ext.create("MyProject.plugin.TaskContextMenu")
        ],
        ...
    })

Note that when using right click to show the menu you should the 'ignoreRightMouseSelection' to false on your selection model (as seen in the source above).
*/
Ext.define("Gnt.plugin.TaskContextMenu", {
    extend              : "Ext.menu.Menu",
    
    requires            : [
        'Gnt.model.Dependency'
    ],
    
    
    plain               : true,
    
    /**
     * @cfg {String} triggerEvent
     * The event upon which the menu shall be shown. Defaults to 'taskcontextmenu', meaning the menu is shown when right-clicking a task.
     * You can change this to 'itemcontextmenu' if you want the menu to be shown when right clicking the a grid cell too.
     */
    triggerEvent        : 'taskcontextmenu',

    /**
     * @cfg {Object} texts 
     * A object, purposed for I18n. Contains the following keys/values:

- newTaskText         : 'New task', 
- newMilestoneText    : 'New milestone', 
- deleteTask          : 'Delete task(s)',
- editLeftLabel       : 'Edit left label',
- editRightLabel      : 'Edit right label',
- add                 : 'Add...',
- deleteDependency    : 'Delete dependency...',
- addTaskAbove        : 'Task above',
- addTaskBelow        : 'Task below',
- addMilestone        : 'Milestone',
- addSubtask          : 'Sub-task',
- addSuccessor        : 'Successor',
- addPredecessor      : 'Predecessor'

     */
    texts               : {
        newTaskText         : 'New task', 
        newMilestoneText    : 'New milestone', 
        deleteTask          : 'Delete task(s)',
        editLeftLabel       : 'Edit left label',
        editRightLabel      : 'Edit right label',
        add                 : 'Add...',
        deleteDependency    : 'Delete dependency...',
        addTaskAbove        : 'Task above',
        addTaskBelow        : 'Task below',
        addMilestone        : 'Milestone',
        addSubtask          : 'Sub-task',
        addSuccessor        : 'Successor',
        addPredecessor      : 'Predecessor'
    },
    
    
    grid                : null,
    /**
     * @property {Gnt.model.Task} rec Contains the task model, on which the right click have occured
     */
    rec                 : null,
    
    lastHighlightedItem : null,

    
    /**
     * This method is being called during plugin initialization. Override if you need to customize the items in the menu. 
     * The method should return the array of the menu items, which will be used as the value of `items` property.
     * @return {Array}
     */
    createMenuItems : function() {
        var texts       = this.texts;

        return [
            {
                handler     : this.deleteTask,
                requiresTask: true,
                scope       : this,
                text        : texts.deleteTask
            },
            {
                handler     : this.editLeftLabel,
                requiresTask: true,
                scope       : this,
                text        : texts.editLeftLabel
            },
            {
                handler     : this.editRightLabel,
                requiresTask: true,
                scope       : this,
                text        : texts.editRightLabel
            },
            {
                text        : texts.add,
                
                menu        : {
                    plain   : true,
                    items   : [
                        {
                            handler     : this.addTaskAboveAction,
                            requiresTask: true,
                            scope       : this,
                            text        : texts.addTaskAbove
                        },
                        {
                            handler     : this.addTaskBelowAction,
                            scope       : this,
                            text        : texts.addTaskBelow
                        },
                        {
                            handler     : this.addMilestone,
                            requiresTask: true,
                            scope       : this,
                            text        : texts.addMilestone
                        },
                        {
                            handler     : this.addSubtask,
                            requiresTask: true,
                            scope       : this,
                            text        : texts.addSubtask
                        },
                        {
                            handler     : this.addSuccessor,
                            requiresTask: true,
                            scope       : this,
                            text        : texts.addSuccessor
                        },
                        {
                            handler     : this.addPredecessor,
                            requiresTask: true,
                            scope       : this,
                            text        : texts.addPredecessor
                        }
                    ]
                }
            },
            {
                text    : texts.deleteDependency,
                requiresTask : true,
                menu    : { 
                    plain       : true,
                    
                    listeners   : {
                        beforeshow  : this.populateDependencyMenu,
                        
                        // highlight dependencies on mouseover of the menu item
                        mouseover   : this.onDependencyMouseOver,
                        
                        // unhighlight dependencies on mouseout of the menu item
                        mouseleave  : this.onDependencyMouseOut,
                        
                        scope       : this
                    }
                }
            }
        ];
    },
    
    
    // backward compat
    buildMenuItems : function() {
        this.items  = this.createMenuItems();
    },

    
    initComponent : function() {
        this.buildMenuItems();
        
        this.callParent(arguments);
    },
    
    
    init : function (grid) {
        grid.on('destroy', this.cleanUp, this);
        var scheduleView = grid.getSchedulingView(),
            lockedView = grid.lockedGrid.getView();

        if (this.triggerEvent === 'itemcontextmenu') {
            lockedView.on('itemcontextmenu', this.onItemContextMenu, this);
            scheduleView.on('itemcontextmenu', this.onItemContextMenu, this);
        }
        // Always listen to taskcontext menu
        scheduleView.on('taskcontextmenu', this.onTaskContextMenu, this);

        // Handle case of empty schedule too
        scheduleView.on('containercontextmenu', this.onContainerContextMenu, this);
        lockedView.on('containercontextmenu', this.onContainerContextMenu, this);
        
        this.grid = grid;
    },

    
    populateDependencyMenu : function (menu) {
        var grid            = this.grid, 
            taskStore       = grid.getTaskStore(),
            dependencies    = this.rec.getAllDependencies(),
            depStore        = grid.dependencyStore;
        
        menu.removeAll();

        if (dependencies.length === 0) {
            return false;
        }
        
        var taskId          = this.rec.getId() || this.rec.internalId;
        
        Ext.each(dependencies, function (dependency) {
            var fromId  = dependency.getSourceId(),
                task    = taskStore.getById(fromId == taskId ? dependency.getTargetId() : fromId);
            
            if (task) {
                menu.add({
                    depId       : dependency.internalId,
                    text        : Ext.util.Format.ellipsis(task.getName(), 30),
                
                    scope       : this,
                    handler     : function (menuItem) {
                        // in 4.0.2 `indexOfId` returns the record by the `internalId`
                        // in 4.0.7 `indexOfId` returns the record by its "real" id
                        // so need to manually scan the store to find the record
                        
                        var record;
                        
                        depStore.each(function (dependency) {
                            if (dependency.internalId == menuItem.depId) { record = dependency; return false; }
                        });
                        
                        depStore.remove(record);
                    }
                });
            }
        }, this);
    },
    
    
    onDependencyMouseOver : function(menu, item, e) {
        if (item) {
            var schedulingView          = this.grid.getSchedulingView();
            
            if (this.lastHighlightedItem) {
                schedulingView.unhighlightDependency(this.lastHighlightedItem.depId);
            }
            
            this.lastHighlightedItem    = item;
            
            schedulingView.highlightDependency(item.depId);
        }
    },
    
    
    onDependencyMouseOut : function (menu, e) {
        if (this.lastHighlightedItem) {
            this.grid.getSchedulingView().unhighlightDependency(this.lastHighlightedItem.depId);
        }
    },
        
    
    cleanUp : function() {
        this.destroy();
    },
    
    onTaskContextMenu : function(g, record, e){
        this.activateMenu(record, e);
    },

    onItemContextMenu : function(view, record, item, index, e){
        this.activateMenu(record, e);
    },
    
    onContainerContextMenu : function(g, e) {
        this.activateMenu(null, e);
    },

    activateMenu : function(rec, e) {
        e.stopEvent();

        this.rec = rec;
        var reqTasks = this.query('[requiresTask]');
        Ext.each(reqTasks, function(item) {
            item.setDisabled(!rec);
        });

        this.showAt(e.getXY());
    },

    
    copyTask : function (original) {
        var model = this.grid.getTaskStore().model;
          
        var newTask = new model({
            leaf : true
        });
        
        newTask.setPercentDone(0);
        newTask.setName(this.texts.newTaskText);
        newTask.set(newTask.startDateField, (original && original.getStartDate()) || null);
        newTask.set(newTask.endDateField, (original && original.getEndDate()) || null);
        newTask.set(newTask.durationField, (original && original.getDuration()) || null);
        newTask.set(newTask.durationUnitField, (original && original.getDurationUnit()) || 'd');
        return newTask;
    },
    
    
    // Actions follow below
    // ---------------------------------------------
    
    /**
     * Handler for the "add task above" menu item
     */
    addTaskAbove : function (newTask) {
        var task        = this.rec;
        
        if (task) {
            task.addTaskAbove(newTask);
        } else {
            this.grid.taskStore.getRootNode().appendChild(newTask);
        }
    },
    
    /**
     * Handler for the "add task below" menu item
     */
    addTaskBelow : function (newTask) {
        var task        = this.rec;
        
        if (task) {
            task.addTaskBelow(newTask);
        } else {
            this.grid.taskStore.getRootNode().appendChild(newTask);
        }
    },
    
    /**
     * Handler for the "delete task" menu item
     */
    deleteTask: function() {
        var tasks = this.grid.getSelectionModel().selected;
        this.grid.taskStore.remove(tasks.items);
    },

    /**
     * Handler for the "edit left label" menu item
     */
    editLeftLabel : function() {
        this.grid.getSchedulingView().editLeftLabel(this.rec);
    },
    
    /**
     * Handler for the "edit right label" menu item
     */
    editRightLabel : function() {
        this.grid.getSchedulingView().editRightLabel(this.rec);
    },
        
    
    /**
     * Handler for the "add task above" menu item
     */
    addTaskAboveAction : function () {
        this.addTaskAbove(this.copyTask(this.rec));
    },
    
    
    /**
     * Handler for the "add task below" menu item
     */
    addTaskBelowAction : function () {
        this.addTaskBelow(this.copyTask(this.rec));
    },
    
        
    /**
     * Handler for the "add subtask" menu item
     */
    addSubtask : function() {
        var task        = this.rec;
        task.addSubtask(this.copyTask(task));
    },
        
    /**
     * Handler for the "add successor" menu item
     */
    addSuccessor : function () {
        var task        = this.rec;
        task.addSuccessor(this.copyTask(task));
    },
        
    /**
     * Handler for the "add predecessor" menu item
     */
    addPredecessor : function() {
        var task        = this.rec;
        task.addPredecessor(this.copyTask(task));
    },
        
    
    /**
     * Handler for the "add milestone" menu item
     */
    addMilestone : function() {
        var task        = this.rec,
            newTask     = this.copyTask(task);
        
        task.addTaskBelow(newTask);
        newTask.setStartEndDate(task.getEndDate(), task.getEndDate());
   }
});
/**
@class Gnt.plugin.Printable
@extends Sch.plugin.Printable
 
A plugin for printing the content of an Ext Gantt panel.

You can add it to your gantt chart like any other plugin and it will add a new method `print` to the gantt panel itself:

    var gantt = Ext.create('Gnt.panel.Gantt', {
    
        plugins             : [
            Ext.create("Gnt.plugin.Printable")
        ],
        ...
    })
    
    gantt.print();

*/
Ext.define("Gnt.plugin.Printable", {
    extend : "Sch.plugin.Printable",

    getGridContent : function(gantt) {
        var retVal = this.callParent(arguments),
            ganttView = gantt.getSchedulingView(),
            depView = ganttView.dependencyView,
            tplData = depView.painter.getDependencyTplData(ganttView.dependencyStore.getRange());
        
        retVal.normalRows += depView.lineTpl.apply(tplData);
        return retVal;
    }
});
/*
 * @class Gnt.view.DependencyPainter
 * @extends Ext.util.Observable
 * @private
 * Internal class handling the drawing of inter-task dependencies.
 */
Ext.define("Gnt.view.DependencyPainter", {
    extend      : "Ext.util.Observable",
    
    requires    : [
        'Ext.util.Region'
    ],

    constructor: function (cfg) {
        cfg = cfg || {};

        Ext.apply(this, cfg, {
            xOffset: 8,
            yOffset: 7,
            midRowOffset: 6,
            arrowOffset: 8
        });
    },

    getTaskBox: function (task) {
        var DT = Sch.util.Date,
            taskStart = task.getStartDate(),
            taskEnd = task.getEndDate(),
            viewStart = this.ganttView.getStart(),
            viewEnd = this.ganttView.getEnd();

        // Check if element is 
        // inside a collapsed parent task, or 
        // if it not scheduled or
        // if it doesn't intersect current viewport
        if (!task.isVisible() || !taskStart || !taskEnd || !DT.intersectSpans(taskStart, taskEnd, viewStart, viewEnd)) {
            return null;
        }

        var v = this.ganttView,
            left = v.getXYFromDate(DT.max(taskStart, viewStart))[0],
            right = v.getXYFromDate(DT.min(taskEnd, viewEnd))[0],
            taskEl = Ext.get(v.getEventNodeByRecord(task) || v.getNode(task));
            
        if (!taskEl) {
            return null;
        }

        var xOffset = this.view.getXOffset(task),
            offsets = taskEl.getOffsetsTo(v.el),
            top = offsets[1] + v.el.getScroll().top;

        if (left > xOffset) {
            left -= xOffset;
        }
        right += xOffset - 1;

        return Ext.create("Ext.util.Region", top, right, top + taskEl.getHeight(), left);
    },

    getDependencyTplData: function (dependencyRecord) {
        var me = this,
            ts = me.taskStore;
            
        // Normalize input
        if (!Ext.isArray(dependencyRecord)) {
            dependencyRecord = [dependencyRecord];
        }

        if (dependencyRecord.length === 0 || ts.getCount() <= 0) {
            return;
        }

        var depData = [],
            DepType = Gnt.model.Dependency.Type,
            view = me.ganttView,
            coords, fromTask, toTask, fromBox, toBox, r;

        for (var i = 0, l = dependencyRecord.length; i < l; i++) {
            r = dependencyRecord[i];
            fromTask = r.getSourceTask();
            toTask = r.getTargetTask();

            if (fromTask && toTask) {

                fromBox = me.getTaskBox(fromTask);
                toBox = me.getTaskBox(toTask);

                if (fromBox && toBox) {
                    switch (r.getType()) {
                        case DepType.StartToEnd:
                                coords = me.getStartToEndCoordinates(fromBox, toBox);
                            break;

                        case DepType.StartToStart:
                                coords = me.getStartToStartCoordinates(fromBox, toBox);
                            break;

                        case DepType.EndToStart:
                                coords = me.getEndToStartCoordinates(fromBox, toBox);
                            break;

                        case DepType.EndToEnd:
                                coords = me.getEndToEndCoordinates(fromBox, toBox);
                            break;

                        default:
                            throw 'Invalid dependency type: ' + r.getType();
                    }
                    if (coords) {
                        depData.push({
                            lineCoordinates: coords,
                            id: r.internalId,
                            cls : r.getCls()
                        });
                    }
                }
            }
        }
        
        return depData;
    },

    intersectsViewport: function (task1, task2, firstVisibleRowIndex, lastVisibleRowIndex) {
        var index1 = this.taskStore.indexOf(task1),
            index2 = this.taskStore.indexOf(task2);

        return !((index1 < firstVisibleRowIndex && index2 < firstVisibleRowIndex) ||
                (index1 > lastVisibleRowIndex && index2 > lastVisibleRowIndex));
    },

    getStartToStartCoordinates: function (fromBox, toBox, firstVisibleRow, lastVisibleRow) {
        var x1 = fromBox.left,
            y1 = fromBox.top - 1 + ((fromBox.bottom - fromBox.top) / 2),
            x2 = toBox.left,
            y2 = toBox.top - 1 + ((toBox.bottom - toBox.top) / 2),
            y2offset = fromBox.top < toBox.top ? (y2 - this.yOffset - this.midRowOffset) : (y2 + this.yOffset + this.midRowOffset),
            leftPointOffset = this.xOffset + this.arrowOffset;

        if (x1 > (x2 + this.xOffset)) {
            leftPointOffset += (x1 - x2);
        }

        return [
            {
                x1: x1,
                y1: y1,
                x2: x1 - leftPointOffset,
                y2: y1
            },
            {
                x1: x1 - leftPointOffset,
                y1: y1,
                x2: x1 - leftPointOffset,
                y2: y2
            },
            {
                x1: x1 - leftPointOffset,
                y1: y2,
                x2: x2 - this.arrowOffset,
                y2: y2
            }
        ];
    },

    getStartToEndCoordinates: function (fromBox, toBox) {
        var x1 = fromBox.left,
            y1 = fromBox.top - 1 + ((fromBox.bottom - fromBox.top) / 2),
            x2 = toBox.right,
            y2 = toBox.top - 1 + ((toBox.bottom - toBox.top) / 2),
            y2offset = fromBox.top < toBox.top ? (y2 - this.yOffset - this.midRowOffset) : (y2 + this.yOffset + this.midRowOffset),
            coords,
            leftOffset;

        if (x2 > (x1 + this.xOffset - this.arrowOffset) ||
             Math.abs(x2 - x1) < (2 * (this.xOffset + this.arrowOffset))) {
            leftOffset = x1 - this.xOffset - this.arrowOffset;
            var x2Offset = x2 + this.xOffset + this.arrowOffset;

            // To after from
            // --|
            // |-----------
            //             |
            //          <--|
            coords = [
                {
                    x1: x1,
                    y1: y1,
                    x2: leftOffset,
                    y2: y1
                },
                {
                    x1: leftOffset,
                    y1: y1,
                    x2: leftOffset,
                    y2: y2offset
                },
                {
                    x1: leftOffset,
                    y1: y2offset,
                    x2: x2Offset,
                    y2: y2offset
                },
                {
                    x1: x2Offset,
                    y1: y2offset,
                    x2: x2Offset,
                    y2: y2
                },
                {
                    x1: x2Offset,
                    y1: y2,
                    x2: x2 + this.arrowOffset,
                    y2: y2
                }
            ];
        }
        else {
            // From after to
            //    -----|
            // <--|
            //     
            leftOffset = x1 - this.xOffset - this.arrowOffset;

            coords = [
                {
                    x1: x1,
                    y1: y1,
                    x2: leftOffset,
                    y2: y1
                },
                {
                    x1: leftOffset,
                    y1: y1,
                    x2: leftOffset,
                    y2: y2
                },
                {
                    x1: leftOffset,
                    y1: y2,
                    x2: x2 + this.arrowOffset,
                    y2: y2
                }
            ];
        }
        return coords;
    },

    getEndToStartCoordinates: function (fromBox, toBox) {
    
        var x1 = fromBox.right,
            y1 = fromBox.top - 1 + ((fromBox.bottom - fromBox.top) / 2),
            x2 = toBox.left,
            y2 = toBox.top - 1 + ((toBox.bottom - toBox.top) / 2),
            y2offset = fromBox.top < toBox.top ? (y2 - this.yOffset - this.midRowOffset) : (y2 + this.yOffset + this.midRowOffset),
            coords,
            leftOffset;

        if (x2 >= (x1 - 6) && y2 > y1) {
            /* To after from
            * ---
            *   |
            */

            leftOffset = Math.max(x1 - 6, x2) + this.xOffset;
            y2 = toBox.top;

            coords = [
                {
                    x1: x1,
                    y1: y1,
                    x2: leftOffset,
                    y2: y1
                },
                {
                    x1: leftOffset,
                    y1: y1,
                    x2: leftOffset,
                    y2: y2 - this.arrowOffset
                }
            ];
        }
        else {
            /* From after to
            *        -
            *        |
            *     ----
            *    |-> 
            */
            leftOffset = x1 + this.xOffset + this.arrowOffset;
            var x2Offset = x2 - this.xOffset - this.arrowOffset;
            coords = [
                {
                    x1: x1,
                    y1: y1,
                    x2: leftOffset,
                    y2: y1
                },
                {
                    x1: leftOffset,
                    y1: y1,
                    x2: leftOffset,
                    y2: y2offset
                },
                {
                    x1: leftOffset,
                    y1: y2offset,
                    x2: x2Offset,
                    y2: y2offset
                },
                {
                    x1: x2Offset,
                    y1: y2offset,
                    x2: x2Offset,
                    y2: y2
                },
                {
                    x1: x2Offset,
                    y1: y2,
                    x2: x2 - this.arrowOffset,
                    y2: y2
                }
            ];
        }
        return coords;
    },

    getEndToEndCoordinates: function (fromBox, toBox) {

        var x1 = fromBox.right,
            y1 = fromBox.top - 1 + ((fromBox.bottom - fromBox.top) / 2),
            x2 = toBox.right + this.arrowOffset,
            y2 = toBox.top - 1 + ((toBox.bottom - toBox.top) / 2),
            rightPointOffset = x2 + this.xOffset + this.arrowOffset;

        if (x1 > (x2 + this.xOffset)) {
            rightPointOffset += x1 - x2;
        }

        return [
            {
                x1: x1,
                y1: y1,
                x2: rightPointOffset,
                y2: y1
            },
            {
                x1: rightPointOffset,
                y1: y1,
                x2: rightPointOffset,
                y2: y2
            },
            {
                x1: rightPointOffset,
                y1: y2,
                x2: x2,
                y2: y2
            }
        ];
    }
});

/*
 * @class Gnt.view.Dependency
 * @extends Ext.util.Observable
 * @private
 * Internal class handling the dependency related functionality.
 */
Ext.define("Gnt.view.Dependency", {
    extend      : "Ext.util.Observable",

    requires    : [
        'Gnt.feature.DependencyDragDrop',
        'Gnt.view.DependencyPainter'
    ],

    ganttView       : null,
    painter         : null,
    taskStore       : null,
    store           : null,
    dnd             : null,
    
    lineTpl         : null,
    
    enableDependencyDragDrop    : true,
    
    renderAllDepsBuffered       : false,
    
    dependencyCls : 'sch-dependency',
    selectedCls : 'sch-dependency-selected',
    
    // private
    constructor: function (cfg) {
        this.callParent(arguments);
        
        var ganttView = this.ganttView;

        this.taskStore = ganttView.getTaskStore();
        
        ganttView.on({
            refresh     : this.renderAllDependenciesBuffered,
            scope       : this
//            ,
//            buffer      : 5, // Refresh is called repeatedly during sorting as nodes are added/removed 
//            delay       : (this.taskStore.buffered && Ext.isIE) ? 1 : 0 // IE screws up drawing if refresh happens too fast
        });
        
        this.taskStore.on({
            'root-fill-start'   : this.unBindTaskStore,
            'root-fill-end'     : this.bindTaskStore,
            
            scope               : this
        });

        this.bindTaskStore();
        this.bindDependencyStore();
        
        if (!this.lineTpl) {
            this.lineTpl = Ext.create("Ext.XTemplate", 
                '<tpl for=".">' +
                    Ext.String.format('<tpl for="lineCoordinates">' +
                        '<div class="{0} sch-dep-{parent.id} {0}-line {parent.cls}-line " style="left:{[Math.min(values.x1, values.x2)]}px;top:{[Math.min(values.y1, values.y2)]}px;width:{[Math.abs(values.x1-values.x2)' + (Ext.isBorderBox ? '+2' : '') + ']}px;height:{[Math.abs(values.y1-values.y2)' + (Ext.isBorderBox ? '+2' : '') + ']}px"></div>' +
                    '</tpl>' +
                    '<div style="left:{[values.lineCoordinates[values.lineCoordinates.length - 1].x2]}px;top:{[values.lineCoordinates[values.lineCoordinates.length - 1].y2]}px" class="{0}-arrow-ct {0} sch-dep-{id} {cls}-arrow-ct"><img src="' + Ext.BLANK_IMAGE_URL + '" class="{0}-arrow {0}-arrow-{[this.getArrowDirection(values.lineCoordinates)]} {cls}-arrow" /></div>', this.dependencyCls) +
                '</tpl>',
                {
                    compiled: true,      
                    disableFormats : true,
                    getArrowDirection: function (coords) {
                        var lastXY = coords[coords.length - 1];
                        if (lastXY.x1 === lastXY.x2) {
                            return 'down';
                        } else if (lastXY.x1 > lastXY.x2) {
                            return 'left';
                        } else {
                            return 'right';
                        }
                    }
                }
            );
        }

        this.painter = Ext.create("Gnt.view.DependencyPainter", Ext.apply({
            rowHeight   : ganttView.rowHeight,
            taskStore   : this.taskStore,
            view        : ganttView
        }, cfg));

        this.addEvents(
            /**
            * @event beforednd
            * Fires before a drag and drop operation is initiated, return false to cancel it
            * @param {Gnt.view.Dependency} dm the dependency manager instance
            * @param {HTMLNode} node The node that's about to be dragged
            * @param {Ext.EventObject} e The event object
            */
            'beforednd',

            /**
            * @event dndstart
            * Fires when a dependency drag and drop operation starts
            * @param {Gnt.view.Dependency} dm the dependency manager instance
            */
            'dndstart',

            /**
            * @event drop
            * Fires after a drop has been made on a receiving terminal
            * @param {Gnt.view.Dependency} dm the dependency manager instance
            * @param {Mixed} fromId The source dependency record id
            * @param {Mixed} toId The target dependency record id
            * @param {Int} type The dependency type, see sch.dependencymanager.js for more information
            */
            'drop',

            /**
            * @event afterdnd
            * Always fires after a dependency drag and drop operation
            * @param {Gnt.view.Dependency} dm the dependency manager instance
            */
            'afterdnd',

            /**
            * @event beforecascade
            * Fires before a cascade operation is initiated
            * @param {Gnt.view.Dependency} dm the dependency manager instance
            */
            'beforecascade',

            /**
            * @event cascade
            * Fires when after a cascade operation has completed
            * @param {Gnt.view.Dependency} dm the dependency manager instance
            */
            'cascade',

            /**
            * @event dependencydblclick
            * Fires after double clicking on a dependency line/arrow
            * @param {Gnt.view.Dependency} g The gantt panel instance
            * @param {Gnt.model.Dependency} record The dependency record 
            * @param {Ext.EvenObject} event The event object
            * @param {HTMLElement} target The target of this event
            */
            'dependencydblclick'
        );

        if (this.enableDependencyDragDrop) {
            this.dnd = Ext.create("Gnt.feature.DependencyDragDrop", {
                ganttView : this.ganttView
            });
            this.dnd.on('drop', this.onDependencyDrop, this);
            this.relayEvents(this.dnd, ['beforednd', 'dndstart', 'afterdnd', 'drop']);
        }
        
        // Setup our own container element
        this.containerEl = this.containerEl.createChild({
            cls : 'sch-dependencyview-ct'
        });

        this.ganttView.mon(this.containerEl, 'dblclick', this.onDependencyDblClick, this, { delegate : '.' + this.dependencyCls });
    },
    
    bindDependencyStore : function () {
        this.store.on({
            datachanged     : this.renderAllDependenciesBuffered,
            load            : this.renderAllDependenciesBuffered,
            
            add             : this.onDependencyAdd,
            update          : this.onDependencyUpdate,
            remove          : this.onDependencyDelete,
            
            scope           : this
        });
    },

    unBindDependencyStore : function () {
        this.store.un({
            datachanged     : this.renderAllDependenciesBuffered,
            load            : this.renderAllDependenciesBuffered,
            
            add             : this.onDependencyAdd,
            update          : this.onDependencyUpdate,
            remove          : this.onDependencyDelete,
            
            scope           : this
        });
    },

    bindTaskStore : function () {
        var taskStore       = this.taskStore;
        var ganttView       = this.ganttView;
        
        // if the view is animated, then update the dependencies in "after*" events (when the animation has completed)
        if (ganttView.animate) {
            ganttView.on({
                afterexpand     : this.renderAllDependenciesBuffered,
                aftercollapse   : this.renderAllDependenciesBuffered,
                
                scope           : this
            });
        } else {
            taskStore.on({
                expand          : this.renderAllDependenciesBuffered,
                collapse        : this.renderAllDependenciesBuffered,
                
                scope           : this
            });
        }
        
        taskStore.on({
            cascade         : function(store, cascadeContext) { 
                if (cascadeContext && cascadeContext.nbrAffected > 0) {
                    this.renderAllDependenciesBuffered();
                }
            },
            remove          : this.renderAllDependenciesBuffered,
            insert          : this.renderAllDependenciesBuffered,
            append          : this.renderAllDependenciesBuffered,
            move            : this.renderAllDependenciesBuffered,
            
            scope           : this
        });

        taskStore.on({
            update          : this.onTaskUpdated,
            scope           : this
        });
    },
    
    
    unBindTaskStore : function () {
        var taskStore       = this.taskStore;
        var ganttView       = this.ganttView;
        
        if (ganttView.animate) {
            ganttView.un({
                afterexpand     : this.renderAllDependenciesBuffered,
                aftercollapse   : this.renderAllDependenciesBuffered,
                
                scope           : this
            });
        } else {
            taskStore.un({
                expand          : this.renderAllDependenciesBuffered,
                collapse        : this.renderAllDependenciesBuffered,
                
                scope           : this
            });
        }
        
        taskStore.un({
            cascade         : this.renderAllDependenciesBuffered,
            remove          : this.renderAllDependenciesBuffered,
            insert          : this.renderAllDependenciesBuffered,
            append          : this.renderAllDependenciesBuffered,
            move            : this.renderAllDependenciesBuffered,
            
            scope           : this
        });

        taskStore.un({
            update          : this.onTaskUpdated,
            
            scope           : this
        });
    },
    
    onDependencyDblClick : function(e, t) {
        var rec = this.getRecordForDependencyEl(t);
        this.fireEvent('dependencydblclick', this, rec, e, t);
    },
    
    /**
    * Highlight the elements representing a particular dependency
    * @param {Mixed} record Either the id of a record or a record in the dependency store
    */
    highlightDependency: function (record) {
        if (!(record instanceof Ext.data.Model)) {
            record = this.getDependencyRecordByInternalId(record);
        }
        this.getElementsForDependency(record).addCls(this.selectedCls);
    },

    
    /**
    * Remove highlight of the elements representing a particular dependency
    * @param {Mixed} record Either the id of a record or a record in the dependency store
    */
    unhighlightDependency: function (record) {
        if (!(record instanceof Ext.data.Model)) {
            record = this.getDependencyRecordByInternalId(record);
        }
        this.getElementsForDependency(record).removeCls(this.selectedCls);
    },

    
    /**
    * Retrieve the elements representing a particular dependency
    * @param {Record} rec the record in the dependency store
    * @return {CompositeElementLite/CompositeElement}
    */
    getElementsForDependency: function (rec) {
        var id = rec instanceof Ext.data.Model ? rec.internalId : rec;
        return this.containerEl.select('.sch-dep-' + id);
    },
    
    // private
    depRe: new RegExp('sch-dep-([^\\s]+)'),

    
    getDependencyRecordByInternalId : function(id) {
        var r, i, l;

        for (i = 0, l = this.store.getCount(); i < l; i++) {
            r = this.store.getAt(i);
            if (r.internalId == id) {
                return r;
            }
        }
        return null;
    },

    // private
    getRecordForDependencyEl: function (t) {
        var m = t.className.match(this.depRe),
            rec = null;

        if (m && m[1]) {
            var recordId = m[1];

            rec = this.getDependencyRecordByInternalId(recordId);
        }

        return rec;
    },
    
    
    renderAllDependenciesBuffered : function () {
        var me = this;
        
        this.containerEl.update('');    

        setTimeout(function () {
            if (!me.ganttView.isDestroyed) me.renderAllDependencies();
        }, 0);
    },

    /**
    * Renders all the dependencies for the current view
    */
    renderAllDependencies : function() {
        
        // component has been destroyed already
        if (!this.containerEl.dom) return;
        
        this.getDependencyElements().remove();    
        this.renderDependencies(this.store.data.items);
    },

    /**
    * Returns all the elements representing the rendered dependencies
    * @return {CompositeElement}
    */
    getDependencyElements : function() {
        return this.containerEl.select('.' + this.dependencyCls);    
    },
    
    renderDependencies: function (dependencyRecords) {
        if (dependencyRecords){
            var tplData = this.painter.getDependencyTplData(dependencyRecords);
            this.lineTpl[Ext.isIE ? "insertFirst" : "append"](this.containerEl, tplData);
        }
    },

    
    renderTaskDependencies: function (tasks) {
        var toDraw  = [];

        if (!Ext.isArray(tasks)) {
            tasks = [tasks];
        }

        for (var i = 0, n = tasks.length; i < n; i++) {
            toDraw = toDraw.concat(tasks[i].getAllDependencies());
        }
        this.renderDependencies(toDraw);
    },
    
    onDependencyUpdate: function (store, depRecord) {
        this.removeDependencyElements(depRecord, false);
        
        // Draw new dependencies for the event
        this.renderDependencies(depRecord);
    },


    
    onDependencyAdd: function (store, depRecords) {
        // Draw added dependencies
        this.renderDependencies(depRecords);
    },

    removeDependencyElements: function (record, animate) {
        if (animate !== false) {
            this.getElementsForDependency(record).fadeOut({ remove: true });
        } else {
            this.getElementsForDependency(record).remove();
        }
    },

    onDependencyDelete: function (store, depRecord) {
        this.removeDependencyElements(depRecord);
    },
    
    dimEventDependencies: function (eventId) {
        this.containerEl.select(this.depRe + eventId).setOpacity(0.2);
    },

     // private
    clearSelectedDependencies : function() {
        this.containerEl.select('.' + this.selectedCls).removeCls(this.selectedCls);
    },

    
    onTaskUpdated: function (store, task, operation) {
        if (!this.taskStore.cascading && 
            operation != Ext.data.Model.COMMIT && 
            (!task.previous || task.startDateField in task.previous || task.endDateField in task.previous)) {
            this.updateDependencies(task);
        }
    },
    
    
    updateDependencies: function (tasks) {
        if (!Ext.isArray(tasks)) {
            tasks = [ tasks ];
        }
        
        var me      = this;
        
        Ext.each(tasks, function (task) {
            Ext.each(task.getAllDependencies(), function (dependency) {
                me.removeDependencyElements(dependency, false);
            });
        });
        
        // Draw new dependencies for the task
        this.renderTaskDependencies(tasks);
    },

    
    onDependencyDrop: function (plugin, fromId, toId, type) {
         var newDependency = new this.store.model({
            fromTask : fromId,
            toTask : toId,
            type : type
        });

        if (this.store.isValidDependency(newDependency)) {
            this.store.add(newDependency);
        }
    },
    
    destroy: function () {
        if (this.dnd) {
            this.dnd.destroy();
        }
    }
});

/**

@class Gnt.view.Gantt
@extends Sch.view.TimelineTreeView

A view of the gantt panel. Use the {@link Gnt.panel.Gantt#getSchedulingView} method to get its instance from gantt panel.

*/
Ext.define("Gnt.view.Gantt", {
    extend      : "Sch.view.TimelineTreeView",
    
    alias       : ['widget.ganttview'],
    
    requires    : [
        'Gnt.view.Dependency',
        'Gnt.model.Task',
        'Gnt.template.Task',    
        'Gnt.template.ParentTask',
        'Gnt.template.Milestone',
        'Gnt.feature.TaskDragDrop',
        'Gnt.feature.ProgressBarResize',
        'Gnt.feature.TaskResize',
        'Sch.view.Horizontal'
    ],

    uses : [
        'Gnt.feature.LabelEditor',
        'Gnt.feature.DragCreator'
    ],
    
    _cmpCls         : 'sch-ganttview',
    rowHeight       : 22,
    
    barMargin       : 4,
    
    scheduledEventName          : 'task',

    trackOver           : false,
    toggleOnDblClick    : false,

    // Number of pixels to offset a milestone diamond
    milestoneOffset     : 8,
    
    // Number of pixels to offset a parent task 
    parentTaskOffset    : 6,
     
    // private
    eventSelector       : '.sch-gantt-item',
    
    eventWrapSelector   : '.sch-event-wrap',
    
    
    progressBarResizer  : null,
    taskResizer         : null,
    taskDragDrop        : null,
    dragCreator         : null,
    dependencyView      : null,
    
    resizeConfig        : null,
    dragDropConfig      : null,
    
    
    constructor: function (config) {
        var pnl = config.panel._top;

        Ext.apply(this, {
            taskStore                   : pnl.taskStore,
            dependencyStore             : pnl.dependencyStore,
            
            enableDependencyDragDrop    : pnl.enableDependencyDragDrop,
            enableTaskDragDrop          : pnl.enableTaskDragDrop,
            enableProgressBarResize     : pnl.enableProgressBarResize,
            enableDragCreation          : pnl.enableDragCreation,
            
            allowParentTaskMove         : pnl.allowParentTaskMove,
            toggleParentTasksOnClick    : pnl.toggleParentTasksOnClick,
            
            resizeHandles               : pnl.resizeHandles,
            enableBaseline              : pnl.baselineVisible || pnl.enableBaseline,
            
            leftLabelField              : pnl.leftLabelField,
            rightLabelField             : pnl.rightLabelField,
            
            eventTemplate               : pnl.eventTemplate,
            
            parentEventTemplate         : pnl.parentEventTemplate,
            milestoneTemplate           : pnl.milestoneTemplate,
            
            resizeConfig                : pnl.resizeConfig,
            dragDropConfig              : pnl.dragDropConfig
        });

        this.addEvents(
            // Task click-events --------------------------
            /**
            * @event taskclick
            * Fires when a task is clicked
            * 
            * @param {Gnt.view.Gantt} gantt The gantt view instance
            * @param {Gnt.model.Task} taskRecord The task record 
            * @param {Ext.EventObject} e The event object
            */
            'taskclick', 
            
            /**
            * @event taskdblclick
            * Fires when a task is double clicked
            * 
            * @param {Gnt.view.Gantt} gantt The gantt view instance
            * @param {Gnt.model.Task} taskRecord The task record 
            * @param {Ext.EventObject} e The event object
            */
            'taskdblclick', 
            
            /**
            * @event taskcontextmenu
            * Fires when contextmenu is activated on a task
            * 
            * @param {Gnt.view.Gantt} gantt The gantt view instance
            * @param {Gnt.model.Task} taskRecord The task record 
            * @param {Ext.EventObject} e The event object
            */
            'taskcontextmenu', 

            
            // Resizing events start --------------------------
            /**
            * @event beforetaskresize
            * Fires before a resize starts, return false to stop the execution
            * 
            * @param {Gnt.view.Gantt} gantt The gantt view instance
            * @param {Gnt.model.Task} taskRecord The task about to be resized
            * @param {Ext.EventObject} e The event object
            */
            'beforetaskresize', 
            
            /**
            * @event taskresizestart
            * Fires when resize starts
            * 
            * @param {Gnt.view.Gantt} gantt The gantt view instance
            * @param {Gnt.model.Task} taskRecord The task about to be resized
            */
            'taskresizestart', 
            
            /**
            * @event partialtaskresize
            * Fires during a resize operation and provides information about the current start and end of the resized event
            * @param {Gnt.view.Gantt} gantt The gantt view instance
            * 
            * @param {Gnt.model.Task} taskRecord The task being resized
            * @param {Date} startDate The start date of the task
            * @param {Date} endDate The end date of the task
            * @param {Ext.Element} The element being resized
            */
            'partialtaskresize', 
            
            /**
            * @event aftertaskresize
            * Fires after a succesful resize operation
            * @param {Gnt.view.Gantt} gantt The gantt view instance
            * @param {Gnt.model.Task} taskRecord The task that has been resized
            */
            'aftertaskresize',
            
            
            // Task progress bar resizing events start --------------------------
            /**
            * @event beforeprogressbarresize
            * Fires before a progress bar resize starts, return false to stop the execution
            * @param {Gnt.view.Gantt} gantt The gantt view instance
            * @param {Gnt.model.Task} taskRecord The record about to be have its progress bar resized
            */
            'beforeprogressbarresize', 
            
            /**
            * @event progressbarresizestart
            * Fires when a progress bar resize starts
            * @param {Gnt.view.Gantt} gantt The gantt view instance
            * @param {Gnt.model.Task} taskRecord The record about to be have its progress bar resized
            */
            'progressbarresizestart', 
           
            /**
            * @event afterprogressbarresize
            * Fires after a succesful progress bar resize operation
            * @param {Gnt.view.Gantt} gantt The gantt view instance
            * @param {Gnt.model.Task} taskRecord record The updated record
            */
            'afterprogressbarresize',

            
            // Dnd events start --------------------------
            /**
            * @event beforetaskdrag
            * Fires before a task drag drop is initiated, return false to cancel it
            * @param {Gnt.view.Gantt} gantt The gantt view instance
            * @param {Gnt.model.Task} taskRecord The task record that's about to be dragged
            * @param {Ext.EventObject} e The event object
            */ 
            'beforetaskdrag', 
            
            /**
            * @event taskdragstart
            * Fires when a dnd operation starts
            * @param {Gnt.view.Gantt} gantt The gantt view instance
            * @param {Gnt.model.Task} taskRecord The record being dragged
            */
            'taskdragstart',
            
            /**
            * @event taskdrop
            * Fires after a succesful drag and drop operation
            * @param {Gnt.view.Gantt} gantt The gantt view instance
            * @param {Gnt.model.Task} taskRecord The dropped record
            */
            'taskdrop',
            
            /**
            * @event aftertaskdrop
            * Fires after a drag and drop operation, regardless if the drop valid or invalid
            * @param {Gnt.view.Gantt} gantt The gantt view instance
            */
            'aftertaskdrop',
            
            
            // Label editors events --------------------------
            /**
             * @event labeledit_beforestartedit
             * Fires before editing is started for a field
             * @param {Gnt.view.Gantt} gantt The gantt view instance
             * @param {Gnt.model.Task} taskRecord The task record 
             */
            'labeledit_beforestartedit', 

            /**
             * @event labeledit_beforecomplete
             * Fires after a change has been made to a label field, but before the change is reflected in the underlying field.
             * @param {Gnt.view.Gantt} gantt The gantt view instance
             * @param {Mixed} value The current field value
             * @param {Mixed} startValue The original field value
             * @param {Gnt.model.Task} taskRecord The affected record 
             */
            'labeledit_beforecomplete', 
            
            /**
             * @event labeledit_complete
             * Fires after editing is complete and any changed value has been written to the underlying field.
             * @param {Gnt.view.Gantt} gantt The gantt view instance
             * @param {Mixed} value The current field value
             * @param {Mixed} startValue The original field value
             * @param {Gnt.model.Task} taskRecord The affected record 
             */
            'labeledit_complete',

            
            // Dependencies events--------------------------
            /**
             * @event beforedependencydrag
             * Fires before a dependency drag operation starts (from a "task terminal").
             * @param {Gnt.view.Gantt} gantt The gantt view instance
             * @param {Gnt.model.Task} taskRecord The source task record 
             */
            'beforedependencydrag', 

             /**
             * @event dependencydragstart
             * Fires when a dependency drag operation starts 
             * @param {Gnt.view.Gantt} gantt The gantt view instance
             */
            'dependencydragstart', 

            /**
             * @event dependencydrop
             * Fires when a dependency drag drop operation has completed successfully and a new dependency has been created.
             * @param {Gnt.view.Gantt} gantt The gantt view instance
             * @param {Gnt.model.Task} fromRecord The source task record 
             * @param {Gnt.model.Task} toRecord The destination task record 
             * @param {Int} type The dependency type
             */
            'dependencydrop', 

            /**
             * @event afterdependencydragdrop
             * Always fires after a dependency drag-drop operation
             * @param {Gnt.view.Gantt} gantt The gantt view instance
             */
            'afterdependencydragdrop'
        );

        this.callParent(arguments);
    },

    initComponent: function () {
        this.configureLabels();
        this.setupGanttEvents();
        this.callParent(arguments);
        this.setupTemplates();
    },
    
    /**
     * Returns the associated dependency store
     * @return {Gnt.data.TaskStore}
     */
    getDependencyStore : function() {
        return this.dependencyStore;
    },
    

    configureFeatures : function() {
        if (this.enableProgressBarResize !== false) {
            this.progressBarResizer = Ext.create("Gnt.feature.ProgressBarResize", {
                gantt : this
            });
            this.on({
                beforeprogressbarresize : this.onBeforeTaskProgressBarResize, 
                progressbarresizestart : this.onTaskProgressBarResizeStart,
                afterprogressbarresize : this.onTaskProgressBarResizeEnd,
                scope : this
            });
        }
        
        if (this.resizeHandles !== 'none') {
            
            this.taskResizer = Ext.create("Gnt.feature.TaskResize", Ext.apply({
                gantt : this,
                validatorFn : this.resizeValidatorFn || Ext.emptyFn,
                validatorFnScope : this.validatorFnScope || this
            }, this.resizeConfig || {}));

            this.on({
                beforedragcreate : this.onBeforeDragCreate,
                beforeresize : this.onBeforeTaskResize, 
                taskresizestart : this.onTaskResizeStart,
                aftertaskresize : this.onTaskResizeEnd,
                scope : this
            });
        }
        
        if (this.enableTaskDragDrop) {
            this.taskDragDrop = Ext.create("Gnt.feature.TaskDragDrop", Ext.apply({
                gantt : this,
                validatorFn : this.dndValidatorFn  || Ext.emptyFn,
                validatorFnScope : this.validatorFnScope || this
            }, this.dragDropConfig));
                
            this.on({
                beforetaskdrag : this.onBeforeTaskDrag, 
                taskdragstart: this.onDragDropStart,
                aftertaskdrop: this.onDragDropEnd,
                scope : this
            });
        }

        if (this.enableDragCreation) {
            this.dragCreator = Ext.create("Gnt.feature.DragCreator", Ext.apply({
                ganttView : this
            }));
        }
    },


    prepareData: function(data, idx, record) {
        var me        = this,
            obj       = {},
            headers   = me.gridDataColumns || me.getGridColumns();
        
        obj[headers[0].id] = this.renderTask(record);
        
        return obj;
    },

    // private
    renderTask: function (taskModel) {
        var taskStart = taskModel.getStartDate(),
            ta = this.timeAxis,
            D = Sch.util.Date,
            tplData = {},
            cellResult = '',
            viewStart = ta.getStart(),
            viewEnd = ta.getEnd(),
            isMilestone = taskModel.isMilestone(),
            isLeaf = taskModel.isLeaf(),
            userData, startsInsideView, endsOutsideView;
            
        if (taskStart) {
            var taskEnd = taskModel.getEndDate() || Sch.util.Date.add(taskStart, Sch.util.Date.DAY, 1),
                doRender = Sch.util.Date.intersectSpans(taskStart, taskEnd, viewStart, viewEnd);

            if (doRender) {
                endsOutsideView = taskEnd > viewEnd;
                startsInsideView = D.betweenLesser(taskStart, viewStart, viewEnd);

                var taskStartX = Math.floor(this.getXYFromDate(startsInsideView ? taskStart : viewStart)[0]),
                    taskEndX = Math.floor(this.getXYFromDate(endsOutsideView ? viewEnd : taskEnd)[0]),
                    itemWidth = isMilestone ? 0 : taskEndX - taskStartX;

                if (!isMilestone && !isLeaf) {
                    if (endsOutsideView) {
                        itemWidth += this.parentTaskOffset; // Compensate for the parent arrow offset (6px on left side)
                    } else {
                        itemWidth += 2*this.parentTaskOffset; // Compensate for the parent arrow offset (6px on both sides)
                    }
                }

                tplData = {
                    // Core properties
                    id: taskModel.internalId,
                    leftOffset: isMilestone ? (taskEndX || taskStartX) : taskStartX,
                    width : Math.max(1, itemWidth),

                    // Percent complete
                    percentDone: Math.min(taskModel.getPercentDone() || 0, 100)
                };

                // Get data from user "renderer" 
                userData = this.eventRenderer.call(this.eventRendererScope || this, taskModel, tplData, taskModel.store) || {};
                var lField = this.leftLabelField,
                    rField = this.rightLabelField,
                    tpl;

                if (lField) {
                    // Labels
                    tplData.leftLabel = lField.renderer.call(lField.scope || this, taskModel.data[lField.dataIndex], taskModel);
                }

                if (rField) {
                    tplData.rightLabel = rField.renderer.call(rField.scope || this, taskModel.data[rField.dataIndex], taskModel);
                }

                Ext.apply(tplData, userData);

                if (isMilestone) {
                    tpl = this.milestoneTemplate;
                } else {
                    tplData.width = Math.max(1, itemWidth);
                    var ctcls = '';

                    if (endsOutsideView) {
                        ctcls = ' sch-event-endsoutside ';
                    }

                    if (!startsInsideView) {
                        ctcls = ' sch-event-startsoutside ';
                    }
                    tplData.ctcls = (tplData.ctcls || '') + ctcls;
                    tpl = this[isLeaf ? "eventTemplate" : "parentEventTemplate"];
                }

                tplData.cls = (tplData.cls || '') + (taskModel.dirty ? ' sch-dirty ' : '') + (taskModel.getCls() || '');

                cellResult += tpl.apply(tplData);
            }
        }
        
        if (this.enableBaseline) {
            
            var taskBaselineStart = taskModel.getBaselineStartDate(),
                taskBaselineEnd = taskModel.getBaselineEndDate();

            if (!userData) {
                userData = this.eventRenderer.call(this, taskModel, tplData, taskModel.store) || {};
            }
            
            if (taskBaselineStart && taskBaselineEnd) {
                endsOutsideView = taskBaselineEnd > viewEnd;
                startsInsideView = D.betweenLesser(taskBaselineStart, viewStart, viewEnd);
                
                var isBaselineMilestone = taskModel.isBaselineMilestone(),
                    baseTpl = isBaselineMilestone ? this.baselineMilestoneTemplate : (taskModel.isLeaf() ? this.baselineTaskTemplate : this.baselineParentTaskTemplate),
                    baseStartX = Math.floor(this.getXYFromDate(startsInsideView ? taskBaselineStart : viewStart)[0]),
                    baseWidth = isBaselineMilestone ? 0 : Math.floor(this.getXYFromDate(endsOutsideView ? viewEnd : taskBaselineEnd)[0]) - baseStartX;
                    
                cellResult += baseTpl.apply({
                    basecls : userData.basecls || '',
                    id: taskModel.internalId + '-base',
                    percentDone: taskModel.getBaselinePercentDone(),
                    leftOffset: baseStartX,
                    width: Math.max(1, baseWidth)
                });
            }
        }

        return cellResult;
    },


    setupTemplates: function () {

        var tplCfg = {
            leftLabel : !!this.leftLabelField,
            rightLabel : !!this.rightLabelField,
            prefix : this.eventPrefix,
            enableDependencyDragDrop: this.enableDependencyDragDrop !== false,
            resizeHandles: this.resizeHandles,
            enableProgressBarResize: this.enableProgressBarResize
        };

        if (!this.eventTemplate) {
            tplCfg.baseCls = "sch-gantt-task {ctcls}";
            this.eventTemplate = Ext.create("Gnt.template.Task", tplCfg);
        }

        if (!this.parentEventTemplate) {
            tplCfg.baseCls = "sch-gantt-parent-task {ctcls}";
            this.parentEventTemplate = Ext.create("Gnt.template.ParentTask", tplCfg);
        }

        if (!this.milestoneTemplate) {
            tplCfg.baseCls = "sch-gantt-milestone {ctcls}";
            this.milestoneTemplate = Ext.create("Gnt.template.Milestone", tplCfg);
        }

        if (this.enableBaseline) {    
            tplCfg = { 
                prefix : this.eventPrefix
            };
            if (!this.baselineTaskTemplate) {
                tplCfg.baseCls = "sch-gantt-task-baseline sch-gantt-baseline-item {basecls}";
                this.baselineTaskTemplate = Ext.create("Gnt.template.Task", tplCfg);
            }

            if (!this.baselineParentTaskTemplate) {
                tplCfg.baseCls = "sch-gantt-parenttask-baseline sch-gantt-baseline-item {basecls}";
                this.baselineParentTaskTemplate = Ext.create("Gnt.template.ParentTask", tplCfg);
            }

            if (!this.baselineMilestoneTemplate) {
                tplCfg.baseCls = "sch-gantt-milestone-baseline sch-gantt-baseline-item {basecls}";
                this.baselineMilestoneTemplate = Ext.create("Gnt.template.Milestone", tplCfg);
            }
        }
    },

    /**
     * Wrapper function returning the dependency manager instance
     * @return {Gnt.view.Dependency} dependencyManager The dependency manager instance
     */
    getDependencyView : function() {
        return this.dependencyView;
    },


    /**
     * Returns the associated task store
     * @return {Gnt.data.TaskStore}
     */
    getTaskStore : function() {
        return this.taskStore;
    },
     
    // private
    initDependencies : function() {
 
        if (this.dependencyStore) {
            var me = this,
                dv = Ext.create("Gnt.view.Dependency", {
                    containerEl : me.el,
                    ganttView : me,
                    enableDependencyDragDrop : me.enableDependencyDragDrop,
                    store : me.dependencyStore
                });
        
            dv.on({
                beforednd : me.onBeforeDependencyDrag, 
                dndstart : me.onDependencyDragStart, 
                drop : me.onDependencyDrop, 
                afterdnd : me.onAfterDependencyDragDrop,
                beforecascade : me.onBeforeCascade,
                cascade : me.onCascade,
                scope : me
            }); 

            me.dependencyView = dv;

            me.relayEvents(dv, [
                /**
                * @event dependencydblclick
                * Fires after double clicking on a dependency line/arrow
                * @param {Gnt.view.Dependency} dv The dependency view 
                * @param {Gnt.model.Dependency} record The dependency record 
                * @param {Ext.EvenObject} event The event object
                * @param {HTMLElement} target The target of this event
                */
                'dependencydblclick'
            ]);
        }
    },

    
    // private
    setupGanttEvents: function () {
        var sm = this.getSelectionModel();

        if (this.toggleParentTasksOnClick) {
            this.on({
                taskclick : function(g, model) {
                    if (!model.isLeaf()) {
                        this.toggle(model);
                    }
                },
                scope : this
            });
        }
    },

    // private
    configureLabels: function () {

        var defaults = {
            renderer    : function (v) { return v; },
            dataIndex   : undefined
        };

        var leftLabelField  = this.leftLabelField;
        
        if (leftLabelField) {
            if (Ext.isString(leftLabelField)) {
                
                leftLabelField = this.leftLabelField = { dataIndex: leftLabelField };
            }
            Ext.applyIf(leftLabelField, defaults);
            
            // Initialize left editor (if defined)
            if (leftLabelField.editor) {
                leftLabelField.editor = Ext.create("Gnt.feature.LabelEditor", this, {
                    alignment       : 'r-r',
                    delegate        : '.sch-gantt-label-left',
                    labelPosition   : 'left',
                    field           : leftLabelField.editor,
                    dataIndex       : leftLabelField.dataIndex
                });
            }
        }

        var rightLabelField = this.rightLabelField;
        
        if (rightLabelField) {
            if (Ext.isString(rightLabelField)) {
                rightLabelField = this.rightLabelField = { dataIndex: rightLabelField };
            }

            Ext.applyIf(rightLabelField, defaults);

            // Initialize right editor (if defined)
            if (rightLabelField.editor) {
                rightLabelField.editor = Ext.create("Gnt.feature.LabelEditor", this, {
                    alignment       : 'l-l',
                    delegate        : '.sch-gantt-label-right',
                    labelPosition   : 'right',
                    
                    field           : rightLabelField.editor,
                    dataIndex       : rightLabelField.dataIndex
                });
            }
        }

        this.on('labeledit_beforestartedit', this.onBeforeLabelEdit, this);
    },

    // private
    onBeforeTaskDrag: function (p, record) {
        return !this.readOnly && (this.allowParentTaskMove || record.isLeaf());
    },

    onDragDropStart: function () {
        if (this.tip) {
            this.tip.disable();
        }
    },

    onDragDropEnd: function () {
        if (this.tip) {
            this.tip.enable();
        }
    },

    onTaskProgressBarResizeStart : function() {
        if (this.tip) {
            this.tip.hide();
            this.tip.disable();
        }
    },

    onTaskProgressBarResizeEnd : function() {
        if (this.tip) {
            this.tip.enable();
        }
    },

    onTaskResizeStart: function () {
        if (this.tip) {
            this.tip.hide();
            this.tip.disable();
        }
    },

    onTaskResizeEnd: function () {
        if (this.tip) {
            this.tip.enable();
        }
    },

    // private
    onBeforeDragCreate: function () {
        return !this.readOnly;
    },

    // private
    onBeforeTaskResize: function () {
        return !this.readOnly;
    },

    onBeforeTaskProgressBarResize: function () {
        return !this.readOnly;
    },

    onBeforeLabelEdit: function () {
        return !this.readOnly;
    },

    onBeforeEdit: function () {
        return !this.readOnly;
    },

    beforeRender : function() {
        this.addCls('sch-ganttview');
        this.callParent(arguments);
    },
    
    afterRender : function() {
        this.initDependencies();
        this.callParent(arguments);

        this.el.on('mousemove', this.configureFeatures, this, { single : true });
    },

    resolveTaskRecord : function (el) {
        var node = this.findItemByChild(el);
        if (node) {
            return this.getRecord(this.findItemByChild(el));
        } 
        return null;
    },

    resolveEventRecord : function(el) {
        return this.resolveTaskRecord(el);
    },

    /**
     * Highlights a task and optionally any dependent tasks. Highlighting will add the `sch-gantt-task-highlighted` class to the task's row.
     * Highlighting state is currently not persistent - ie any refresh will unhighlight the tasks.
     * 
     * @param {Mixed} task Either a task record or the id of a task
     * @param {Boolean} highlightDependentTasks `true` to highlight the depended tasks. Defaults to `true`
     * 
     */
    highlightTask : function(task, highlightDependentTasks) {
        if (!(task instanceof Ext.data.Model)) {
            task = this.taskStore.getById(task);
        }
        
        if (task) {
            var el = this.getNode(task);
            if (el) {
                Ext.fly(el).addCls('sch-gantt-task-highlighted');
            }

            var taskId = task.getId() || task.internalId;
        
            if (highlightDependentTasks !== false) {
                this.dependencyStore.each(function(dep) {
                    
                    if (dep.getSourceId() == taskId) {
                        this.highlightDependency(dep.id);
                        this.highlightTask(dep.getTargetId(), highlightDependentTasks);
                    }
                }, this);
            }
        }
    },
    
    
    /**
     * Un-highlights a task and optionally any dependent tasks.
     * 
     * @param {Mixed} task Either a task record or the id of a task
     * @param {Boolean} alsoDependedTasks `true` to highlight the depended tasks. Defaults to `true`
     * 
     */
    unhighlightTask : function(task, alsoDependedTasks) {
        if (!(task instanceof Ext.data.Model)) {
            task = this.taskStore.getById(task);
        }
        
        if (task) {
            Ext.fly(this.getNode(task)).removeCls('sch-gantt-task-highlighted');
            
            var taskId      = task.getId() || task.internalId;
        
            if (alsoDependedTasks !== false) {
                this.dependencyStore.each(function(dep) {
                    
                    if (dep.getSourceId() == taskId) {
                        this.unhighlightDependency(dep.id);
                        this.unhighlightTask(dep.getTargetId(), alsoDependedTasks);
                    }
                }, this);
            }
        }
    },
    
    
    // private
    clearSelectedTasksAndDependencies : function() {
        this.getSelectionModel().deselectAll();
        
        this.getDependencyView().clearSelectedDependencies();
        this.el.select('tr.sch-gantt-task-highlighted').removeCls('sch-gantt-task-highlighted');
    },


    /**
     * Returns the critical path(s) that can affect the end date of the project
     * @return {Array} paths An array of arrays (containing task chains)
     */
    getCriticalPaths : function() {
        return this.taskStore.getCriticalPaths();
    },

    
     /**
     * Highlights the critical path(s) that can affect the end date of the project.
     * This method will reset the selection. While the critical path is highlighted, the selection model is locked. 
     */
    highlightCriticalPaths : function() {
        // First clear any selected tasks/dependencies
        this.clearSelectedTasksAndDependencies();
        
        var paths = this.getCriticalPaths(),
            dm = this.getDependencyView(),
            ds = this.dependencyStore,
            t,i,l, depRecord;
        
        Ext.each(paths, function(tasks) {
            for (i = 0, l = tasks.length; i < l; i++) {
                t = tasks[i];
                this.highlightTask(t, false);
                
                if (i < (l - 1)) {
                    depRecord = ds.getAt(ds.findBy(function(dep) { 
                        return dep.getTargetId() === (t.getId() || t.internalId) && dep.getSourceId() === (tasks[i+1].getId() || tasks[i+1].internalId); 
                    }));
                    dm.highlightDependency(depRecord);
                }
            }
        }, this);
        
        this.addCls('sch-gantt-critical-chain');
        
        this.getSelectionModel().setLocked(true);
    },
    
    
    /**
     * Removes the highlighting of the critical path(s) and unlocks the selection model.
     */
    unhighlightCriticalPaths : function() {
        this.el.removeCls('sch-gantt-critical-chain');
        
        this.getSelectionModel().setLocked(false);
        
        this.clearSelectedTasksAndDependencies();
    },

    
    //private
    getXOffset : function(task) {
        var offset = 0;
        
        if (task.isMilestone()) {
            offset = this.milestoneOffset;
        } else if (!task.isLeaf()) {
            offset = this.parentTaskOffset;
        }

        return offset;
    },

    //private
    onDestroy : function() {
        if (this.dependencyView) {
            this.dependencyView.destroy();
        }
        this.callParent(arguments);
    },

    /**
     * Convenience method wrapping the dependency manager method which highlights the elements representing a particular dependency
     * @param {Mixed} record Either the id of a record or a record in the dependency store
     */
    highlightDependency : function(record) {
        this.dependencyView.highlightDependency(record);
    },
    
    /**
     * Convenience method wrapping the dependency manager method which unhighlights the elements representing a particular dependency
     * @param {Mixed} depId Either the id of a record or a record in the dependency store
     */
    unhighlightDependency : function(record) {
        this.dependencyView.unhighlightDependency(record);
    },

    
    // private
    onBeforeDependencyDrag: function(dm, sourceTask) {
        return this.fireEvent('beforedependencydrag', this, sourceTask);
    },

    // private
    onDependencyDragStart : function(dm) {
        this.fireEvent('dependencydragstart', this);
        if (this.tip) {
            this.tip.disable();
        }
    },

    onDependencyDrop : function(dm, fromId, toId, type) {
        this.fireEvent('dependencydrop', this, this.taskStore.getNodeById(fromId), this.taskStore.getById(toId), type);
    },

    // private
    onAfterDependencyDragDrop : function() {
        this.fireEvent('afterdependencydragdrop', this);
        
        // Enable tooltip after drag again
        if (this.tip) {
            this.tip.enable();
        }
    },
    
    // Disconnect the store 'update' listener for the view
    // private
    onBeforeCascade : function(dm, r) {
        this.taskStore.un('update', this.onUpdate, this);
    },

    // Reconnect the store 'update' listener for the view
    // private
    onCascade : function(dm, r) {
        this.taskStore.on('update', this.onUpdate, this);
    },

    onUpdate : function(store, record, operation, changedFieldNames) {
        if (changedFieldNames && changedFieldNames.length === 1 && changedFieldNames[0] === 'expanded'){
            return;
        }
        this.callParent(arguments);
    },

    /**
     * Returns the editor defined for the left task field
     * @return {Gnt.feature.LabelEditor} editor The editor
     */
    getLeftEditor : function() {
        return this.leftLabelField.editor;
    },

    /**
     * Returns the editor defined for the right task field
     * @return {Gnt.feature.LabelEditor} editor The editor
     */
    getRightEditor : function() {
        return this.rightLabelField.editor;
    },

     /**
     * Programmatically activates the editor for the field
     * @param {Gnt.model.Task} record The task record
     */
    editLeftLabel : function(record) {
        var le = this.leftLabelField && this.getLeftEditor();
        if (le) {
            le.edit(record);
        }
    },
    
    /**
     * Programmatically activates the editor for the field
     * @param {Gnt.model.Task} record The task record
     */
    editRightLabel : function(record) {
        var re = this.rightLabelField && this.getRightEditor();
        if (re) {
            re.edit(record);
        }
    },
    
    // symmetric method `getElementFromEventRecord` - always returns the outer-most element for event/task in both scheduler/gantt
    getOuterElementFromEventRecord: function (record) {
        var prev = this.callParent([ record ]);
        
        return prev && prev.up(this.eventWrapSelector) || null;
    },
    
    
    // deprecated
    getDependenciesForTask : function(record) {
        console.warn('`ganttPanel.getDependenciesForTask()` is deprecated, use `task.getAllDependencies()` instead');
        return record.getAllDependencies();
    },

    
    // Hackish way to reduce the DOM footprint, since we only use the table first cell for rendering the task.
    setNewTemplate: function() {
        var me = this,
            columns = me.headerCt.getColumnsForTpl(true);
        
        me.tpl = me.getTableChunker().getTableTpl({
            columns: [columns[0]],
            features: me.features
        });
    }
    
//    code from 4.0.x, need to update it to 4.1 if neeeded
//    ,
//    // BEGIN OF animations support - need to put the "animWrap" object to the different property of the tree node
//    // instead of "record.animWrap" we use "record.animWrapNormal"
//    // also need to fire the "afterexpand / aftercollapse" events to provide the hook point for other plugins
//    getAnimWrap: function(parent) {
//        if (!this.animate) {
//            return null;
//        }
//
//        // We are checking to see which parent is having the animation wrap
//        while (parent) {
//            if (parent.animWrapNormal) {
//                return parent.animWrapNormal;
//            }
//            parent = parent.parentNode;
//        }
//        return null;
//    },
//    
//    
//    onBeforeExpand: function(parent, records, index) {
//        var me = this,
//            animWrap;
//            
//        if (!me.rendered || !me.animate) {
//            return;
//        }
//
//        if (me.getNode(parent)) {
//            animWrap = me.getAnimWrap(parent);
//            if (!animWrap) {
//                animWrap = parent.animWrapNormal = me.createAnimWrap(parent);
//                animWrap.animateEl.setHeight(0);
//            }
//            else if (animWrap.collapsing) {
//                // If we expand this node while it is still expanding then we
//                // have to remove the nodes from the animWrap.
//                animWrap.targetEl.select(me.itemSelector).remove();
//            } 
//            animWrap.expanding = true;
//            animWrap.collapsing = false;
//        }
//    },
//    
//    
//    onBeforeCollapse: function(parent, records, index) {
//        var me = this,
//            animWrap;
//            
//        if (!me.rendered || !me.animate) {
//            return;
//        }
//
//        if (me.getNode(parent)) {
//            animWrap = me.getAnimWrap(parent);
//            if (!animWrap) {
//                animWrap = parent.animWrapNormal = me.createAnimWrap(parent, index);
//            }
//            else if (animWrap.expanding) {
//                // If we collapse this node while it is still expanding then we
//                // have to remove the nodes from the animWrap.
//                animWrap.targetEl.select(this.itemSelector).remove();
//            }
//            animWrap.expanding = false;
//            animWrap.collapsing = true;
//        }
//    },
//    
//    
//    onExpand: function(parent) {
//        var me = this,
//            queue = me.animQueue,
//            id = parent.getId(),
//            animWrap,
//            animateEl, 
//            targetEl,
//            queueItem;        
//        
//        if (me.singleExpand) {
//            me.ensureSingleExpand(parent);
//        }
//        
//        animWrap = me.getAnimWrap(parent);
//
//        if (!animWrap) {
//            return;
//        }
//        
//        animateEl = animWrap.animateEl;
//        targetEl = animWrap.targetEl;
//
//        animateEl.stopAnimation();
//        // @TODO: we are setting it to 1 because quirks mode on IE seems to have issues with 0
//        queue[id] = true;
//        animateEl.slideIn('t', {
//            duration: me.expandDuration,
//            listeners: {
//                scope: me,
//                lastframe: function() {
//                    // Move all the nodes out of the anim wrap to their proper location
//                    animWrap.el.insertSibling(targetEl.query(me.itemSelector), 'before');
//                    animWrap.el.remove();
//                    delete animWrap.record.animWrapNormal;
//                    delete queue[id];
//                    
//                    me.fireEvent('afterexpand', me);
//                }
//            }
//        });
//        
//        animWrap.isAnimating = true;
//    },
//    
//    
//    onCollapse: function(parent) {
//        var me = this,
//            queue = me.animQueue,
//            id = parent.getId(),
//            animWrap = me.getAnimWrap(parent),
//            animateEl, targetEl;
//
//        if (!animWrap) {
//            return;
//        }
//        
//        animateEl = animWrap.animateEl;
//        targetEl = animWrap.targetEl;
//
//        queue[id] = true;
//        
//        // @TODO: we are setting it to 1 because quirks mode on IE seems to have issues with 0
//        animateEl.stopAnimation();
//        animateEl.slideOut('t', {
//            duration: me.collapseDuration,
//            listeners: {
//                scope: me,
//                lastframe: function() {
//                    animWrap.el.remove();
//                    delete animWrap.record.animWrapNormal;
//                    delete queue[id];
//                    
//                    me.fireEvent('aftercollapse', me);
//                }             
//            }
//        });
//        animWrap.isAnimating = true;
//    }   
//    // END OF animations support
    
    
});

/**

@class Gnt.panel.Gantt
@extends Sch.panel.TimelineTreePanel

A gantt panel, which allows you to visualize and manage tasks and their dependencies.

Please refer to <a href="#!/guide/gantt_getting_started">getting started guide</a> for detailed introduction.

{@img gantt/images/gantt-panel.png}

*/
Ext.define("Gnt.panel.Gantt", {
    extend              : "Sch.panel.TimelineTreePanel",
    
    alias               : ['widget.ganttpanel'], 
    alternateClassName  : ['Sch.gantt.GanttPanel'],

    requires            : [
        'Gnt.view.Gantt',
        'Gnt.model.Dependency',
        'Gnt.data.ResourceStore',
        'Gnt.data.AssignmentStore',
        'Gnt.feature.WorkingTime',
        'Gnt.data.Calendar',
        'Gnt.data.TaskStore',
        'Gnt.data.DependencyStore'
    ],
    
    uses                : [
        'Sch.plugin.CurrentTimeLine'
    ],

    
    lockedXType     : 'treepanel',
    normalXType     : 'ganttpanel',
    viewType        : 'ganttview',
    syncRowHeight   : false,
    layout          : 'border',
    lightWeight     : true,

    /**
     * @cfg {String/Object} leftLabelField
     * A configuration used to show/edit the field to the left of the task.
     * It can be either string indicating the field name in the data model or a custom object where you can set the following possible properties:
     * 
     * - `dataIndex` : String - The field name in the data model
     * - `editor` : Ext.form.Field - The field used to edit the value inline
     * - `renderer` : Function - A renderer method used to render the label. The renderer is called with the 'value' and the record as parameters.
     * - `scope` : Object - The scope in which the renderer is called
     */
    leftLabelField              : null,

     /**
     * @cfg {String/Object} rightLabelField
     * A configuration used to show/edit the field to the right of the task.
     * It can be either string indicating the field name in the data model or a custom object where you can set the following possible properties:
     * 
     * - `dataIndex` : String - The field name in the data model
     * - `editor` : Ext.form.Field - The field used to edit the value inline
     * - `renderer` : Function - A renderer method used to render the label. The renderer is called with the 'value' and the record as parameters.
     * - `scope` : Object - The scope in which the renderer is called
     */
    rightLabelField             : null,
    
    /**
     * @cfg {Boolean} highlightWeekends
     * True (default) to highlight weekends and holidays, using the {@link Gnt.feature.WorkingTime} plugin.
     */
    highlightWeekends           : true,
    
    /**
     * @cfg {Boolean} weekendsAreWorkdays
     * Set to `true` to treat *all* days as working, effectively removing the concept of non-working time from gantt. Defaults to `false`. 
     * This option just will be translated to the {@link Gnt.data.Calendar#weekendsAreWorkdays corresponding option} of the calendar
     */
    weekendsAreWorkdays         : false,
    
    /**
     * @cfg {Boolean} skipWeekendsDuringDragDrop
     * True to skip the weekends/holidays during drag&drop operations (moving/resizing) and also during cascading. Default value is `true`.
     * 
     * Note, that holidays will still be excluded from the duration of the tasks. If you need to completely disable holidays skipping you 
     * can do that on the gantt level with the {@link #weekendsAreWorkdays} option, or on task level with the `ManuallyScheduled` field.
     * 
     * 
     * This option just will be translated to the {@link Gnt.data.TaskStore#skipWeekendsDuringDragDrop corresponding option} of the task store
     */
    skipWeekendsDuringDragDrop  : true,
    
    /**
     * @cfg {Boolean} enableTaskDragDrop
     * True to allow drag drop of tasks (defaults to `true`). To customize the behavior of drag and drop, you can use {@link #dragDropConfig} option
     */
    enableTaskDragDrop          : true,
    
    /**
     * @cfg {Boolean} enableDependencyDragDrop
     * True to allow creation of dependencies by using drag and drop between task terminals (defaults to `true`)
     */
    enableDependencyDragDrop    : true,
     
    /**
     * @cfg {Boolean} enableProgressBarResize
     * True to allow resizing of the progress bar indicator inside tasks (defaults to `false`)
     */
    enableProgressBarResize     : false,
    

    /**
     * @cfg {Boolean} toggleParentTasksOnClick
     * True to toggle the collapsed/expanded state when clicking a parent task bar (defaults to `true`)
     */
    toggleParentTasksOnClick    : true,
    
    /**
     * @cfg {Boolean} addRowOnTab
     * True to automatically insert a new row when tabbing out of the last cell of the last row. Defaults to true.
     */
    addRowOnTab : true,
        
    /**
     * @cfg {Boolean} recalculateParents
     * True to update parent start/end dates after a task has been updated (defaults to `true`). This option just will be translated 
     * to the {@link Gnt.data.TaskStore#recalculateParents corresponding option} of the task store
     */
    recalculateParents          : true,
    
    /**
     * @cfg {Boolean} cascadeChanges
     * True to cascade changes to dependent tasks (defaults to `false`). This option just will be translated 
     * to the {@link Gnt.data.TaskStore#cascadeChanges corresponding option} of the task store 
     */
    cascadeChanges              : false,
     
   /**
    * @cfg {Boolean} showTodayLine
    * True to show a line indicating current time. Default value is `false`.
    */
    showTodayLine               : false,
    
    
    /**
    * @cfg {Boolean} enableBaseline
    * True to enable showing a base lines for tasks. Baseline information should be provided as the `BaselineStartDate`, `BaselineEndDate` and `BaselinePercentDone` fields. 
    * Default value is `false`.
    */
    enableBaseline                : false,
    
    /**
    * @cfg {Boolean} baselineVisible
    * True to show the baseline in the initial rendering. You can show and hide the baseline programmatically via {@link #showBaseline} and {@link #hideBaseline}.
    * Default value is `false`.
    */
    baselineVisible : false,
    
    /**
    * @cfg {Boolean} enableAnimations
    * EXPERIMENTAL! True to enable the animations when expanding/collapsing parent tasks. Default value is `false`.
    */
    enableAnimations            : false,    
     
    /**
     * If {@link #highlightWeekends} option is set to true, you can access the created zones plugin through this property.
     * @property {Sch.plugin.Zones} workingTimePlugin
     */
    workingTimePlugin           : null,
    todayLinePlugin             : null,

    /**
     * @cfg {Boolean} allowParentTaskMove
     * @ignore
     * (Not yet supported) True to allow moving parent tasks.
     */
    allowParentTaskMove         : false,

    /**
     * @cfg {Boolean} enableDragCreation
     * @ignore
     * (Not yet supported) True to allow dragging to set start and end dates
     */
    enableDragCreation          : true,

    /**
    * @cfg {Function} eventRenderer 
    * An empty function by default, but provided so that you can override it. This function is called each time a task 
    * is rendered into the scheduler grid. The function should return an object with properties that will be applied to the relevant task template. 
    * By default, the task templates include placeholders for `cls`, `style`. The `cls` property is a CSS class which will be added to the 
    * task bar element. The `style` property is an inline style declaration for the task bar element. 
    * 
    renderer : function (taskRec) {
        return {
            style : 'background-color:white',        // You can use inline styles too.
            cls   : taskRec.get('Priority')          // Read a property from the task record, used as a CSS class to style the event
        };
    }
    * @param {Ext.data.Model} taskRecord The task about to be rendered
    * @param {Ext.data.Store} ds The task store
    * @return {Object} The data which will be applied to the task template, creating the actual HTML
    */
    eventRenderer           : Ext.emptyFn,
    
    /**
    * @cfg {Object} eventRendererScope The scope to use for the `eventRenderer` function 
    */
    eventRendererScope : null,

    /**
     * @cfg {Ext.Template} eventTemplate The template used to renderer leaf tasks in the gantt view. See {@link Ext.Template} for more information, see also {@link Gnt.template.Task} for the definition. 
     */
    eventTemplate           : null,
    
    /**
     * @cfg {Ext.Template} parentEventTemplate The template used to renderer parent tasks in the gantt view. See {@link Ext.Template} for more information, see also {@link Gnt.template.ParentTask} for the definition
     */
    parentEventTemplate     : null,
    
    /**
     * @cfg {Ext.Template} milestoneTemplate The template used to renderer parent tasks in the gantt view. See {@link Ext.Template} for more information, see also {@link Gnt.template.Milestone} for the definition. </p>
     */
    milestoneTemplate       : null,
    
    /**
     * @cfg {Boolean} autoHeight Always hardcoded to `false`, the `true` value is not yet supported (by Ext JS).
     */
    autoHeight              : null,
    
    /**
     * @cfg {Gnt.data.Calendar} calendar a {@link Gnt.data.Calendar calendar} instance for this gantt panel. Can be also provided 
     * as a {@link Gnt.data.TaskStore#calendar configuration option} of the `taskStore`.
     */
    calendar        : null,
    
    /**
     * @cfg {Gnt.data.TaskStore} taskStore The {@link Gnt.data.TaskStore store} holding the tasks to be rendered into the gantt chart (required).
     */
    taskStore       : null,

    /**
     * @cfg {Ext.data.Store} dependencyStore The {@link Ext.data.Store store} holding the dependency information (optional).
     * See also {@link Gnt.model.Dependency}
     */
    dependencyStore : null,
    
    /**
     * @cfg {Ext.data.Store} resourceStore The {@link Ext.data.Store store} holding the resources that can be assigned to the tasks in the task store(optional). 
     * See also {@link Gnt.model.Resource} 
     */
    resourceStore   : null,
    
    /**
     * @cfg {Ext.data.Store} assignmentStore The {@link Ext.data.Store store} holding the assignments information (optional).
     * See also {@link Gnt.model.Assignment}
     */
    assignmentStore : null,
      

    // TODO, find way to have columnLines for locked grid but not for schedule grid
    columnLines     : false,

    /**
     * @method dndValidatorFn
     * An empty function by default, but provided so that you can perform custom validation on 
     * the item being dragged. This function is called during the drag and drop process and also after the drop is made.
     * 
     * @param {Gnt.model.Task} taskRecord The record being dragged
     * @param {Date} date The new start date
     * @param {Int} duration The duration of the item being dragged, in minutes
     * @param {Ext.EventObject} e The event object
     * 
     * @return {Boolean} true if the drop position is valid, else false to prevent a drop
     */
    dndValidatorFn      : Ext.emptyFn,

    /**
     * @cfg {String} resizeHandles A string containig one of the following values
     * 
     * - `none` - to disable the resizing of tasks
     * - `left` - to enable changing of start date only
     * - `right` - to enable changing of end date only
     * - `both` - to enable changing of both start and end dates
     * 
     * Default value is `both`. Resizing is performed with the {@link Gnt.feature.TaskResize} plugin. 
     * You can customize it with the {@link #resizeConfig} and {@link #resizeValidatorFn} options
     */
    resizeHandles       : 'both',
    
    /**
     * @method resizeValidatorFn
     * An empty function by default, but provided so that you can perform custom validation on 
     * an item being resized.
     * 
     * @param {Gnt.model.Task} taskRecord the task being resized
     * @param {Date} startDate the new start date
     * @param {Date} endDate the new end date
     * @param {Ext.EventObject} e The event object
     * 
     * @return {Boolean} true if the resize state is valid, else false to cancel
     */
    resizeValidatorFn   : Ext.emptyFn,
    
    /**
     *  @cfg {Object} resizeConfig Custom config object to pass to the {@link Gnt.feature.TaskResize} feature.
     */
    resizeConfig        : null,

    
    /**
     *  @cfg {Object} dragDropConfig Custom config object to pass to the {@link Gnt.feature.TaskDragDrop} feature.
     */
    dragDropConfig      : null,

    initStores : function() {     
        
        var taskStore = Ext.StoreMgr.lookup(this.taskStore || this.store);
        
        if (!taskStore) {
            Ext.Error.raise("You must specify a taskStore config");
        }
        
        if (!(taskStore instanceof Gnt.data.TaskStore)) {
            Ext.Error.raise("A `taskStore` should be an instance of `Gnt.data.TaskStore` (or of a subclass)");
        }
        
        Ext.apply(this, {
            store       : taskStore,          // For the grid panel API
            taskStore   : taskStore
        });

        var calendar    = this.calendar = taskStore.calendar;
        
        if (this.needToTranslateOption('weekendsAreWorkdays')) {
            calendar.weekendsAreWorkdays   = this.weekendsAreWorkdays;
        }
        
        if (taskStore.dependencyStore) {
            this.dependencyStore = taskStore.dependencyStore;
        } else if (this.dependencyStore) {
            this.dependencyStore = Ext.StoreMgr.lookup(this.dependencyStore);
            taskStore.setDependencyStore(this.dependencyStore);
        } else {
            // Assign an empty store if one hasn't been provided
            this.dependencyStore = Ext.create("Gnt.data.DependencyStore");
            
            taskStore.setDependencyStore(this.dependencyStore);
        }

        // Backwards compatible, remove in 3.0
        if (!(this.dependencyStore instanceof Gnt.data.DependencyStore)) {
            Ext.Error.raise("The Gantt dependency store should be a Gnt.data.DependencyStore, or a subclass thereof.");
        }

        if (taskStore.getResourceStore()) {
            this.resourceStore = taskStore.getResourceStore();
        } else if (this.resourceStore) {
            this.resourceStore = Ext.StoreMgr.lookup(this.resourceStore);
            taskStore.setResourceStore(this.resourceStore);
        } else {
            // Assign an empty store if one hasn't been provided
            this.resourceStore = Ext.create("Gnt.data.ResourceStore");
            
            taskStore.setResourceStore(this.resourceStore);
        }

        if (!(this.resourceStore instanceof Gnt.data.ResourceStore)) {
            Ext.Error.raise("A `ResourceStore` should be an instance of `Gnt.data.ResourceStore` (or of a subclass)");
        }
        
        if (taskStore.getAssignmentStore()) {
            this.assignmentStore = taskStore.getAssignmentStore();
        } else if (this.assignmentStore) {
            this.assignmentStore = Ext.StoreMgr.lookup(this.assignmentStore);
            taskStore.setAssignmentStore(this.assignmentStore);
        } else {
            // Assign an empty store if one hasn't been provided
            this.assignmentStore = Ext.create("Gnt.data.AssignmentStore");
            
            taskStore.setAssignmentStore(this.assignmentStore);
        }                

        if (!(this.assignmentStore instanceof Gnt.data.AssignmentStore)) {
            Ext.Error.raise("An `assignmentStore` should be an instance of `Gnt.data.AssignmentStore` (or of a subclass)");
        }

        if (this.lockable) {
            if (this.assignmentStore) {
                this.assignmentStore.on({
                    datachanged : function() { this.getView().refreshKeepingScroll(); }, //TODO Wasteful 
                    scope : this
                });
            }

            if (this.resourceStore) {
                this.resourceStore.on({
                    datachanged : function() { this.getView().refreshKeepingScroll(); }, //TODO Wasteful 
                    scope : this
                });
            }
        }
    },

    initComponent : function() {
        // @BackwardsCompat, remove in Gantt 3.0
        if (Ext.isBoolean(this.showBaseline)) {
            this.enableBaseline = this.baselineVisible = this.showBaseline;
            this.showBaseline = Gnt.panel.Gantt.prototype.showBaseline;
        }
        
        this.autoHeight     = false;
        
        this.initStores();
      
        if (this.needToTranslateOption('cascadeChanges')) {
            this.setCascadeChanges(this.cascadeChanges);
        }
        
        if (this.needToTranslateOption('recalculateParents')) {
            this.setRecalculateParents(this.recalculateParents);
        }
        
        if (this.needToTranslateOption('skipWeekendsDuringDragDrop')) {
            this.setSkipWeekendsDuringDragDrop(this.skipWeekendsDuringDragDrop);
        }

        if (this.lockable) {    
            this.lockedGridConfig = this.lockedGridConfig || {};
            
            Ext.apply(this.lockedGridConfig, {
                columnLines: true,
                rowLines : true
            });

            this.configureFunctionality();
        }
        
        this.callParent(arguments);

        if (this.lockable) {
            this.bodyCls = (this.bodyCls || '') + " sch-ganttpanel-container-body";

            var ganttView = this.getSchedulingView();
            ganttView.store.calendar = this.calendar;

            this.relayEvents(ganttView, [
                /**
                * @event taskclick
                * Fires when a task is clicked
                * 
                * @param {Gnt.panel.Gantt} gantt The gantt panel instance
                * @param {Gnt.model.Task} taskRecord The task record 
                * @param {Ext.EventObject} e The event object
                */
                'taskclick', 
                
                /**
                * @event taskdblclick
                * Fires when a task is double clicked
                * 
                * @param {Gnt.panel.Gantt} gantt The gantt panel instance
                * @param {Gnt.model.Task} taskRecord The task record 
                * @param {Ext.EventObject} e The event object
                */
                'taskdblclick', 
                
                /**
                * @event taskcontextmenu
                * Fires when contextmenu is activated on a task
                * 
                * @param {Gnt.panel.Gantt} gantt The gantt panel instance
                * @param {Gnt.model.Task} taskRecord The task record 
                * @param {Ext.EventObject} e The event object
                */
                'taskcontextmenu', 
    
                // Resizing events start --------------------------
                /**
                * @event beforetaskresize
                * Fires before a resize starts, return false to stop the execution
                * 
                * @param {Gnt.panel.Gantt} gantt The gantt panel instance
                * @param {Gnt.model.Task} taskRecord The task about to be resized
                * @param {Ext.EventObject} e The event object
                */
                'beforetaskresize', 
                
                /**
                * @event taskresizestart
                * Fires when resize starts
                * 
                * @param {Gnt.panel.Gantt} gantt The gantt panel instance
                * @param {Gnt.model.Task} taskRecord The task about to be resized
                */
                'taskresizestart', 
                
                /**
                * @event partialtaskresize
                * Fires during a resize operation and provides information about the current start and end of the resized event
                * @param {Gnt.panel.Gantt} gantt The gantt panel instance
                * 
                * @param {Gnt.model.Task} taskRecord The task being resized
                * @param {Date} startDate The start date of the task
                * @param {Date} endDate The end date of the task
                * @param {Ext.Element} The element being resized
                */
                'partialtaskresize', 
                
                /**
                * @event aftertaskresize
                * Fires after a succesful resize operation
                * @param {Gnt.panel.Gantt} gantt The gantt panel instance
                * @param {Gnt.model.Task} taskRecord The task that has been resized
                */
                'aftertaskresize',
                // Resizing events end --------------------------
                
                // Task progress bar resizing events start --------------------------
                /**
                * @event beforeprogressbarresize
                * Fires before a progress bar resize starts, return false to stop the execution
                * @param {Gnt.panel.Gantt} gantt The gantt panel instance
                * @param {Gnt.model.Task} taskRecord The record about to be have its progress bar resized
                */
                'beforeprogressbarresize', 
                
                /**
                * @event progressbarresizestart
                * Fires when a progress bar resize starts
                * @param {Gnt.panel.Gantt} gantt The gantt panel instance
                * @param {Gnt.model.Task} taskRecord The record about to be have its progress bar resized
                */
                'progressbarresizestart', 
               
                /**
                * @event afterprogressbarresize
                * Fires after a succesful progress bar resize operation
                * @param {Gnt.panel.Gantt} gantt The gantt panel instance
                * @param {Gnt.model.Task} taskRecord record The updated record
                */
                'afterprogressbarresize',
                // Task progressbar resizing events end --------------------------
                
                // Dnd events start --------------------------
                /**
                * @event beforetaskdrag
                * Fires before a task drag drop is initiated, return false to cancel it
                * @param {Gnt.panel.Gantt} gantt The gantt panel instance
                * @param {Gnt.model.Task} taskRecord The task record that's about to be dragged
                * @param {Ext.EventObject} e The event object
                */ 
                'beforetaskdrag', 
                
                /**
                * @event taskdragstart
                * Fires when a dnd operation starts
                * @param {Gnt.panel.Gantt} gantt The gantt panel instance
                * @param {Gnt.model.Task} taskRecord The record being dragged
                */
                'taskdragstart',
                
                /**
                * @event taskdrop
                * Fires after a succesful drag and drop operation
                * @param {Gnt.panel.Gantt} gantt The gantt panel instance
                * @param {Gnt.model.Task} taskRecord The dropped record
                */
                'taskdrop',
                
                /**
                * @event aftertaskdrop
                * Fires after a drag and drop operation, regardless if the drop valid or invalid
                * @param {Gnt.panel.Gantt} gantt The gantt panel instance
                */
                'aftertaskdrop',
                // Dnd events end --------------------------
                
                 /**
                 * @event labeledit_beforestartedit
                 * Fires before editing is started for a field
                 * @param {Gnt.view.Gantt} gantt The gantt view instance
                 * @param {Gnt.model.Task} taskRecord The task record 
                 * @param {Mixed} value The field value being set
                 * @param {Gnt.feature.LabelEditor} editor The editor instance
                 */
                'labeledit_beforestartedit', 
    
                /**
                 * @event labeledit_beforecomplete
                 * Fires after a change has been made to a label field, but before the change is reflected in the underlying field.
                 * @param {Gnt.view.Gantt} gantt The gantt view instance
                 * @param {Mixed} value The current field value
                 * @param {Mixed} startValue The original field value
                 * @param {Gnt.model.Task} taskRecord The affected record 
                 * @param {Gnt.feature.LabelEditor} editor The editor instance
                 */
                'labeledit_beforecomplete', 
                
                /**
                 * @event labeledit_complete
                 * Fires after editing is complete and any changed value has been written to the underlying field.
                 * @param {Gnt.view.Gantt} gantt The gantt view instance
                 * @param {Mixed} value The current field value
                 * @param {Mixed} startValue The original field value
                 * @param {Gnt.model.Task} taskRecord The affected record 
                 * @param {Gnt.feature.LabelEditor} editor The editor instance
                 */
                'labeledit_complete',
    
                
                
                
                // Dependency drag drop end --------------------------
                /**
                 * @event beforedependencydrag
                 * Fires before a dependency drag operation starts (from a "task terminal").
                 * @param {Gnt.panel.Gantt} gantt The gantt panel instance
                 * @param {Gnt.model.Task} taskRecord The source task record 
                 */
                'beforedependencydrag', 
    
                 /**
                 * @event dependencydragstart
                 * Fires when a dependency drag operation starts 
                 * @param {Gnt.panel.Gantt} gantt The gantt panel instance
                 */
                'dependencydragstart', 
    
                /**
                 * @event dependencydrop
                 * Fires when a dependency drag drop operation has completed successfully and a new dependency has been created.
                 * @param {Gnt.panel.Gantt} gantt The gantt panel instance
                 * @param {Gnt.model.Task} fromRecord The source task record 
                 * @param {Gnt.model.Task} toRecord The destination task record 
                 * @param {Int} type The dependency type
                 */
                'dependencydrop', 
    
                /**
                 * @event afterdependencydragdrop
                 * Always fires after a dependency drag-drop operation
                 * @param {Gnt.panel.Gantt} gantt The gantt panel instance
                 */
                'afterdependencydragdrop',
                
                /**
                * @event dependencydblclick
                * Fires after double clicking on a dependency line/arrow
                * @param {Gnt.view.Dependency} g The gantt panel instance
                * @param {Gnt.model.Dependency} record The dependency record 
                * @param {Ext.EvenObject} event The event object
                * @param {HTMLElement} target The target of this event
                */
                'dependencydblclick'
                
                // Dependency drag drop events --------------------------
            ]);

            this.fixSelectionModel();

            if (this.lockable && this.addRowOnTab) {
                var lockedGrid = this.lockedGrid,
                    sm = this.getSelectionModel();

                sm.onEditorTab = Ext.Function.createInterceptor(sm.onEditorTab, function(editingPlugin, e) {
                    var view = lockedGrid.view,
                        record = editingPlugin.getActiveRecord(),
                        header = editingPlugin.getActiveColumn(),
                        position = view.getPosition(record, header);
                    
                    // Check if this is the last column of the last row
                    if (position.column === lockedGrid.headerCt.getColumnCount()-1 && 
                        position.row === lockedGrid.view.store.getCount()-1) {
                        record.addTaskBelow({ leaf : true });
                    }
                });
            }
        }
    },
    
 
    // this function checks whether the configuration option should be translated to task store or calendar
    // idea is that some configuration option (`cascadeChanges` for example) actually belongs to TaskStore
    // so they are not persisted in the gantt panel (panel only provides accessors which reads/write from/to TaskStore)
    // however the values for those options could also be specified in the prototype of the Gnt.panel.Gantt subclass
    // see #172
    needToTranslateOption : function (optionName) {
        return this.hasOwnProperty(optionName) || this.self.prototype.hasOwnProperty(optionName) && this.self != Gnt.panel.Gantt;
    }, 
    
    
    fixSelectionModel : function () {
        // when having a locked grid with 2 views, the 2nd view is updated by the selection model prior its "onAdd" action
        // thus, it selects a row below the selected row
        // see #123
        var selModel            = this.getSelectionModel();
        var lockedView          = this.lockedGrid.getView();
        var normalView          = this.normalGrid.getView();
        
        lockedView.__lockedType   = 'locked';
        normalView.__lockedType   = 'normal';
        
        var prevLockedGridOnAdd = lockedView.onAdd;
        
        lockedView.onAdd = function () {
            selModel.__preventUpdateOf = 'normal';
            
            prevLockedGridOnAdd.apply(this, arguments);
            
            delete selModel.__preventUpdateOf;
        };
        
        
        var prevNormalGridOnAdd = normalView.onAdd;
        
        normalView.onAdd = function () {
            selModel.__preventUpdateOf = 'locked';
            
            prevNormalGridOnAdd.apply(this, arguments);
            
            delete selModel.__preventUpdateOf;
        };
        
        var oldStore        = lockedView.store;
        
        lockedView.bindStore(null);
        normalView.bindStore(null);
        
        // re-binding the stores to make use of our overrides for "onAdd" 
        // (which is a listener for "add" event of store)
        lockedView.bindStore(oldStore);
        normalView.bindStore(oldStore);
        
        Ext.apply(selModel, {
            // Allow the GridView to update the UI by
            // adding/removing a CSS class from the row.
            onSelectChange: function(record, isSelected, suppressEvent, commitFn) {
                var me      = this,
                    views   = me.views,
                    viewsLn = views.length,
                    store   = me.store,
                    rowIdx  = store.indexOf(record),
                    eventName = isSelected ? 'select' : 'deselect',
                    i = 0;
        
                if ((suppressEvent || me.fireEvent('before' + eventName, me, record, rowIdx)) !== false &&
                        commitFn() !== false) {
        
                    for (; i < viewsLn; i++) {
                        if (!this.__preventUpdateOf || views[i].__lockedType != this.__preventUpdateOf) {
                            if (isSelected) {
                                views[i].onRowSelect(rowIdx, suppressEvent);
                            } else {
                                views[i].onRowDeselect(rowIdx, suppressEvent);
                            }
                        }
                    }
        
                    if (!suppressEvent) {
                        me.fireEvent(eventName, me, record, rowIdx);
                    }
                }
            }
        });            
        
    },
    
    
    /**
     * Wrapper function returning the dependency view instance
     * @return {Gnt.view.Dependency} dependencyView The dependency view instance
     */
    getDependencyView : function() {
        return this.getSchedulingView().getDependencyView();
    },
    
    /**
     * Toggle weekend highlighting
     * @param {Boolean} disabled 
     */
    disableWeekendHighlighting : function(disabled) {
        this.workingTimePlugin.setDisabled(disabled);
    },
    
    /**
     * <p>Returns the task record for a DOM node</p>
     * @param {Mixed} el The DOM node or Ext Element to lookup
     * @return {Gnt.model.Task} The task record
     */
    resolveTaskRecord: function (el) {
        return this.getSchedulingView().resolveTaskRecord(el);
    },

    /**
     * Tries to fit the time columns to the available view width
     */
    fitTimeColumns : function() {
        this.getSchedulingView().fitColumns();
    },
  
    /**
     * Returns the resource store associated with the Gantt panel instance
     * @return {Gnt.data.ResourceStore}
     */
    getResourceStore : function() {
        return this.getTaskStore().getResourceStore();
    },

    /**
     * Returns the assignment store associated with the Gantt panel instance
     * @return {Gnt.data.AssignmentStore}
     */
    getAssignmentStore : function() {
        return this.getTaskStore().getAssignmentStore();
    },

    /**
     * Returns the associated task store
     * @return {Gnt.data.TaskStore}
     */
    getTaskStore : function() {
        return this.taskStore;
    },

    
    /**
     * Returns the associated dependency store
     * @return {Gnt.data.DependencyStore}
     */
    getDependencyStore : function() {
        return this.dependencyStore;
    },
    
    
    
    // private
    onDragDropStart : function() {
        if (this.tip) {
            this.tip.hide();
            this.tip.disable();
        }
    },
    
    // private
    onDragDropEnd : function() {
        if (this.tip) {
            this.tip.enable();
        }
    },
    
    
    // private 
    configureFunctionality : function() {
        // Normalize to array
        var plugins     = this.plugins    = [].concat(this.plugins || []);
        
        if (this.highlightWeekends) {
            
            this.workingTimePlugin = Ext.create("Gnt.feature.WorkingTime", {
                calendar        : this.calendar
            });
            
            plugins.push(this.workingTimePlugin);
        }
        
        if (this.showTodayLine) {
            this.todayLinePlugin = new Sch.plugin.CurrentTimeLine();
            plugins.push(this.todayLinePlugin);
        }
    },
    
    beforeRender : function() { 
        if (this.lockable) {
            var cls = ' sch-ganttpanel sch-horizontal ';

            if (this.highlightWeekends) {
              cls += ' sch-ganttpanel-highlightweekends ';
            }

            this.addCls(cls);

            if (this.baselineVisible) {
                this.showBaseline();
            }
        }
        this.callParent(arguments);
    },

    // private
    afterRender : function() { 
        this.callParent(arguments);

        if (this.lockable) {
            this.applyPatches();
        }
    },

    /**
     * Shows the baseline tasks
     */
    showBaseline : function() {
        this.addCls('sch-ganttpanel-showbaseline');
    },

    /**
     * Hides the baseline tasks
     */
    hideBaseline : function() {
        this.removeCls('sch-ganttpanel-showbaseline');
    },

    /**
     * Toggles the display of the baseline
     */
    toggleBaseline : function() {
        this.toggleCls('sch-ganttpanel-showbaseline');
    },
    
    /**
     * Changes the timeframe of the gantt to fit all the tasks in it
     */
    zoomToFit : function() {
        var span = this.taskStore.getTotalTimeSpan();
                            
        if (span.start && span.end && span.start < span.end){
            this.setTimeSpan(span.start, span.end);
            this.fitTimeColumns();
        }
    },
    
    
    /**
     * "Get" accessor for the `cascadeChanges` option
     */
    getCascadeChanges : function () {
        return this.taskStore.cascadeChanges;
    },
    
    
    /**
     * "Set" accessor for the `cascadeChanges` option
     */
    setCascadeChanges : function (value) {
        this.taskStore.cascadeChanges = value;
    },
    
    
    /**
     * "Get" accessor for the `recalculateParents` option
     */
    getRecalculateParents : function () {
        return this.taskStore.recalculateParents;
    },
    
    
    /**
     * "Set" accessor for the `recalculateParents` option
     */
    setRecalculateParents : function (value) {
        this.taskStore.recalculateParents = value;
    },
    
    
    /**
     * "Set" accessor for the `skipWeekendsDuringDragDrop` option
     */
    setSkipWeekendsDuringDragDrop : function (value) {
        this.taskStore.skipWeekendsDuringDragDrop = this.skipWeekendsDuringDragDrop = value;
    },
    
    
    /**
     * "Get" accessor for the `skipWeekendsDuringDragDrop` option
     */
    getSkipWeekendsDuringDragDrop : function () {
        return this.taskStore.skipWeekendsDuringDragDrop;
    },

    // No way to tell a node 'remove' from a node move-within-tree. Dependency redrawing is not performed without this patch.
    // 1. Render a few tasks + dependencies
    // 2. Reorder a task that has dependencies
    // 3. On drop, they're not repainted
    applyPatches : function() {
        if (Ext.tree.plugin && Ext.tree.plugin.TreeViewDragDrop) {
            var dragDropPlug;
            
            Ext.each(this.lockedGrid.getView().plugins, function(p) {
                if (p instanceof Ext.tree.plugin.TreeViewDragDrop) {
                    dragDropPlug = p;
                    return false;
                }
            });

            if (!dragDropPlug || !dragDropPlug.dropZone) return;

            // URGH
            dragDropPlug.dropZone.handleNodeDrop = function (data, targetNode, position) {
                var me = this,
                    view = me.view,
                    parentNode = targetNode.parentNode,
                    store = view.getStore(),
                    recordDomNodes = [],
                    records, i, len,
                    insertionMethod, argList,
                    needTargetExpand,
                    transferData,
                    processDrop;

                if (data.copy) {
                    records = data.records;
                    data.records = [];
                    for (i = 0, len = records.length; i < len; i++) {
                        data.records.push(Ext.apply({}, records[i].data));
                    }
                }
                me.cancelExpand();
                if (position == 'before') {
                    insertionMethod = parentNode.insertBefore;
                    argList = [null, targetNode];
                    targetNode = parentNode;
                }
                else if (position == 'after') {
                    if (targetNode.nextSibling) {
                        insertionMethod = parentNode.insertBefore;
                        argList = [null, targetNode.nextSibling];
                    }
                    else {
                        insertionMethod = parentNode.appendChild;
                        argList = [null];
                    }
                    targetNode = parentNode;
                }
                else {
                    if (!targetNode.isExpanded()) {
                        needTargetExpand = true;
                    }
                    insertionMethod = targetNode.appendChild;
                    argList = [null];
                }
                transferData = function () {
                    var node;
                    for (i = 0, len = data.records.length; i < len; i++) {
                        argList[0] = data.records[i];
                        argList[0].isMove = true;
                        node = insertionMethod.apply(targetNode, argList);
                        delete argList[0].isMove;
                        if (Ext.enableFx && me.dropHighlight) {
                            recordDomNodes.push(view.getNode(node));
                        }
                    }
                    if (Ext.enableFx && me.dropHighlight) {
                        Ext.Array.forEach(recordDomNodes, function (n) {
                            if (n) {
                                Ext.fly(n.firstChild ? n.firstChild : n).highlight(me.dropHighlightColor);
                            }
                        });
                    }
                };
                if (needTargetExpand) {
                    targetNode.expand(false, transferData);
                }
                else {
                    transferData();
                }
            };
        }
    }
});
/**

@class Gnt.column.EndDate
@extends Ext.grid.column.Date

A Column representing a `EndDate` field of the task. The column is editable, however to enable the editing you will need to add a
`Sch.plugin.TreeCellEditing` plugin to your gantt panel. The overall setup will look like this:

    var gantt = Ext.create('Gnt.panel.Gantt', {
        height      : 600,
        width       : 1000,
        
        // Setup your static columns
        columns         : [
            ...
            {
                xtype       : 'enddatecolumn',
                width       : 80
            }
            ...
        ],
        
        plugins             : [
            Ext.create('Sch.plugin.TreeCellEditing', {
                clicksToEdit: 1
            })
        ],
        ...
    })
    
Note that this column will provide only a day-level editor (using standard ExtJS "datefield"). If you need a more precise editing (ie also specify 
the ending hour/minute) you will need to provide your own field.

Note that the end date of task in gantt is not inclusive, however, this column will compensate the value when rendering or editing.
So for example, if you have a 1 day task which starts at 2011/07/20 and ends at 2011/07/21 (remember end date is not inclusive!), 
this column will show the `2011/07/20` when rendering. It will also increase the date by 1 day after being edited. 

*/
Ext.define("Gnt.column.EndDate", {
    extend      : "Ext.grid.column.Date",
    alias       : "widget.enddatecolumn",
    requires : [
        'Ext.grid.CellEditor'
    ],
    /**
     * @cfg {string} text The text to show in the column header, defaults to `Finish`
     */
    text        : 'Finish',

    /**
     * @cfg {Number} width A width of the column, default value is 100
     */
    width       : 100,
    
    /**
     * @cfg {String} align An align of the text in the column, default value is 'left'
     */
    align       : 'left',
    
    dataIndex   :  'EndDate',
    
    task        : null,
    
    
    constructor : function (config) {
        config = config || {};
        
        // this will be a real field 
        var field       = config.field || config.editor;
        
        delete config.field;
        delete config.editor;
        
        // `field` will be an editor actually
        this.field     = Ext.create("Ext.grid.CellEditor", {
            ignoreNoChange  : true,
            
            field       : field || {
                xtype   : 'datefield',
                format  : config.format || this.format || Ext.Date.defaultFormat
            },
            
            listeners   : {
                beforecomplete  : this.onBeforeEditComplete,
                scope           : this
            }
        });
        
        this.callParent([ config ]);
        
        this.scope      = this;
        this.renderer   = config.renderer || this.rendererFunc;
    },
    
    
    rendererFunc    : function (value, meta, task) {
        if (!value) {
            return;
        }
        
        if (!task.isEditable(this.dataIndex)) {
            meta.tdCls      = (meta.tdCls || '') + ' sch-column-readonly';
        }
        
        if (task.getEndDate() > task.getStartDate() && value - Ext.Date.clearTime(value, true) === 0) {
            value = Sch.util.Date.add(value, Sch.util.Date.MILLI, -1);
        }
        
        return Ext.util.Format.date(value, this.format);
    },
    

    afterRender: function() {
        this.callParent(arguments);
        
        this.tree = this.ownerCt.up('treepanel');
        
        this.tree.on({
            edit        : this.onTreeEdit,
            beforeedit  : this.onBeforeTreeEdit,
            
            scope       : this
        });
    },
    
    
    onBeforeTreeEdit : function (context) {
        
        if (context.column == this) {
            // editor has no access to context, so saving the task being edited to property (not clean) to allow validation
            var task = this.task = context.record;
            
            if (!task.isEditable(this.dataIndex)) {
                return false;
            }

            if (task.getEndDate() > task.getStartDate()) {
                var value       = context.value;
                
                // if the end date comes right on the midnight user can see not expected value 
                if (value - Ext.Date.clearTime(value, true) === 0) {
                    // so, adjust the value before the edit (required a small fix in Sch.plugin.TreeCellEditing)
                    // so the user will originally see the expected value
                    value = Sch.util.Date.add(value, Sch.util.Date.MILLI, -1);
                }
                
                // this.field is actually an editor
                this.field.startValue       = context.value = Ext.Date.clearTime(value);
            }
        }
    },
    
    
    onBeforeEditComplete : function (editor, value, startValue) {
        if (this.task && value < this.task.getStartDate()) {
            return false;
        }
    },
    
    
    // will return the earliest availability timestamp for the date
    adjustEndDate : function (value, task) {
        return task.getCalendar().getCalendarDay(value).getAvailabilityEndFor(value);
    },
    
    
    onTreeEdit : function (cellEditor, context) {
        
        if (context.column === this && context.value) {
            var task        = context.record;
            var value       = context.value;
            
            if (value - context.originalValue !== 0) {
                context.record.setEndDate(this.adjustEndDate(value, task) || value, false);
            }
        }
    }
});
/**
@class Gnt.column.PercentDone
@extends Ext.grid.Column.Number

A Column representing a `PercentDone` field of the task. The column is editable, however to enable the editing you will need to add a 
`Sch.plugin.TreeCellEditing` plugin to your gantt panel. The overall setup will look like this:

    var gantt = Ext.create('Gnt.panel.Gantt', {
        height      : 600,
        width       : 1000,
        
        // Setup your static columns
        columns         : [
            ...
            {
                xtype       : 'percentdonecolumn',
                width       : 80
            }
            ...
        ],
        
        plugins             : [
            Ext.create('Sch.plugin.TreeCellEditing', {
                clicksToEdit: 1
            })
        ],
        ...
    })


*/
Ext.define("Gnt.column.PercentDone", {
    extend  : "Ext.grid.column.Number",
    alias   : "widget.percentdonecolumn",
    
    text      : '% Done',
    dataIndex   : 'PercentDone',
    
    width       : 50,
    format      : '0',
    align       : 'center',
    
    field       : {
        xtype       : 'numberfield',
        minValue    : 0,
        maxValue    : 100
    }
});
/**

@class Gnt.column.StartDate
@extends Ext.grid.column.Date

A Column representing a `StartDate` field of a task. The column is editable, however to enable the editing you will need to add a
`Sch.plugin.TreeCellEditing` plugin to your gantt panel. The overall setup will look like this:

    var gantt = Ext.create('Gnt.panel.Gantt', {
        height      : 600,
        width       : 1000,
        
        // Setup your static columns
        columns         : [
            ...
            {
                xtype       : 'startdatecolumn',
                width       : 80
            }
            ...
        ],
        
        plugins             : [
            Ext.create('Sch.plugin.TreeCellEditing', {
                clicksToEdit: 1
            })
        ],
        ...
    })
    
Note, that this column will provide only a day-level editor (using standard ExtJS "datefield"). If you need a more precise editing (ie also specify 
the start hour/minute) you will need to provide your own field:

    // Setup your static columns
    columns         : [
        ...
        {
            xtype       : 'startdatecolumn',
            width       : 80,
            
            field       : {
                xtype       : 'precisedate'
            }
        }
        ...
    ]

*/
Ext.define("Gnt.column.StartDate", {
    extend      : "Ext.grid.column.Date",
    alias       : "widget.startdatecolumn",
    
    
    /**
     * @cfg {string} text The text to show in the column header, defaults to `Start`
     */
    text        : 'Start',

    dataIndex   : 'StartDate',
    
    /**
     * @cfg {Number} width A width of the column, default value is 100
     */
    width       : 100,
    
    /**
     * @cfg {String} align An align of the text in the column, default value is 'left'
     */
    align       : 'left',
    
    
    constructor : function (config) {
        config = config || {};
        
        // this will be a real field 
        var field       = config.field || config.editor;
        
        config.field    = field || {
            xtype   : 'datefield',
            format  : config.format || this.format || Ext.Date.defaultFormat
        };
        
        this.callParent([ config ]);
    },
    
    
    afterRender: function() {
        this.callParent(arguments);
        
        this.tree = this.ownerCt.up('treepanel');
        
        this.tree.on({
            edit        : this.onTreeEdit,
            beforeedit  : this.onBeforeTreeEdit,
            
            scope       : this
        });
    },
    
    
    onBeforeTreeEdit : function (context) {
        
        if (context.column == this) {
            // editor has no access to context, so saving the task being edited to property (not clean) to allow validation
            var task = this.task = context.record;
            
            if (!task.isEditable(this.dataIndex)) {
                return false;
            }

            // this.field is actually an editor
            // we'll be comparing the value from the picker with the initial value, so 
            // clear the time of the `startDate`, because datepicker operates only on days, w/o hours
            this.field.startValue       = context.value = (context.value ? Ext.Date.clearTime(context.value) : null);
        }
    },
    
    
    
    // will return the earliest availability timestamp for the date
    adjustStartDate : function (value, task) {
        return task.getCalendar().getCalendarDay(value).getAvailabilityStartFor(value);
    },
    
    onTreeEdit : function (cellEditor, context) {
        var task            = context.record;        
        var value           = context.value;
        
        if (context.column == this && value && value - context.originalValue !== 0) {
            // the standard ExtJS date picker will only allow to choose the date, not time
            // we set the time of the selected date to the earliest availability hour for that date
            // in the case the date has no availbility intervals we use the date itself
            task.setStartDate(this.adjustStartDate(value, task) || value, true);
        }
    }
});
/**

@class Gnt.column.WBS
@extends Ext.grid.column.Date

A "calculated" Column which displays the Work Breakdown Structure for a task (the position of a task in the project tree structure). 
*/
Ext.define("Gnt.column.WBS", {
    extend      : "Ext.grid.column.Column",
    alias       : "widget.wbscolumn",
    
    /**
     * @cfg {String} text The text to show in the column header, defaults to `#`
     */
    text      : '#',

    /**
     * @cfg {Number} width A width of the column, default value is 100
     */
    width       : 40,
    
    /**
     * @cfg {String} align An align of the text in the column, default value is 'left'
     */
    align       : 'left',
    
    dataIndex   :  'index',
    
    
    renderer    : function (value, meta, task, row, col, treeStore) {
        var root = treeStore.getRootNode(),
            indexes = [];
        while (task !== root) {
            indexes.push(task.data.index + 1);
            task = task.parentNode;
        }
        return indexes.reverse().join('.');
    }
});
/**

@class Gnt.column.SchedulingMode
@extends Ext.grid.column.Column

A Column representing a `SchedulingMode` field of a task. The column is editable, however to enable the editing you will need to add a
`Sch.plugin.TreeCellEditing` plugin to your gantt panel. The overall setup will look like this:

    var gantt = Ext.create('Gnt.panel.Gantt', {
        height      : 600,
        width       : 1000,
        
        // Setup your static columns
        columns         : [
            ...
            {
                xtype       : 'schedulingmodecolumn',
                width       : 80
            }
            ...
        ],
        
        plugins             : [
            Ext.create('Sch.plugin.TreeCellEditing', {
                clicksToEdit: 1
            })
        ],
        ...
    })
    
If you use your own field names

*/
Ext.define("Gnt.column.SchedulingMode", {
    extend      : "Ext.grid.column.Column",
    
    alias       : "widget.schedulingmodecolumn",
    
    
    /**
     * @cfg {string} text The text to show in the column header, defaults to `Mode`
     */
    text        : 'Mode',

    dataIndex   : 'SchedulingMode',
    
    /**
     * @cfg {Number} width A width of the column, default value is 100
     */
    width       : 100,
    
    /**
     * @cfg {String} align An align of the text in the column, default value is 'left'
     */
    align       : 'left',
    
    /**
     * @cfg {Array} data A 2-dimensional array used for editing in combobox. The first item of inner arrays will be treated as "value" and 2nd - as "display"   
     */
    data        : [
        [ 'FixedDuration', 'Fixed duration' ],
        [ 'EffortDriven', 'Effort driven' ],
        [ 'DynamicAssignment', 'Dynamic assignment' ],
        [ 'Manual', 'Manual' ],
        [ 'Normal', 'Normal' ]
    ],
    
    modeNames   : null,
    
    /**
     * @cfg {String} pickerAlign The align for combo-box's picker. 
     */
    pickerAlign         : 'tl-bl?',
    
    /**
     * @cfg {Boolean} matchFieldWidth Whether the picker dropdown's width should be explicitly set to match the width of the field. Defaults to true.
     */
    matchFieldWidth     : true,
    
    
    constructor : function (config) {
        config = config || {};
        
        var field       = config.field || config.editor;
        
        config.field    = field || {
            xtype               : 'combo',
            
            editable            : false,
            
            store               : this.data,
            pickerAlign         : this.pickerAlign,
            matchFieldWidth     : this.matchFieldWidth
        };
        
        var modeNames   = this.modeNames = {};
        
        Ext.Array.each(this.data, function (item) {
            modeNames[ item[ 0 ] ] = item[ 1 ];
        });
        
        this.scope      = this;
        
        this.callParent([ config ]);
    },
    
    
    renderer : function (value) {
        return this.modeNames[ value ];
    },
    

    afterRender: function() {
        this.callParent(arguments);
        
        this.tree = this.ownerCt.up('treepanel');
        
        this.tree.on('edit', this.onTreeEdit, this);
    },

    
    onTreeEdit : function (cellEditor, context) {
        if (context.column == this) {
            context.record.setSchedulingMode(context.value);
        }
    }
});
/**

@class Gnt.column.ResourceAssignment
@extends Ext.grid.column.Column

{@img gantt/images/resource-assignment.png}

A Column representing the resource assignments of a task. To make the column editable, pass a configured instance of a {@link Gnt.widget.AssignmentCellEditor}
to it and add the {@link Sch.plugin.TreeCellEditing} plugin to your gantt panel:

    var assignmentEditor = Ext.create('Gnt.widget.AssignmentCellEditor', {
        assignmentStore     : assignmentStore,
        resourceStore       : resourceStore
    });

    var gantt = Ext.create('Gnt.panel.Gantt', {
        height      : 600,
        width       : 1000,
        
        // Setup your static columns
        columns         : [
            ...
            {
                xtype       : 'resourceassignmentcolumn',
                
                editor      : assignmentEditor,
                width       : 80
            }
            ...
        ],
        
        plugins             : [
            Ext.create('Sch.plugin.TreeCellEditing', {
                clicksToEdit: 1
            })
        ],
        ...
    })

*/
Ext.define("Gnt.column.ResourceAssignment", {
    extend      : "Ext.grid.column.Column",
    alias       : "widget.resourceassignmentcolumn",
    
    text        : 'Assigned Resources',
    
    dataIndex   : 'Id',     // The task id
    tdCls       : 'sch-assignment-cell',
    
    /**
     * @cfg {Boolean} showUnits Set to `true` to show the assignment units (in percent). Default value is `true`.
     */
    showUnits   : true,
    
    assignmentStore     : null,
    

    
    initComponent : function() {
        this.formatString = '{0}' + (this.showUnits ? ' [{1}%]' : '');
        this.callParent(arguments);
    },

    afterRender : function() {
        this.scope = this;
        this.callParent(arguments);
        this.assignmentStore = this.getOwnerHeaderCt().up('ganttpanel').assignmentStore;
    },

    renderer : function(value, meta, record, rowIndex, colIndex, store, view) {
        var names               = [],
            assignmentStore     = this.assignmentStore,
            assignment;

        if (assignmentStore.resourceStore.getCount() > 0) {
            for (var i = 0, l = assignmentStore.getCount(); i < l; i++) {
                assignment  = assignmentStore.getAt(i);
                
                if (assignment.getTaskId() === value) {
                    names.push(Ext.String.format(this.formatString, assignment.getResourceName(), assignment.getUnits()));
                }
            }
            return names.join(', ');
        }
    }
});
/*
 * @class Gnt.column.ResourceName
 * @extends Ext.grid.Column
 * @private
 * Private class used inside Gnt.widget.AssignmentGrid.
 */
Ext.define("Gnt.column.ResourceName", {
    extend      : "Ext.grid.column.Column",
    alias       : "widget.resourcenamecolumn",
    
    text      : 'Resource Name',
    dataIndex   : 'ResourceName',
    flex        : 1,
    align       : 'left'
});
/*
 * @class Gnt.column.AssignmentUnits
 * @extends Ext.grid.Column
 * @private
 * Private class used inside Gnt.widget.AssignmentGrid.
 */
Ext.define("Gnt.column.AssignmentUnits", {
    extend      : "Ext.grid.column.Number",
    alias       : "widget.assignmentunitscolumn",
    
    text        : 'Units',
    dataIndex   : 'Units',
    format      : '0 %',
    align       : 'left'
});
Ext.define('Gnt.widget.AssignmentGrid', {
    
    requires    : [
        'Gnt.model.Resource',
        'Gnt.model.Assignment',
        'Gnt.column.ResourceName',
        'Gnt.column.AssignmentUnits',
        'Ext.grid.plugin.CellEditing'
    ],
    extend                  : 'Ext.grid.Panel',
    alias                   : 'widget.assignmentgrid',
    
    
    readOnly                : false,
    cls                     : 'gnt-assignmentgrid',
    
    defaultAssignedUnits    : 100,


    sorter : {
        sorterFn: function(o1, o2){
            var un1 = o1.getUnits(),
                un2 = o2.getUnits();
                    
            if ((!un1 && !un2) || (un1 && un2)) {
                return o1.get('ResourceName') < o2.get('ResourceName') ? -1 : 1;
            }
                
            return un1 ? -1 : 1;
        }
    },
    
    constructor : function (config) {
        this.store = Ext.create("Ext.data.JsonStore", {
            model: Ext.define('Gnt.model.AssignmentEditing', {
                extend : 'Gnt.model.Assignment',
                fields : ['ResourceName']
            })
        });

        this.columns = this.buildColumns();

        if (!this.readOnly) {
            this.plugins = this.buildPlugins();
        }

        Ext.apply(this, {
            selModel: {
                selType: 'checkboxmodel',
                mode: 'MULTI',
                checkOnly : true
            }
        });

        this.callParent(arguments);
    },

    initComponent : function() {
        this.loadResources();

        this.resourceStore.on({
            datachanged : this.loadResources,
            scope : this
        });

        // Delay required since repaint of the row happens too fast which messes up picker collapse logic!
        this.getSelectionModel().on('select', this.onSelect, this, { delay : 50 }); 

        this.callParent(arguments);
    },

    onSelect : function(sm, rec) {
        if ((!this.cellEditing || !this.cellEditing.getActiveEditor()) && !rec.getUnits()) {
            rec.setUnits(this.defaultAssignedUnits);
        }
    },

    loadResources: function() {
        var data = [],  
            rs = this.resourceStore,
            id;

        for (var i = 0, l = rs.getCount(); i < l; i++) {
            id = rs.getAt(i).getId();
            data.push({
                ResourceId : id, 
                ResourceName : rs.getById(id).getName()
            });
        }
        this.store.loadData(data);
    },

    buildPlugins : function() {
        
        var cellEditing = this.cellEditing = Ext.create('Ext.grid.plugin.CellEditing', {
            clicksToEdit: 1
        });

        cellEditing.on('edit', this.onEditingDone, this);

        return [
            cellEditing
        ];
    },

    onEditingDone : function(ed, e) {
        // Make sure row is selected after editing a cell
        if (e.value) {
            this.getSelectionModel().select(e.record, true); 
        } else {
            this.getSelectionModel().deselect(e.record); 
            e.record.reject();
        }
    },

    buildColumns : function() {
        return [
            {
                xtype : 'resourcenamecolumn',
                resourceStore : this.resourceStore
            },
            {
                xtype : 'assignmentunitscolumn',
                assignmentStore : this.assignmentStore,
                editor : {
                    xtype : 'numberfield',
                    minValue : 0,
                    step : 10
                }
            }
        ];
    },

    loadTaskAssignments : function(taskId) {
        var store       = this.store,
            sm          = this.getSelectionModel();
        
        // remove all checkboxes
        sm.deselectAll(true);

        // Reset all "Units" values of all resource assignment records first
        for (var i = 0, l = store.getCount(); i < l; i++) {
            // should be ok to use field names here, since we are inheriting directly from Gnt.model.Assignment
            store.getAt(i).data.Units = "";
            store.getAt(i).data.Id = null;
        }

        store.suspendEvents();
        
        var taskAssignments = this.assignmentStore.queryBy(function(a) { return a.getTaskId() === taskId; });

        taskAssignments.each(function (assignment) {
            var resourceAssignmentRecord = store.findRecord("ResourceId", assignment.getResourceId(), 0, false, true, true);
            
            if (resourceAssignmentRecord) {
                resourceAssignmentRecord.setUnits(assignment.getUnits());
                resourceAssignmentRecord.set(resourceAssignmentRecord.idProperty, assignment.getId());
                
                // mark the record with checkbox
                sm.select(resourceAssignmentRecord, true, true);
            }
        });
        store.resumeEvents();

        // Apply sort to show assigned resources at the top
        store.sort(this.sorter);

        this.getView().refresh();
    }
});
/**

@class Gnt.widget.AssignmentField
@extends Ext.form.field.Picker

A specialized field class, purposed to be used in the {@link Gnt.column.ResourceAssignment}.

*/

Ext.define('Gnt.widget.AssignmentField', {
    extend      : 'Ext.form.field.Picker',
    
    alias       : 'widget.assignmenteditor',
    
    requires    : [
        'Gnt.widget.AssignmentGrid'
    ],
    

    matchFieldWidth     : false,
    editable            : false,

    /**
     * @cfg {String} cancelText A text for the `Cancel` button
     */
    cancelText          : 'Cancel',
    
    /**
     * @cfg {String} closeText A text for the `Close` button
     */
    closeText           : 'Save and Close',

    
    /**
     * @cfg {Ext.data.Store} assignmentStore A store with assignments 
     */
    assignmentStore     : null,
    
    /**
     * @cfg {Ext.data.Store} resourceStore A store with resources 
     */
    resourceStore       : null,
    
    /**
     * @cfg {Object} gridConfig A custom config object used to configure the Gnt.widget.AssignmentGrid instance
     */
    gridConfig       : null,

    createPicker: function() {
        var grid = new Gnt.widget.AssignmentGrid(Ext.apply({
            ownerCt     : this.ownerCt,
            
            renderTo    : document.body,
            
            frame       : true,
            floating    : true,
            hidden      : true,
            
            height      : 200,
            width       : 300,
            
            
            resourceStore       : this.resourceStore,
            assignmentStore     : this.assignmentStore,
            
            fbar                : this.buildButtons()
        }, this.gridConfig || {}));
        return grid;
    },
    

    buildButtons : function() {
        return [
            '->',
            {   
                text        : this.closeText,
                
                handler     : function () {
                    // when clicking on "close" button with editor visible
                    // grid will be destroyed right away and seems in IE there will be no 
                    // "blur" event for editor
                    // this also sporadically reproducable in FF
                    // doing a defer to let the editor to process the "blur" first (will take 1 + 10 ms delays)
                    // only then close the editor window
                    Ext.Function.defer(this.onGridClose, Ext.isIE && !Ext.isIE9 ? 60 : 30, this);
                },
                scope       : this
            },
            {   
                text        : this.cancelText,
                
                handler     : this.collapse,
                scope       : this
            }
        ];
    },

    
    onExpand: function() {
        // Select the assigned resource in the grid
        var store = this.resourceStore,
            grid = this.picker;
        
        grid.loadTaskAssignments(this.taskId);
    },

    
    onGridClose : function() {
        var sm = this.picker.getSelectionModel(),
            selections = sm.selected;
        
        // Update the assignment store with the assigned resource data
        this.fireEvent('select', this, selections);
        
        this.collapse();
    },

    // http://www.sencha.com/forum/showthread.php?187632-4.1.0-B3-getEditorParent-is-ignored-nested-cell-editing-is-not-possible&p=755211
    collapseIf: function(e) {
        var me = this;
        
        // HACK: Not trivial to find all cases, menus, editors etc.
        if (this.picker && !e.getTarget('.x-editor') && !e.getTarget('.x-menu-item')) {
            me.callParent(arguments);
        }
    }
});
/**

@class Gnt.widget.AssignmentCellEditor
@extends Ext.grid.CellEditor

A specialized editor class, purposed to be used in the {@link Gnt.column.ResourceAssignment}. To customize the picker grid,
use the fieldConfig and set its 'gridConfig' property which will be used to configure the Gnt.widget.AssignmentGrid.

*/
Ext.define('Gnt.widget.AssignmentCellEditor', {
    extend      : 'Ext.grid.CellEditor',
    
    requires    : [
        'Gnt.model.Assignment',
        'Gnt.widget.AssignmentField'
    ],
    
    /**
     * @cfg {Ext.data.Store} assignmentStore A store with assignments 
     */
    assignmentStore     : null,
    
    /**
     * @cfg {Ext.data.Store} resourceStore A store with resources 
     */
    resourceStore       : null,
    
    /**
     * @property {String} taskId An id of the task assignments of which are currently being edited
     */
    taskId              : null,
    
    /**
     * @cfg {Object} fieldConfig An object with configuration options for the {@link Gnt.widget.AssignmentField}
     */
    fieldConfig         : null,
    
    // Without this setting, the picker will be collapsed when clicking the unit spinner arrows.
    allowBlur           : false,

    constructor: function (config) {
        config              = config || {};
        var fieldConfig     = config.fieldConfig || {};
        
        this.field = Ext.create("Gnt.widget.AssignmentField", Ext.apply(fieldConfig, {
            assignmentStore     : config.assignmentStore,
            resourceStore       : config.resourceStore
        }));
        
        this.field.on({
            select : this.onSelect, 
            collapse : this.cancelEdit,
            scope : this
        });
        this.callParent(arguments);
    },
    

    startEdit : function(el, value, context) {
        // this causes the editor to be rendered into <body> and prevents the 1px displacement of view during editing
        this.parentEl = null;
        
        var cellText = el.child('div').dom.innerHTML;
        this.taskId = this.field.taskId = context.value;
        
        this.callParent([el, cellText === '&nbsp;' ? '' : cellText]);
        
        this.field.expand();
    },

    
    onSelect : function(field, selections) {
        var aStore      = this.assignmentStore,
            taskId      = this.taskId;
        
        var assignmentsToStay   = {};
        var newAssignments      = [];
            
        selections.each(function (resourceAssignmentRecord) {
            var units = resourceAssignmentRecord.getUnits();
            
            if (units > 0) {
                var id      = resourceAssignmentRecord.getId();
                
                if (id) {
                    assignmentsToStay[ id ] = true;
                    
                    aStore.getById(id).setUnits(units);
                } else {
                    var newAssignment = Ext.create(aStore.model, {
                        TaskId      : taskId,
                        ResourceId  : resourceAssignmentRecord.getResourceId(),
                        Units       : units
                    });
                    
                    assignmentsToStay[ newAssignment.internalId ] = true;
                    
                    newAssignments.push(newAssignment);
                }
            }
        });

        var assignmentsToRemove     = [];
        
        // Remove any assignments that 
        // - are not phantom 
        // - and have been unchecked (and thus are not included in `assignmentsToStay`)
        aStore.each(function (assignment) {
            //   assignment is for our task       | not phantom |       was unchecked
            if (assignment.getTaskId() === taskId && !assignmentsToStay[ assignment.getId() || assignment.internalId ]) {
                assignmentsToRemove.push(assignment);
            }
        });

        aStore.remove(assignmentsToRemove);

        // Add selected assignments for this task
        aStore.add(newAssignments);
        
        this.completeEdit();
    }
});
/**

A specialized field, allowing a user to also specify duration unit when editing the duration value.
This class inherits from the standard Ext JS "number" field, so any usual `Ext.form.field.Number` configs can be used (like `minValue/maxValue` etc).

Recognizable values for duration unit part are (the trailing `..` symbols means anything will match):

- Milliseconds: `ms` or `mil..`
- Seconds: `s` or `sec..`
- Minutes: `m` or `min..`
- Hours: `h` or `hr` or `hour..`
- Days: `d` or `day..`
- Weeks: `w` or `wk` or `week..`
- Months: `mo..` or `mnt..`
- Quarters: `q` or `quar..` or `qrt..`
- Years: `y` or `yr..` or `year..`

You can change that using the `unitsRegex` configuration option.
 
@class Gnt.column.duration.Field
@extends Ext.form.field.Number

*/
Ext.define("Gnt.widget.DurationField", {
    extend      : "Ext.form.field.Number",
    
    alias       : "widget.durationfield",
    alternateClassName: 'Gnt.column.duration.Field',
    
    disableKeyFilter    : true,
    minValue            : 0,

    
    durationRegex   : /(-?\d+(?:[.,]\d+)?)\s*(\w+)?/i,
    
    /**
     * @cfg {Object} unitsRegex An object, which keys corresponds to duration units and values contains regular expressions to match the duration unit part of the text value. 
     */
    unitsRegex      : {
        MILLI       : /^ms$|^mil/i,
        SECOND      : /^s$|^sec/i,
        MINUTE      : /^m$|^min/i,
        HOUR        : /^h$|^hr$|^hour/i,
        DAY         : /^d$|^day/i,
        WEEK        : /^w$|^wk|^week/i,
        MONTH       : /^mo|^mnt/i,
        QUARTER     : /^q$|^quar|^qrt/i,
        YEAR        : /^y$|^yr|^year/i
    },
    
    /**
     * @cfg {String} durationUnit The default duration unit to use when editing the value. 
     * This is usually being set automatically, using the `DurationUnit` field of the task. 
     */
    durationUnit    : 'h',
    
    
    rawToValue: function (rawValue) {
        var parsed  = this.parseDuration(rawValue);
        
        if (!parsed) return null;
        
        this.durationUnit    = parsed.unit;
        
        return parsed.value != null ? parsed.value : null;
    },
    

    valueToRaw: function (value) {
        if (Ext.isNumber(value)) {
            return parseFloat(Ext.Number.toFixed(value, this.decimalPrecision)) + ' ' + Sch.util.Date.getReadableNameOfUnit(this.durationUnit);
        }
        
        return '';
    },
    
    
    parseDuration : function (value) {
        if (value == null || !this.durationRegex.test(value)) {
            return null;
        }
        
        var match               = this.durationRegex.exec(value);
        
        var durationValue       = this.parseValue(match[ 1 ]);
        
        var durationUnitName    = match[ 2 ];
        var durationUnit;        
        
        if (durationUnitName) Ext.iterate(this.unitsRegex, function (name, regex) {
            
            if (regex.test(durationUnitName)) {
                durationUnit    = Sch.util.Date.getUnitByName(name);
                
                return false;
            }
        });
        
        return {
            value   : durationValue,
            unit    : durationUnit || this.durationUnit
        };
    },
    
    
    /**
     * Returns an object, representing current value of the field:

    {
        value   : ... // duration value,
        unit    : ... // duration unit
    }

     * @return {Object}
     */
    getDurationValue : function () {
        return this.parseDuration(this.getRawValue());
    },
    
    
    getErrors : function (value) {
        var parsed   = this.parseDuration(value);
        
        if (!parsed) {
            return [ "Invalid number format" ];
        }
        
        return this.callParent([ parsed.value ]);
    }
});
/**
@class Gnt.widget.DurationEditor
@extends Ext.grid.CellEditor

A specialized "cell editor" class, purposed to update to use the task API call for duration update.
It will create an appropriate field class {@link Gnt.column.duration.Field} if not provided explicitly.

*/
 
// requires the presence of editing "context" (overridden in Sch.plugin.TreeCellEditing)
Ext.define("Gnt.widget.DurationEditor", {
    extend      : "Ext.grid.CellEditor",
    
    alias       : ["widget.durationeditor", "widget.durationcolumneditor"],
    alternateClassName: 'Gnt.column.duration.Editor',
    
    context     : null,
    
    /**
     * @cfg {Number} decimalPrecision A number of digits after the dot to show, when editing the value of the `Duration` field
     */
    decimalPrecision            : 2,
    
    getDurationUnitMethod       : 'getDurationUnit',
    setDurationMethod           : 'setDuration',
    
    
    constructor : function (config) {
        config  = config || {};
        
        config.field = config.field || Ext.create('Gnt.widget.DurationField', {
            decimalPrecision            : config.decimalPrecision || 2
        });
        
        this.callParent([ config ]);
    },
    
    
    startEdit   : function (p1, p2, context) {
        this.context                = context;
        
        this.field.durationUnit     = context.record[ this.getDurationUnitMethod ]();
        
        return this.callParent(arguments);
    },
    
    
    completeEdit : function (remainVisible) {
        var me = this,
            field = me.field,
            value;

        if (!me.editing) {
            return;
        }

        // Assert combo values first
        if (field.assertValue) {
            field.assertValue();
        }

        value = me.getValue();
        if (!field.isValid()) {
            if (me.revertInvalid !== false) {
                me.cancelEdit(remainVisible);
            }
            return;
        }

        if (String(value) === String(me.startValue) && me.ignoreNoChange) {
            me.hideEdit(remainVisible);
            return;
        }

        if (me.fireEvent('beforecomplete', me, value, me.startValue) !== false) {
            // Grab the value again, may have changed in beforecomplete
            value = me.getValue();
            if (me.updateEl && me.boundEl) {
                me.boundEl.update(value);
            }
            me.hideEdit(remainVisible);
            
            var context     = this.context;
            var task        = context.record;
            
            var duration    = this.field.getDurationValue();
            
            task[ this.setDurationMethod ](duration.value, duration.unit);
            
//            me.fireEvent('complete', me, value, me.startValue);
        }
    }
});
/**

@class Gnt.column.Duration
@extends Ext.grid.column.Column

{@img gantt/images/duration-field.png}

A Column representing a `Duration` field of a task. The column is editable, however to enable the editing you will need to add a
`Sch.plugin.TreeCellEditing` pluing to your gantt panel. The overall setup will look like this:

    var gantt = Ext.create('Gnt.panel.Gantt', {
        height      : 600,
        width       : 1000,
        
        // Setup your grid columns
        columns         : [
            ...
            {
                xtype       : 'durationcolumn',
                width       : 70
            }
            ...
        ],
        
        plugins             : [
            Ext.create('Sch.plugin.TreeCellEditing', {
                clicksToEdit: 1
            })
        ],
        ...
    })
    
This column uses a specialized editor {@link Gnt.column.duration.Editor} and field - {@link Gnt.column.duration.Field} which allows the 
user to specify not only the duration value, but also the duration units. 

When rendering the name of the duration unit, the {@link Sch.util.Date#getReadableNameOfUnit} method will be used to retrieve the name of the unit.

*/
Ext.define("Gnt.column.Duration", {
    extend      : "Ext.grid.column.Column",
    
    alias       : "widget.durationcolumn",
    
    requires    : [
        'Gnt.widget.DurationField',
        'Gnt.widget.DurationEditor'
    ],

    /**
     * @cfg {String} text The text to show in the column header, defaults to `Duration`.
     */
    text        : 'Duration',
    dataIndex   : 'Duration',
    
    /**
     * @cfg {Number} width A width of the column, default value is 80
     */
    width       : 80,

    /**
     * @cfg {String} align An align of the text in the column, default value is 'left'
     */
    align       : 'left',
    
    /**
     * @cfg {Number} decimalPrecision A number of digits to show after the dot when rendering the value of the field or when editing it
     */
    decimalPrecision            : 2,
    
    getDurationUnitMethod       : 'getDurationUnit',
    setDurationMethod           : 'setDuration',
    
    
    
    
    constructor : function (config) {
        config      = config || {};
        
        config.editor     = config.editor || Ext.create('Gnt.widget.DurationEditor', {
            decimalPrecision            : config.decimalPrecision || 2,
            getDurationUnitMethod       : config.getDurationUnitMethod || this.getDurationUnitMethod,
            setDurationMethod           : config.setDurationMethod || this.setDurationMethod
        });
        
        if (!config.editor.isFormField) {
            config.editor = Ext.ComponentManager.create(config.editor, 'durationcolumneditor');
        }

        this.scope      = this;
        
        this.callParent([ config ]);
        
        this.mon(this.editor, 'beforestartedit', this.onBeforeStartEdit, this);
    },
    
    
    onBeforeStartEdit : function (editor) {
        var task    = editor.context.record;
        
        return task.isEditable(this.dataIndex);
    },
    
    
    renderer    : function (value, meta, task) {
        if (!Ext.isNumber(value)) return '';
        
        if (!task.isEditable(this.dataIndex)) {
            meta.tdCls      = (meta.tdCls || '') + ' sch-column-readonly';
        }
        
        value   = parseFloat(Ext.Number.toFixed(value, this.decimalPrecision));
        
        return value + ' ' + Sch.util.Date.getReadableNameOfUnit(task[ this.getDurationUnitMethod ](), value > 1);
    }
    
});
/**

@class Gnt.column.Effort
@extends Gnt.column.Duration

{@img gantt/images/duration-field.png}

A Column representing a `Effort` field of a task. The column is editable, however to enable the editing you will need to add a
`Sch.plugin.TreeCellEditing` pluing to your gantt panel. The overall setup will look like this:

    var gantt = Ext.create('Gnt.panel.Gantt', {
        height      : 600,
        width       : 1000,
        
        // Setup your grid columns
        columns         : [
            ...
            {
                xtype       : 'effortcolumn',
                width       : 70
            }
            ...
        ],
        
        plugins             : [
            Ext.create('Sch.plugin.TreeCellEditing', {
                clicksToEdit: 1
            })
        ],
        ...
    })
    
This column uses a specialized editor {@link Gnt.widget.DurationEditor} and field - {@link Gnt.column.duration.Field} which allows the 
user to specify not only the duration value, but also the duration units. 

When rendering the name of the duration unit, the {@link Sch.util.Date#getReadableNameOfUnit} method will be used to retrieve the name of the unit.

*/
Ext.define("Gnt.column.Effort", {
    extend      : "Gnt.column.Duration",
    
    alias       : "widget.effortcolumn",
    
    /**
     * @cfg {String} header A text of the header, default value is `Effort`
     */
    header                      : 'Effort',
    dataIndex                   : 'Effort',
    
    getDurationUnitMethod       : 'getEffortUnit',
    setDurationMethod           : 'setEffort'
});
/**

@class Gnt.widget.Calendar
@extends Ext.picker.Date

{@img gantt/images/widget-calendar.png}

This a very simple subclass of the {@link Ext.picker.Date} which will show the holidays/weekends from the provided calendar.
The non-working time will be shown as the disabled dates.

*/
Ext.define('Gnt.widget.Calendar', {
    extend      : 'Ext.picker.Date',
    
    alias       : 'widget.ganttcalendar',
    
    requires    : [
        'Gnt.data.Calendar',
        'Sch.util.Date'
    ],
    
    /**
     * @cfg {Gnt.data.Calendar} calendar An instance of the {@link Gnt.data.Calendar} to read the holidays from 
     */
    calendar            : null,
    
    /**
     * @cfg {Date} startDate A start date of the range to show the holidays for.
     */
    startDate           : null,
    
    /**
     * @cfg {Date} endDate An end date of the range to show the holidays for.
     */
    endDate             : null,
    
    /**
     * @cfg {String} disabledDatesText A text to show in the tooltip when user selects a non-working day.
     */
    disabledDatesText   : 'Holiday',
    
    initComponent : function () {
        if (!this.calendar) {
            Ext.Error.raise('Required attribute "calendar" missing during initialization of `Gnt.widget.Calendar`');
        }
        
        if (!this.startDate) {
            Ext.Error.raise('Required attribute "startDate" missing during initialization of `Gnt.widget.Calendar`');
        }
        
        if (!this.endDate) {
            this.endDate = Sch.util.Date.add(this.startDate, Sch.util.Date.MONTH, 1); 
        }
        
        this.setCalendar(this.calendar);

        this.minDate        = this.value = this.startDate;
        
        this.injectDates();
        
        this.callParent(arguments);
    },

    injectDates : function() {
        var me              = this;
        var disabledDates   = me.disabledDates = []; 

        Ext.each(me.calendar.getHolidaysRanges(me.startDate, me.endDate), function (range) {
            range.forEachDate(function (date) {
                disabledDates.push(Ext.Date.format(date, me.format));
            });
        }); 

        me.setDisabledDates(disabledDates);
    },

    /**
     * Sets the calendar for this calendar picker
     * 
     * @param {Gnt.data.Calendar} calendar
     */
    setCalendar : function (calendar) {
        var listeners = {
            update  : this.injectDates,
            remove  : this.injectDates,
            add     : this.injectDates,
            load    : this.injectDates,
            clear   : this.injectDates,
            scope   : this
        };

        if (this.calendar) {
            this.calendar.un(listeners);
        }

        this.calendar = calendar;

        calendar.on(listeners);
    }
});
Ext.define('Gnt.widget.calendar.DayGrid', {
    extend : 'Ext.grid.Panel',
    
    title: "Day overrides",
    height: 180,

    /**
     * @cfg {String} nameText The text to show in the day override name column header
     */
    nameText : 'Name',

    /**
     * @cfg {String} dateText The text to show in the date column header
     */
    dateText : 'Date',

    /**
     * @cfg {String} noNameText The default name of a new day override
     */
    noNameText : '[Day override]',

    initComponent : function() {
        Ext.applyIf(this, {
            store: Ext.create('Gnt.data.Calendar', {
                proxy: 'memory'
            }),
            
            plugins:[
                Ext.create('Ext.grid.plugin.CellEditing', {
                    clicksToEdit: 2
                })
            ],
            columns: [{
                header: this.nameText,
                dataIndex: 'Name',
                flex: 1,
                editor: { allowBlank: false }
            },{
                header: this.dateText,
                dataIndex: 'Date',
                width: 100,
                xtype: 'datecolumn',
                editor: { xtype: 'datefield' }
            }]
        });

        this.callParent(arguments);
    }
});

Ext.define('Gnt.widget.calendar.WeekGrid', {
    extend : 'Ext.grid.Panel',

    requires : [
        'Gnt.model.WeekAvailability'
    ],

    title: 'Week overrides',
    border: true,
    height: 220,

     /**
     * @cfg {String} nameText The text to show in the week override name column header
     */
    nameText : 'Name',

    /**
     * @cfg {String} startDateText The text to show in the week override start date column header
     */
    startDateText : 'Start date',

     /**
     * @cfg {String} endDateText The text to show in the week override end date column header
     */
    endDateText : 'End date',

    initComponent : function() {
        Ext.applyIf(this, {
            store : Ext.create('Ext.data.Store', {
                model : 'Gnt.model.WeekAvailability',
                proxy   : 'memory'
            })
        });
        
        Ext.applyIf(this, {
            columns: [{
                header: this.nameText,
                dataIndex: this.store.model.prototype.nameField,
                flex: 1,
                editor: { allowBlank: false }
            },{
                header: this.startDateText,
                dataIndex: this.store.model.prototype.startDateField,
                width: 100,
                xtype: 'datecolumn',
                editor: { xtype: 'datefield' }
            },{
                header: this.endDateText,
                dataIndex: this.store.model.prototype.endDateField,
                width: 100,
                xtype: 'datecolumn',
                editor: { xtype: 'datefield' }
            }],
           
            plugins:[Ext.create('Ext.grid.plugin.CellEditing', {
                clicksToEdit: 2
            })]
        });

        this.callParent(arguments);
    }
});
Ext.define('Gnt.widget.calendar.ResourceCalendarGrid', {
    extend      : 'Ext.grid.Panel',

    requires    : [
        'Gnt.data.Calendar',
        'Sch.util.Date'
    ],

    alias                   : 'widget.resourcecalendargrid',

    resourceStore : null,
    calendarStore : null,

    initComponent : function() {
        var me = this;

        this.calendarStore = this.calendarStore || Ext.create('Ext.data.Store', {
            fields: ['Id', 'Name']
        });

        Ext.apply(me, {
            store: me.resourceStore,

            columns: [{
                header: 'Name',
                dataIndex: 'Name',
                flex: 1
            }, {
                header: 'Calendar',
                dataIndex: 'CalendarId',
                flex: 1,
                renderer : function(value, meta, record, col, index, store){
                    if(!value) {
                        var cal = record.getCalendar();
                        value = cal ? cal.calendarId : "";
                    }
                    var rec = me.calendarStore.getById(value);
                    return rec ? rec.get('Name') : value;
                },
                editor: {
                    xtype: 'combobox',
                    store: me.calendarStore,
                    queryMode: 'local',
                    displayField: 'Name',
                    valueField: 'Id',
                    editable : false,
                    allowBlank: false
                }
            }],
            border: true,
            height: 180,
            plugins:[Ext.create('Ext.grid.plugin.CellEditing', {
                clicksToEdit: 2
            })]
        });
       
        this.calendarStore.loadData(this.getCalendarData());
        this.callParent(arguments);
    },

    getCalendarData : function(){
        var result = [];
        Ext.Array.each(Gnt.data.Calendar.getAllCalendars(), function(cal){
            result.push({Id: cal.calendarId, Name: cal.name || cal.calendarId});
        });
        return result;
    }
});
Ext.define('Gnt.widget.calendar.DayAvailabilityGrid', {
    extend      : 'Ext.grid.Panel',

    requires    : [
        'Gnt.data.Calendar',
        'Sch.util.Date'
    ],

    alias                   : 'widget.dayavailabilitygrid',
    height: 160,

    calendarDay : null,

    /**
     * @cfg {String} startText The text to show in the start column header 
     */
    startText : 'Start',

    /**
     * @cfg {String} endText The text to show in the end column header
     */
    endText : 'End',

    /**
     * @cfg {String} addText The text to show on the add button
     */
    addText : 'Add',

    /**
     * @cfg {String} removeText The text to show on the remove button
     */
    removeText : 'Remove',

    /**
    * @cfg {String} workingTimeText The text to use for the working time radio button
    */
    workingTimeText: 'Working time',

    /**
    * @cfg {String} nonworkingTimeText The text to use for the non-working time radio button
    */
    nonworkingTimeText: 'Non-working time',

    getDayTypeRadioGroup : function(){
        return this.down('radiogroup[name="dayType"]');
    },

    initComponent : function() {
        Ext.applyIf(this, {
            store: Ext.create('Ext.data.Store', {
                fields:['startTime', 'endTime'],
                proxy: { type: 'memory', reader: { type: 'json' }}
            }),

            plugins: [Ext.create('Ext.grid.plugin.CellEditing', { clicksToEdit: 2 })],

            dockedItems : [
                {
                    xtype: 'radiogroup',
                    dock : 'top',
                    name: 'dayType',
                    padding : "0 5px",
                    margin: 0,
                    items: [
                        {boxLabel: this.workingTimeText, name: 'IsWorkingDay', inputValue: true},
                        {boxLabel: this.nonworkingTimeText, name: 'IsWorkingDay', inputValue: false }
                    ],
                    listeners : {
                        change : this.onDayTypeChanged, 
                        scope: this
                    }
                }
            ],

            tbar: this.buildToolbar(),
            columns: [{
                header: this.startText,
                xtype: 'datecolumn',
                format: 'g:i a',
                dataIndex: 'startTime',
                flex: 1,
                editor: { xtype: 'timefield', allowBlank: false, initDate: '31/12/1899' }
            },{
                header: this.endText,
                xtype: 'datecolumn',
                format: 'g:i a',
                dataIndex: 'endTime',
                flex: 1,
                editor: { allowBlank: false, xtype: 'timefield', initDate: '31/12/1899' }
            }],
            listeners : {
                selectionchange : this.onAvailabilityGridSelectionChange, 
                scope : this 
            }
        });

        this.callParent(arguments);
    },

    buildToolbar : function() {
        this.addButton = new Ext.Button({ text: this.addText, iconCls: 'gnt-action-add', handler: this.addAvailability, scope: this });
        this.removeButton = new Ext.Button({ text: this.removeText, iconCls: 'gnt-action-remove', handler: this.removeAvailability, scope: this, disabled: true });

        return [
            this.addButton,
            this.removeButton     
        ];
    },

    onAvailabilityGridSelectionChange : function(selection) {
        if (this.removeButton) {
            this.removeButton.setDisabled(!selection || selection.getSelection().length === 0);
        }
    },

    onDayTypeChanged : function(sender) {
        var val = sender.getValue();

        if(Ext.isArray(val.IsWorkingDay)) {
            return;
        }

        this.getView().setDisabled(!val.IsWorkingDay);
    },

    addAvailability: function(){
        var store = this.getStore(),
            count = store.count();

        if(count >= 5) {
            return;
        }

        store.add({
            startTime       : new Date(0, 0, 0, 12, 0),
            endTime         : new Date(0, 0, 0, 13, 0)
        });

        if(count + 1 >= 5 && this.addButton) {
            this.addButton.setDisabled(true);
        }
    },

    removeAvailability: function() {
        var store = this.getStore(),
            count = store.count(),
            sm = this.getSelectionModel();

        if(!sm || sm.getSelection().length === 0) {
            return;
        }

        var record = sm.getSelection()[0];
        store.remove(record);

        if(count < 5 && this.addButton) {
            this.addButton.setDisabled(false);
        }
    },

    editAvailability : function( day ){
        this.calendarDay = day;

        this.getDayTypeRadioGroup().setValue({ 
            IsWorkingDay : day.getIsWorkingDay()
        });

        var availability = this.calendarDay.getAvailability();

        this.getStore().loadData(availability);
    },

    isWorkingDay : function() {
        return this.getDayTypeRadioGroup().getValue().IsWorkingDay;
    },

    isValid: function(){
        var isWorkingDay =  this.getDayTypeRadioGroup().getValue().IsWorkingDay,
            intervals = [];

        if(isWorkingDay) {
            try {
                intervals = this.getIntervals();
                this.calendarDay.verifyAvailability(intervals);
            }
            catch(ex) {
                // TODO UGH
                Ext.MessageBox.alert('Error', ex);
                return false;
            }
        }

        return true;
    },

    getIntervals : function(){
        var intervals = [];
        this.getStore().each(function(item){
            intervals.push({startTime: item.get('startTime'), endTime: item.get('endTime')});
        });

        return intervals;
    }
});
Ext.define('Gnt.widget.calendar.WeekEditor', {
    extend: 'Ext.form.Panel',

    requires: [
        'Ext.grid.*',
        'Gnt.data.Calendar',
        'Sch.util.Date'
    ],

    alias: 'widget.calendarweekeditor',

    layout: 'anchor',

    defaults: { border: false, anchor: '100%' },

    getDefaultWeekAvailabilityHandler: null,

    startDate: null,
    endDate: null,

    /**
    * @cfg {String} startHeaderText The text to use for the start date column header
    */
    startHeaderText: 'Start',

    /**
    * @cfg {String} endHeaderText The text to use for the end date column header
    */
    endHeaderText: 'End',

    /**
    * @cfg {String} defaultTimeText The text to use for the default time radio button
    */
    defaultTimeText: 'Default time',

    /**
    * @cfg {String} workingTimeText The text to use for the working time radio button
    */
    workingTimeText: 'Working time',

    /**
    * @cfg {String} nonworkingTimeText The text to use for the non-working time radio button
    */
    nonworkingTimeText: 'Non-working time',

    /**
     * @cfg {String} addText The text to show on the add button
     */
    addText : 'Add',

    /**
     * @cfg {String} removeText The text to show on the remove button
     */
    removeText : 'Remove',

    weekAvailability: null,

    currentWeekDay: null,

    _weekDaysGrid: null,

    getWeekDaysGrid: function () {
        if (this._weekDaysGrid != null)
            return this._weekDaysGrid;

        var DN = Ext.Date.dayNames;

        return this._weekDaysGrid = Ext.create('Ext.grid.Panel', {
            hideHeaders: true,
            height: 160,
            columns: [{
                header: '',
                dataIndex: 'name',
                flex: 1
            }],

            store: Ext.create('Ext.data.JsonStore', {
                fields:['id', 'name'],
                idProperty: 'id',
                data: [
                    {id: 1, name: DN[1]},
                    {id: 2, name: DN[2]},
                    {id: 3, name: DN[3]},
                    {id: 4, name: DN[4]},
                    {id: 5, name: DN[5]},
                    {id: 6, name: DN[6]},
                    {id: 0, name: DN[0]}
                ]
            }),

            listeners: {
                selectionchange: { fn: this.onWeekDaysListSelectionChange, scope: this }
            }
        });

    },

    _availabilityGrid: null,

    getAvailabilityGrid: function () {
        if (!this._availabilityGrid) {
            this._availabilityGrid = Ext.create('Ext.grid.Panel', {
                height: 160,
                plugins: [Ext.create('Ext.grid.plugin.CellEditing', { clicksToEdit: 2 })],
                tbar: [
                    { text: this.addText, action: 'add', handler: this.addAvailability, scope: this, iconCls: 'gnt-action-add' },
                    { text: this.removeText, iconCls: 'gnt-action-remove', action: 'remove', handler: this.removeAvailability, scope: this }
                ],
                store: Ext.create('Ext.data.Store', {
                    fields: ['startTime', 'endTime'],
                    proxy: { type: 'memory', reader: { type: 'json'} }
                }),
                columns: [{
                    header: this.startHeaderText,
                    xtype: 'datecolumn',
                    format: 'g:i a',
                    dataIndex: 'startTime',
                    flex: 1,
                    editor: { xtype: 'timefield', allowBlank: false, initDate: '31/12/1899' }
                }, {
                    header: this.endHeaderText,
                    xtype: 'datecolumn',
                    format: 'g:i a',
                    dataIndex: 'endTime',
                    flex: 1,
                    editor: { allowBlank: false, xtype: 'timefield', initDate: '31/12/1899' }
                }],
                listeners: {
                    selectionchange: this.onAvailabilityGridSelectionChange, 
                    scope: this
                }
            });
        }

        return this._availabilityGrid;
    },

    getDayTypeRadioGroup: function () {
        return this.down('radiogroup[name="dayType"]');
    },

    initComponent: function () {
        if (!this.getDefaultWeekAvailabilityHandler && !Ext.isFunction(this.getDefaultWeekAvailabilityHandler)) {
            Ext.Error.raise('Required attribute "getDefaultWeekAvailabilityHandler" is missed during initialization of `Gnt.widget.calendar.WeekEditor`');
        }

        this.items = [{
            xtype: 'radiogroup',
            padding: "0 5px",
            name: 'dayType',
            items: [
                { boxLabel: this.defaultTimeText, name: 'IsWorkingDay', inputValue: 0 },
                { boxLabel: this.workingTimeText, name: 'IsWorkingDay', inputValue: 1 },
                { boxLabel: this.nonworkingTimeText, name: 'IsWorkingDay', inputValue: 2 }
            ],
            listeners: {
                change: { fn: this.onDayTypeChanged, scope: this }
            }
        }, {
            layout: 'column',
            padding: '0 0 5px 0',
            defaults: { border: false },
            items: [{
                margin: '0 10px 0 5px',
                columnWidth: 0.5,
                items: this.getWeekDaysGrid()
            }, {
                columnWidth: 0.5,
                margin: '0 5px 0 0',
                items: this.getAvailabilityGrid()
            }]
        }];

        this.callParent(arguments);
    },

    addAvailability: function () {
        var grid = this.getAvailabilityGrid(),
            store = grid.getStore(),
            count = store.count();

        if (count >= 5) return;

        store.add({
            startTime: new Date(0, 0, 0, 12, 0),
            endTime: new Date(0, 0, 0, 13, 0)
        });

        if (count + 1 >= 5) {
            grid.down('button[action="add"]').setDisabled(true);
        }
    },

    removeAvailability: function () {
        var grid = this.getAvailabilityGrid(),
            store = grid.getStore(),
            count = store.count(),
            sm = grid.getSelectionModel();

        if (!sm || sm.getSelection().length === 0) return;

        var record = sm.getSelection()[0];
        store.remove(record);

        if (count < 5) {
            grid.down('button[action="add"]').setDisabled(false);
        }
    },

    editAvailability: function (startDate, endDate, weekAvailability) {
        this.startDate = startDate;
        this.endDate = endDate;
        this.weekAvailability = weekAvailability;

        var grid = this.getWeekDaysGrid(),
            weekday = grid.getStore().getAt(0);

        grid.getSelectionModel().select(weekday, false, true);

        this.refreshView(weekday);
    },

    applyChanges: function (callback) {
        if (!this.validateAndSave()) {
            return false;
        }

        if (callback && Ext.isFunction(callback)) {
            callback.call(this, this.weekAvailability);
        }
    },

    getIntervals: function () {
        var intervals = [];
        this.getAvailabilityGrid().getStore().each(function (item) {
            intervals.push({ startTime: item.get('startTime'), endTime: item.get('endTime') });
        });

        return intervals;
    },

    onWeekDaysListSelectionChange: function (view, records) {
        if (!this.validateAndSave()) {
            return false;
        }

        this.refreshView(records[0]);
    },

    validateAndSave: function () {
        var isWorkingDay = this.currentWeekDay.get('IsWorkingDay'),
            intervals = [];

        if (isWorkingDay) {
            try {
                intervals = this.getIntervals();
                this.currentWeekDay.verifyAvailability(intervals);
            }
            catch (ex) {
                Ext.MessageBox.alert('Error', ex);
                return false;
            }
        }

        this.currentWeekDay.setAvailability(intervals);

        return true;
    },

    refreshView: function (weekday) {
        var id = weekday.getId(),
            day = this.weekAvailability[id],
            rb = this.getDayTypeRadioGroup(),
            availability = day.getAvailability(),
            match = /^(\d)-(\d\d\d\d\/\d\d\/\d\d)-(\d\d\d\d\/\d\d\/\d\d)$/.exec(day.getId()),
            dayType = !match ? 0 : (day.get('IsWorkingDay') ? 1 : 2);
        
        this.currentWeekDay = day;
        rb.setValue({ IsWorkingDay: [dayType] });
        this.getAvailabilityGrid().getStore().loadData(availability);
    },

    onAvailabilityGridSelectionChange: function (selection) {
        var grid = this.getAvailabilityGrid();
        grid.down('button[action="remove"]').setDisabled(!selection || selection.getSelection().length === 0);
    },

    onDayTypeChanged: function (sender) {
        var val = sender.getValue();
        if (Ext.isArray(val.IsWorkingDay)) return;

        var grid = this.getWeekDaysGrid(),
            sm = grid.getSelectionModel(),
            id = sm.getSelection()[0].getId(),
            overriddenName = this.weekAvailability[id].get('Name'),
            availability = [],
            sDate = Ext.Date.format(this.startDate, 'Y/m/d'),
            eDate = Ext.Date.format(this.endDate, 'Y/m/d');

        switch (val.IsWorkingDay) {
            case 0:
                var weekDay = this.getDefaultWeekAvailabilityHandler()[id];
                weekDay.set('Name', overriddenName);
                weekDay.set('Date', null);
                availability = weekDay.getAvailability();
                this.weekAvailability[id] = weekDay;
                break;

            default:
                availability = this.weekAvailability[id].getAvailability();
                this.currentWeekDay.set('Id', Ext.String.format("{0}-{1}-{2}", id, sDate, eDate));
                this.currentWeekDay.set('IsWorkingDay', val.IsWorkingDay === 1);
                break;
        }

        this.getAvailabilityGrid().getStore().loadData(Ext.clone(availability));
        this.getAvailabilityGrid().setDisabled(val.IsWorkingDay !== 1);
    }
});
Ext.define('Gnt.widget.calendar.DatePicker', {
    extend : 'Ext.picker.Date',

    alias: 'widget.gntdatepicker',

    calendar : null,

    workingDayCls : 'gnt-datepicker-workingday',

    nonWorkingDayCls : 'gnt-datepicker-nonworkingday',

    overriddenDayCls: 'gnt-datepicker-overriddenday',

    overriddenWeekDayCls : 'gnt-datepicker-overriddenweekday',

    _weeks : null,

    getWeekOverrides :function(){
        return this._weeks;
    },

    setWeekOverrides : function( store ){
        this._weeks = store;
        //this.update();
    },

    _days : null,

    getDayOverrides : function() {
        return this._days;
    },

    setDayOverrides : function( store ){
        this._days = store;
    },

    update : function(date, forceRefresh) {
        var me = this,
            i = 0,
            cells = me.cells.elements;

        this.removeCustomCls();

        this.callParent(arguments);

        for(; i < me.numDays; ++i) {
            date = cells[i].firstChild.dateValue;
            cells[i].className += ' ' + this.getDateCls(date);
        }

    },

    getDateCls : function(date){
        var cls = "",
            i = 0,
            me = this;
        
        date = new Date(date);

        if(date.getMonth() !== this.getActive().getMonth())
            return;

        if(this.getDayOverrides().getOverrideDay(date)) {
            cls += (" " + this.overriddenDayCls);

            if(!this.getDayOverrides().isWorkingDay(date))
                cls += (" " + this.nonWorkingDayCls);
        }
        else {
            var week = null;
            this.getWeekOverrides().each(function( weekOverride ){
                if (Ext.Date.between(date, weekOverride.getStartDate(), weekOverride.getEndDate())) {
                    week = weekOverride;
                    return true;
                }
            });

            if(week) {
                cls += (" " + this.overriddenWeekDayCls);

                var index = new Date(date).getDay(),
                    weekAvailability = week.getAvailability();

                if(weekAvailability &&
                    weekAvailability[index] &&
                    weekAvailability[index].getIsWorkingDay() === false ) {
                    cls += (" " + me.nonWorkingDayCls);
                }
            }

            else if(!this.getDayOverrides().isWorkingDay(date)) {
                cls += (" " + this.nonWorkingDayCls);
            }
        }

        return cls.length > 0 ? cls : this.workingDayCls;
    },

    removeCustomCls : function(){
        this.cells.removeCls([this.overriddenDayCls, this.nonWorkingDayCls, this.workingDayCls, this.overriddenWeekDayCls]);
    }
});
Ext.define('Gnt.widget.calendar.Calendar', {
    extend      : 'Ext.form.Panel',

    requires    : [
        'Ext.XTemplate',
        'Gnt.data.Calendar',
        'Gnt.widget.calendar.DayGrid',
        'Gnt.widget.calendar.WeekGrid',
        'Gnt.widget.calendar.DayAvailabilityGrid',
        'Gnt.widget.calendar.WeekEditor',
        'Gnt.widget.calendar.DatePicker'
    ],

    alias   : 'widget.calendar',

    defaults: { padding: 10, border: false },

    /**
     * @cfg {String} css class will be applied to all working days at legend block and datepicker
     */
    workingDayCls : 'gnt-datepicker-workingday',

    /**
     * @cfg {string} css class will be applied to all non-working days at legend block and datepicker
     */
    nonWorkingDayCls : 'gnt-datepicker-nonworkingday',

    /**
     * @cfg {String} css class will be applied to all overridden days at legend block and datepicker
     */
    overriddenDayCls: 'gnt-datepicker-overriddenday',

    /**
     * @cfg {String} css class will be applied to all overridden days inside overridden week at legend block and date picker
     */
    overriddenWeekDayCls : 'gnt-datepicker-overriddenweekday',

    /**
     * @cfg {Gnt.data.Calendar} calendar An instance of the {@link Gnt.data.Calendar} to read the holidays from
     */
    calendar            : null,

    /**
     * @cfg {String} dayOverrideNameHeaderText The text to show in the day override name column header
     */
    dayOverrideNameHeaderText : 'Name',

    /**
     * @cfg {String} dateText The text to show in the date column header
     */
    dateText : 'Date',

    /**
     * @cfg {String} addText The text to show on the add button
     */
    addText : 'Add',

     /**
     * @cfg {String} editText The text to show on the edit button
     */
    editText : 'Edit',

    /**
     * @cfg {String} removeText The text to show on the remove button
     */
    removeText : 'Remove',

    /**
     * @cfg {String} workingDayText The "working day" text to include in the calendar legend.
     */
    workingDayText : 'Working day',

    /**
     * @cfg {String} weekendsText The "weekends" text to in the calendar legend.
     */
    weekendsText : 'Weekends',

    /**
     * @cfg {String} overriddenDayText The "Overridden day" text to in the calendar legend.
     */
    overriddenDayText : 'Overridden day',

    /**
     * @cfg {String} overriddenWeekText The "Overridden week" text to in the calendar legend.
     */
    overriddenWeekText : 'Overridden week',

    /**
    * @cfg {String} defaultTimeText The text to use for the default time radio button
    */
    defaultTimeText: 'Default time',

    /**
    * @cfg {String} workingTimeText The text to use for the working time radio button
    */
    workingTimeText: 'Working time',

    /**
    * @cfg {String} nonworkingTimeText The text to use for the non-working time radio button
    */
    nonworkingTimeText: 'Non-working time',

    /**
     * @cfg {Object} dayGridConfig A custom config object to use when configuring the Gnt.widget.calendar.DayGrid instance.
     */
    dayGridConfig : null,

    /**
     * @cfg {Object} weekGridConfig A custom config object to use when configuring the Gnt.widget.calendar.WeekGrid instance.
     */
    weekGridConfig : null,

    /**
     * @cfg {Object} datePickerConfig A custom config object to use when configuring the Gnt.widget.calendar.DatePicker instance.
     */
    datePickerConfig : null,

    /**
     * @cfg {String} dayOverridesText The text to show in the day overrides window title.
     */
    dayOverridesText : 'Day overrides',

    /**
     * @cfg {String} weekOverridesText The text to show in the week overrides window title.
     */
    weekOverridesText : 'Week overrides',

    /**
     * @cfg {String} okText The text to show in the OK button
     */
    okText : 'OK',

    /**
     * @cfg {String} cancelText The text to show in the Cancel button
     */
    cancelText : 'Cancel',



    dayGrid : null,
    weekGrid : null,

    getDayGrid: function() {
        if(!this.dayGrid) {
            this.dayGrid = Ext.create('Gnt.widget.calendar.DayGrid', Ext.apply({
                tbar: [
                    { text: this.addText, action: 'add', iconCls: 'gnt-action-add', handler: this.addDay, scope: this },
                    { text: this.editText, action: 'edit', iconCls: 'gnt-action-edit', handler: this.editDay, scope: this },
                    { text: this.removeText, action: 'remove', iconCls: 'gnt-action-remove', handler: this.removeDay, scope: this }
                ]
            }, this.dayGridConfig || {}) );
        }

        return this.dayGrid;
    },

    getWeekGrid : function() {
        if(!this.weekGrid) {
            this.weekGrid = Ext.create('Gnt.widget.calendar.WeekGrid', Ext.apply({
                tbar: [
                    { text: this.addText, action: 'add', iconCls: 'gnt-action-add', handler: this.addWeek, scope: this },
                    { text: this.editText, action: 'edit', iconCls: 'gnt-action-edit', handler: this.editWeek, scope: this },
                    { text: this.removeText, action: 'remove', iconCls: 'gnt-action-remove', handler: this.removeWeek, scope: this }
                ]
            }, this.weekGridConfig || {}) );
        }
        return this.weekGrid;
    },

    datePicker : null,

    getDatePicker : function(){
        if(!this.datePicker) {
            this.datePicker = Ext.create('Gnt.widget.calendar.DatePicker', this.datePickerConfig || {});
        }

        return this.datePicker;
    },

    legendTpl : '<ul class="gnt-calendar-legend">' +
            '<li class="gnt-calendar-legend-item">' +
                '<div class="gnt-calendar-legend-itemstyle {workingDayCls}"></div>' +
                '<span class="gnt-calendar-legend-itemname">{workingDayText}</span>' +
                '<div style="clear: both"></div>' +
            '</li>' +
            '<li>' +
                '<div class="gnt-calendar-legend-itemstyle {nonWorkingDayCls}"></div>' +
                '<span class="gnt-calendar-legend-itemname">{weekendsText}</span>' +
                '<div style="clear: both"></div>' +
            '</li>' +
            '<li class="gnt-calendar-legend-override">' +
                '<div class="gnt-calendar-legend-itemstyle {overriddenDayCls}">31</div>' +
                '<span class="gnt-calendar-legend-itemname">{overriddenDayText}</span>' +
                '<div style="clear: both"></div>' +
            '</li>' +
            '<li class="gnt-calendar-legend-override">' +
                '<div class="gnt-calendar-legend-itemstyle {overriddenWeekDayCls}">31</div>' +
                '<span class="gnt-calendar-legend-itemname">{overriddenWeekText}</span>' +
                '<div style="clear: both"></div>' +
            '</li>' +
        '</ul>',

    dateInfoTpl : 
        '<tpl if="isWorkingDay == true">' +
            '<div>Working hours for {date}:</div>' +
        '</tpl>' +
        '<tpl if="isWorkingDay == false">' +
            '<div>{date} is non-working</div>' + 
        '</tpl>' +

        '<ul class="gnt-calendar-availabilities">' +
            '<tpl for="availability">' +
                '<li>{.}</li>' +
            '</tpl>' +
        '</ul>' +

        '<span>Based on: ' +
            '<tpl if="override == true">' +
                'override "{name}" in calendar "{calendarName}"' +
            '</tpl>' +
            '<tpl if="override == false">' +
                'standard day in calendar "{calendarName}"' +
            '</tpl>' +
        '</span>',

    initComponent : function() {
        var me = this;

        if (!(this.legendTpl instanceof Ext.Template)) {
            this.legendTpl = new Ext.XTemplate(this.legendTpl);
        }

        if (!(this.dateInfoTpl instanceof Ext.Template)) {
            this.dateInfoTpl = new Ext.XTemplate(this.dateInfoTpl);
        }

        if (!this.calendar) {
            Ext.Error.raise('Required attribute "calendar" is missed during initialization of `Gnt.widget.Calendar`');
        }

        var weekGrid = this.getWeekGrid(),
            dayGrid = this.getDayGrid(),
            datePicker  = this.getDatePicker();

        this.dayGrid.on({
            selectionchange : this.onDayGridSelectionChange,
            validateedit    : this.onDayGridValidateEdit,
            edit            : this.onDayGridEdit, 
            scope           : this
        });

        this.dayGrid.store.on({
            update  : this.refreshView,
            remove  : this.refreshView,
            add     : this.refreshView,
            scope : this
        });

        this.weekGrid.on({
            selectionchange : this.onWeekGridSelectionChange,
            validateedit    : this.onWeekGridValidateEdit,
            edit            : this.onWeekGridEdit, 
            scope           : this
        });

        this.weekGrid.store.on({
            update  : this.refreshView,
            remove  : this.refreshView,
            add     : this.refreshView,
            scope : this
        });

        this.datePicker.on({
            select : this.onDateSelect, 
            scope: this
        });

        this.fillDaysStore();

        this.fillWeeksStore();

        datePicker.setWeekOverrides( weekGrid.getStore() );
        datePicker.setDayOverrides( dayGrid.getStore() );

        this.dateInfoPanel = new Ext.Panel({
            cls : 'gnt-calendar-dateinfo',
            columnWidth: 0.33,
            border: false,
            height: 200
        });

        this.items = [{
            xtype: 'container',
            layout: 'hbox',
            pack: 'start',
            align: 'stretch',
            items:[{
                html: Ext.String.format('Calendar name: "{0}"', this.calendar.name),
                border: false,
                flex: 1
            },{
                xtype : 'combobox',
                name: 'cmb_parentCalendar',
                fieldLabel: 'Parent calendar',
                store: Ext.create('Ext.data.Store', {
                    fields: ['Id', 'Name'],
                    data : [{Id: -1, Name: 'No parent'}].concat(me.calendar.getParentableCalendars())
                }),
                queryMode: 'local',
                displayField: 'Name',
                valueField: 'Id',
                editable : false,
                emptyText : 'Select parent',
                value : me.calendar.parent ? me.calendar.parent.calendarId : -1,
                flex: 1
            }]
        },{
            layout: 'column',
            defaults: { border: false },
            items: [{
                margin: '0 15px 0 0',
                columnWidth: 0.3,
                html: this.legendTpl.apply({
                    workingDayText      : this.workingDayText,
                    weekendsText        : this.weekendsText,
                    overriddenDayText   : this.overriddenDayText,
                    overriddenWeekText  : this.overriddenWeekText,
                    workingDayCls       : this.workingDayCls,
                    nonWorkingDayCls    : this.nonWorkingDayCls,
                    overriddenDayCls    : this.overriddenDayCls,
                    overriddenWeekDayCls: this.overriddenWeekDayCls
                })
            },{
                columnWidth: 0.37,
                margin: '0 5px 0 0',
                items: datePicker
            },
            this.dateInfoPanel]
        }, {
            xtype: 'tabpanel',
            items: [ dayGrid, weekGrid ]
        }];

        this.callParent(arguments);
    },

    onRender : function() {
        this.onDateSelect(this.getDatePicker(), new Date());
        this.callParent(arguments);
    },

    fillDaysStore: function(){
        var dataTemp = [];
        this.calendar.each(function(calendarDay){
            if(!calendarDay.getDate()) return;

            dataTemp.push(Ext.create('Gnt.model.CalendarDay', {
                Date            : calendarDay.getDate(),
                Id              : calendarDay.getId(),
                Name            : calendarDay.getName(),
                IsWorkingDay    : calendarDay.getIsWorkingDay(),
                Availability    : calendarDay.getAvailability()
            }));
        });

        this.getDayGrid().getStore().loadData(dataTemp);
    },

    fillWeeksStore : function(){
        var data = [], 
            me = this,
            waModelProt = this.getWeekGrid().store.model.prototype;

        Ext.Array.each(this.calendar.nonStandardWeeksStartDates, function(startDate){
            var weekOverride = me.calendar.getNonStandardWeekByStartDate(startDate);
            var week = {};
            var weekAvailability = me.calendar.getDefaultWeekAvailability();
            
            week[waModelProt.nameField]             = weekOverride.name;
            week[waModelProt.startDateField]        = weekOverride.startDate;
            week[waModelProt.endDateField]          = weekOverride.endDate;
            week[waModelProt.availabilityField]     = weekAvailability;
            
            Ext.Array.each(weekAvailability, function(weekDay){
                weekDay.setName(weekOverride.name);
                weekDay.clearDate(null);
            });
            
            Ext.Array.each(weekOverride.weekAvailability, function(weekDay){
                var id = weekDay.getId();
                var match       = /^(\d)-(\d\d\d\d\/\d\d\/\d\d)-(\d\d\d\d\/\d\d\/\d\d)$/.exec(id);
                
                if(!match) {
                    return;
                }
                
                var index = match[1];
                var day = Ext.create('Gnt.model.CalendarDay');

                day.clearDate(null);
                day.setId(id);
                day.setName(weekOverride.name);
                day.setIsWorkingDay(weekDay.getIsWorkingDay());
                day.setAvailability(weekDay.getAvailability());
                
                weekAvailability[index] = day;
            });

            data.push(week);
        });

        this.getWeekGrid().getStore().loadData(data);
    },

    reload : function(){
        var weekGrid = this.getWeekGrid(),
            dayGrid = this.getDayGrid();

        this.fillDaysStore();
        this.fillWeeksStore();

        this.getDatePicker().setWeekOverrides( weekGrid.getStore() );
        this.getDatePicker().setDayOverrides( dayGrid.getStore() );
    },

    editDay : function(){
        var me = this,
            sm = this.getDayGrid().getSelectionModel();

        if(!sm || sm.getSelection().length === 0) return;

        var day = sm.getSelection()[0];
        var grid = new Gnt.widget.calendar.DayAvailabilityGrid({ 
            addText : this.addText, 
            removeText : this.removeText,
            workingTimeText: this.workingTimeText,
            nonworkingTimeText: this.nonworkingTimeText
        });

        var wndAdv = Ext.create('Ext.window.Window', {
            title: this.dayOverridesText,
            modal: true,
            width: 280,
            height: 260,
            layout : 'fit',
            items : grid,
            buttons: [{
                text: this.okText,
                handler: function(){
                    me.calendar.clearCache();
                    
                    if (grid.isValid()) {
                        var cDay = grid.calendarDay;
                        
                        cDay.setIsWorkingDay(grid.isWorkingDay());
                        cDay.setAvailability(grid.getIntervals());
                        me.applyCalendarDay(cDay, day);
                        me.refreshView();
                        wndAdv.close();
                    }
                }
            }, {
                text: this.cancelText,
                handler: function() {
                    wndAdv.close();
                }
            }]
        });

        grid.editAvailability(this.cloneCalendarDay(day));

        wndAdv.show();
    },

    addDay : function(){
        var date = this.getDatePicker().getValue(),
            grid = this.getDayGrid(),
            r = Ext.create('Gnt.model.CalendarDay', {
                Name: '[Without name]',
                Cls: this.calendar.defaultNonWorkingTimeCssCls,
                Date: date,
                IsWorkingDay: false
            });

        grid.getStore().insert(0, r);
        grid.getSelectionModel().select([r], false, false);
    },

    removeDay : function(){
        var grid = this.getDayGrid(),
            sm = grid.getSelectionModel(),
            store = grid.getStore();

        if(!sm || sm.getSelection().length === 0) return;

        store.clearCache();

        var record = sm.getSelection()[0],
            date = this.getDatePicker().getValue(),
            weekDayIndex = date.getDay(),
            day = this.getWeekOverrideDay(date),
            override = day != null;

        store.remove(record);

        if(day == null) {
            day = this.calendar.defaultWeekAvailability[weekDayIndex];
        }

        this.getDatePicker().setValue(date);
    },

    refreshView : function(){
        var date        = this.getDatePicker().getValue(),
            day         = this.getCalendarDay(date),
            weekGrid    = this.getWeekGrid(),
            dayGrid     = this.getDayGrid(),
            dayOverride = dayGrid.getStore().getOverrideDay(date),
            weekOverride;
            
        // First check if there is an override on day level
        if (dayOverride) {
            dayGrid.getSelectionModel().select([dayOverride], false, true);
        } else {
            // Now check if there is an override on week level
            weekOverride = this.getWeekOverrideByDate(date);
            if (weekOverride) {
                weekGrid.getSelectionModel().select([weekOverride], false, true);   
            }
        }
        
        var dayData = {
            name            : day.getName(),
            date            : Ext.Date.format(date, 'M j, Y'),
            calendarName    : this.calendar.name || this.calendar.calendarId,
            availability    : day.getAvailability(true),
            override        : !!(dayOverride || weekOverride),
            isWorkingDay    : day.getIsWorkingDay()
        };

        this.dateInfoPanel.update(this.dateInfoTpl.apply(dayData));
    },

    onDayGridSelectionChange : function(selection){
        if(!selection || selection.getSelection().length === 0) return;

        var day = selection.getSelection()[0],
            date = day.getDate(),
            grid = this.getDayGrid();

        this.getDatePicker().setValue(date);
    },

    onDayGridEdit : function(editor, e){
        if(e.field === 'Date') {
            var cleared = Ext.Date.clearTime(e.value, true);
            e.record.data[ e.record.idProperty ] = cleared - 0;
            e.grid.getStore().clearCache();
            this.getDatePicker().setValue(e.value);
        }

        this.refreshView();
    },

    onDayGridValidateEdit: function(editor, e){ 
        var store = e.grid.getStore();

        if(e.field === store.model.prototype.dateField && 
           store.getOverrideDay(e.value) && e.value !== e.originalValue) {
            Ext.MessageBox.alert('Error', 'There is already an override for this day');
            return false;
        }
    },

    onDateSelect : function( picker, date ){
        this.refreshView();
    },

    getCalendarDay: function(date){
        var day = this.getOverrideDay(date);

        if(day) {
            return day;
        }

        day = this.getWeekOverrideDay(date);

        if(day) {
            return day;
        }

        return this.calendar.defaultWeekAvailability[ date.getDay() ];
    },

    getOverrideDay : function(date){
        return this.getDayGrid().getStore().getOverrideDay(date);
    },

    getWeekOverrideDay : function(date){
        var dateTime = new Date(date),
            week = this.getWeekOverrideByDate(date),
            index = dateTime.getDay();

        if(week == null) return null;

        var weekAvailability = week.getAvailability();

        if(!weekAvailability) return null;

        return weekAvailability[index];
    },

    getWeekOverrideByDate: function(date) {
        var week = null;
            
        this.getWeekGrid().getStore().each(function( weekOverride ){
            if (Ext.Date.between(date, weekOverride.getStartDate(), weekOverride.getEndDate())) {
                week = weekOverride;
                return true;
            }
        });

        return week;
    },

    editWeek : function(){
        var sm = this.getWeekGrid().getSelectionModel(),
            me = this;

        if(!sm || sm.getSelection().length === 0) return;

        var week = sm.getSelection()[0];
        var grid = new Gnt.widget.calendar.WeekEditor({
            getDefaultWeekAvailabilityHandler : function() {
                return me.getDefaultWeekAvailability();
            }
        });

        var wndAdv = Ext.create('Ext.window.Window', {
            title: this.weekOverridesText,
            modal: true,
            width: 370,
            defaults: { border: false },
            layout : 'fit',
            items : grid,
            buttons: [{
                text: this.okText,
                handler: function(){
                    me.calendar.clearCache();
                    
                    grid.applyChanges(function( weekAvailability ){
                        week.setAvailability(weekAvailability);
                        var date = me.getDatePicker().getValue(),
                            weekDay = weekAvailability[date.getDay()];

                        me.refreshView();
                        wndAdv.close();
                    });
                }
            }, {
                text: this.cancelText,
                handler: function() {
                    wndAdv.close();
                }
            }]
        });

        var availability = [];
        Ext.Array.each(week.getAvailability(), function(day){
            availability.push( me.cloneCalendarDay(day) );
        });

        wndAdv.show();

        wndAdv.down('calendarweekeditor').editAvailability(
            week.getStartDate(),
            week.getEndDate(),
            availability
        );
    },

    addWeek : function(){
        var store = this.getWeekGrid().getStore();
        var date = this.getDatePicker().getValue(),
            r = new store.model();

        r.setName('[Without name]');
        r.setStartDate(date);
        r.setEndDate(date);
        r.setAvailability(this.calendar.getDefaultWeekAvailability());

        store.insert(0, r);
        this.getWeekGrid().getSelectionModel().select([r], false, false);
    },

    removeWeek: function(){
        var sm = this.getWeekGrid().getSelectionModel();

        if(!sm || sm.getSelection().length === 0) return;

        var record = sm.getSelection()[0],
            date = this.getDatePicker().getValue(),
            weekDayIndex = date.getDay(),
            day = this.getOverrideDay(date),
            overridden = !!day;

        day = day || this.calendar.defaultWeekAvailability[weekDayIndex];

        this.getWeekGrid().getStore().remove(record);

        this.getDatePicker().setValue(date);
        this.refreshView();

    },

    onWeekGridSelectionChange : function(selection){
        if(!selection || selection.getSelection().length === 0) return;

        var record = selection.getSelection()[0],
            date = record.getStartDate(),
            weekDayIndex = date.getDay(),
            t = record.getAvailability()[weekDayIndex],
            grid = this.getWeekGrid();

        if(t == null) {
            // todo: possible we need common method
            t = this.calendar.defaultWeekAvailability[weekDayIndex];
        }
        this.getDatePicker().setValue(date);
    },

    onWeekGridEdit : function(editor, e){
        var record = e.record,
            startDate = record.getStartDate(),
            endDate = record.getEndDate(),
            weekDayIndex = startDate.getDay(),
            availability = record.getAvailability(),
            t = availability[weekDayIndex];
            prot = e.grid.getStore().model.prototype;

        if(t == null) {
            // todo: possible we need common method
            t = this.calendar.defaultWeekAvailability[weekDayIndex];
        }

        if(e.field == prot.startDateField ||
           e.field == prot.endDateField) {

            var sDate = Ext.Date.format(startDate, 'Y/m/d');
            var eDate = Ext.Date.format(endDate, 'Y/m/d');

            Ext.Array.each(availability, function(weekDay){
                var id          = weekDay.getId();
                var match       = /^(\d)-(\d\d\d\d\/\d\d\/\d\d)-(\d\d\d\d\/\d\d\/\d\d)$/.exec(id);

                if(!match) return;

                weekDay.set('Id', Ext.String.format("{0}-{1}-{2}", match[1], sDate, eDate));
            });

            this.getDatePicker().setValue(startDate);
        }

        this.refreshView();
    },

    onWeekGridValidateEdit: function(editor, e){
        var record = e.record,
            startDate = record.getStartDate(),
            endDate = record.getEndDate(),
            noIntersectionErrors = true;

        var store = e.grid.getStore();
        var prot = store.model.prototype;

        if((e.field === prot.startDateField && endDate < e.value ||
            e.field === prot.endDateField && startDate > e.value)) {
            // TODO
            Ext.MessageBox.alert('Error', 'StartDate greater then EndDate');
            return false;
        }

        store.each(function( week ){
            var sDate = week.getStartDate(),
                eDate = week.getEndDate();

            if(sDate == startDate && eDate == endDate ) return;

            if((e.field == prot.startDateField && sDate < startDate && e.value <= eDate) ||
               (e.field == prot.endDateField && eDate > endDate && e.value >= sDate)) {
                noIntersectionErrors = false;
                return true;
            }
        });


        if(!noIntersectionErrors) {
            // TODO
            Ext.MessageBox.alert('Error', "Dates shouldn't intersect");
            return false;
        }

    },

    applyChanges : function( callback ) {
        var value = this.down('combobox[name="cmb_parentCalendar"]').getValue();

        this.calendar.parent = value ?
            Gnt.data.Calendar.getCalendar(value) : null;

        this.calendar.proxy.extraParams.parentId =
            this.calendar.parent ? this.calendar.parent.calendarId : null;

        this.applyDays();
        this.applyWeeks();

        if(callback && Ext.isFunction(callback)) {
            callback.call(this, this.calendar);
        }
    },

    applyCalendarDay : function(from, to){
        to.beginEdit();

        to.setId(from.getId());
        to.setName(from.getName());
        to.setIsWorkingDay(from.getIsWorkingDay());
        to.setDate(from.getDate());
        to.setAvailability(from.getAvailability());

        to.endEdit();
    },

    applyWeek : function(from, to){
        var me = this,
        re = /^(\d)-(\d\d\d\d\/\d\d\/\d\d)-(\d\d\d\d\/\d\d\/\d\d)$/;

        Ext.Array.each(from.getAvailability(), function(calendarDay, index){
            var found = false,
                calendarDayId = calendarDay.getId(),
                isDefaultDay = re.exec(calendarDayId) ? false : true;

            Ext.Array.each(to.weekAvailability, function(day){
                var id = day.getId(),
                    match = re.exec(id);

                if(match[1] == index)
                {
                    if(isDefaultDay) me.calendar.remove(day);
                    else me.applyCalendarDay(calendarDay, day);

                    // can't write `return found = true;` because jslint will not be happy 
                    found = true;
                        
                    return found;
                }
            });

            if(!found && !isDefaultDay) {
                me.calendar.add(calendarDay);
            }
        });
    },

    applyWeeks : function(){
        var me = this,
            store = this.getWeekGrid().getStore(),
            forRemove = [], forUpdate = [], forInsert = [];

        Ext.Array.each(this.calendar.nonStandardWeeksStartDates, function(date){
            var found = false;
            
            store.each(function(week){
                var startDate = Ext.Date.clearTime(week.getStartDate());
                
                // TODO
                if (startDate === date) {
                    var calWeek = me.calendar.getNonStandardWeekByDate(date);
                    calWeek.endDate == week.getEndDate() ? forUpdate.push([week, calWeek]) :
                                                           forRemove.push(date);

                    found = true;
                        
                    return true;
                }
            });

            if(!found) {
                forRemove.push(date);
            }
        });

        store.each(function(week){
            if (me.calendar.getNonStandardWeekByDate(week.getStartDate() == null)) {
                forInsert.push(week);
            }
        });

        Ext.Array.each(forRemove, function(date){
            me.calendar.removeNonStandardWeek(date);
        });

        Ext.Array.each(forInsert, function(week){
            me.calendar.addNonStandardWeek(
                week.getStartDate(),
                week.getEndDate(),
                week.getAvailability()
            );
        });

        Ext.Array.each(forUpdate, function(weekPair){
            me.applyWeek(weekPair[0], weekPair[1]);
        });
    },

    applyDays : function(){
        var me = this,
            store = this.getDayGrid().getStore(),
            forRemove = [], forUpdate = [], forInsert = [];

        this.calendar.each(function(day){
            var match       = /^(\d)-(\d\d\d\d\/\d\d\/\d\d)-(\d\d\d\d\/\d\d\/\d\d)$/.exec(day.getId());

            if (match) {
                return;
            }

            store.getOverrideDay(day.getDate()) == null ? forRemove.push(day) : forUpdate.push(day);
        });

        store.each(function(day) {
            if(me.calendar.getOverrideDay(day.getDate()) == null) {
                forInsert.push(day);
            }
        });

        this.calendar.remove(forRemove);
        this.calendar.add(forInsert);

        Ext.Array.each(forUpdate, function(day){
            var updatedDay = store.getOverrideDay(day.getDate());
            me.applyCalendarDay(updatedDay, day);
        });
    },

    cloneCalendarDay : function(calendarDay) {
        return Ext.create('Gnt.model.CalendarDay', {
            Date: calendarDay.getDate(),
            Id: calendarDay.getId(),
            Name: calendarDay.getName(),
            IsWorkingDay : calendarDay.getIsWorkingDay(),
            Availability : calendarDay.getAvailability()
        });
    },

    getDefaultWeekAvailability : function(){
        return this.calendar.defaultWeekAvailability;
    },

    onDestroy : function() {
        this.getWeekGrid().destroy();
        this.getDayGrid().destroy();
        this.getDatePicker().destroy();

        this.callParent(arguments);
    }
});
