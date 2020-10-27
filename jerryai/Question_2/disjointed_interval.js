class RangeList {
    constructor() {
        /* Maintains a map of allowed ranges with S depicting as start of 
         * a range and E denotes the end of the range. e.g. A range list
         * with ranges [1, 4) [10, 100) will be defined as follows:
         * Map {
         *  1 => S,
         *  4 => E,
         *  10 => S,
         *  100 => E
         * }
         */
        this.allowedRanges = new Map();

        // Enum to maintain the start and end position of a range
        this.RANGE_POSITION = {
            START: 'S',
            END: 'E'
        };
        Object.freeze(this.RANGE_POSITION);
    }

    /**
     * Adds a range to the list
     * @param {Array<number>} range - Array of two integers that specify beginning and end of range.
     */
    add(value1, value2) {
        range = [value1,value2];
        // Validating the inputs
        if (range.length !== 2) return;

        let min = range[0];
        let max = range[1];

        if (max < min || min == max) return;

        // Set start and ending points of the new range
        this.allowedRanges.set(min, this.RANGE_POSITION.START);
        this.allowedRanges.set(max, this.RANGE_POSITION.END);

        // Sort the map keys into an array in ascending order 
        let sortedRanges = Array.from(this.allowedRanges.keys()).sort(sortAscending);

        // Cleanup the map to get rid of any redundant values by iterating
        // the map and clearing the keys which are already within a range
        // i.e. between a starting point (S) and ending point (E) 
        for (let i = 1; i < sortedRanges.length - 1; i++) {
            // Get the highest value greater than or equal to the current key
            // while making sure the key wasn't already removed
            let j = i - 1;
            while (!this.allowedRanges.has(sortedRanges[j]) && j > 0) {
                j--;
            }
            let previousValue = this.allowedRanges.get(sortedRanges[j]);

            // Get the smallest value greater than or equal to the current key
            // while making sure the key wasn't already removed
            let k = i + 1;
            while (!this.allowedRanges.has(sortedRanges[k]) && k < sortedRanges.length) {
                k++;
            }
            let nextValue = this.allowedRanges.get(sortedRanges[k]);

            // Delete the key if it lies within a range
            if (previousValue === this.RANGE_POSITION.START && nextValue === this.RANGE_POSITION.END) {
                this.allowedRanges.delete(sortedRanges[i])
            }
        }
    }

    /**
     * Removes a range from the list
     * @param {Array<number>} range - Array of two integers that specify beginning and end of range.
     */
    remove(value1,value2) {
        range = [value1,value2];
        // Validating the inputs
        if (range.length !== 2) return;

        let min = range[0];
        let max = range[1];

        if (max < min || min === max) return;

        let sortedRanges = Array.from(this.allowedRanges.keys()).sort(sortAscending);
        // Delete any keys which lie in between the range to be removed
        for (let i = 0; i < sortedRanges.length; i++) {
            if (sortedRanges[i] >= min && sortedRanges[i] <= max) {
                this.allowedRanges.delete(sortedRanges[i])
            }
        }

        // Get the highest key smaller than the start of the range to be removed
        let minIndex;
        sortedRanges = Array.from(this.allowedRanges.keys()).sort(sortAscending);
        for (let i = 0; i < sortedRanges.length; i++) {
            if (sortedRanges[i] >= min) {
                minIndex = i - 1;
                break;
            }
        }

        // If minIndex is undefined (the range to be removed is out of the existing range list), set the position of the 
        // start of range to be removed to end position if the previous positino was set to start
        if (minIndex === undefined && this.allowedRanges.get(sortedRanges[sortedRanges.length - 1]) === this.RANGE_POSITION.START) {
            this.allowedRanges.set(min, this.RANGE_POSITION.END);
            return;
        }

        // if the direct previous key is an S (start of the range), end 
        // the range at the min value (beginning of the range to be removed)
        let previousValue = this.allowedRanges.get(sortedRanges[minIndex]);
        if (previousValue === this.RANGE_POSITION.START) {
            this.allowedRanges.set(min, this.RANGE_POSITION.END);
        }

        // Get the smallest key higher than the start of the range to be removed
        let maxIndex;
        sortedRanges = Array.from(this.allowedRanges.keys()).sort(sortAscending);
        for (let i = 0; i < sortedRanges.length; i++) {
            if (sortedRanges[i] >= max) {
                maxIndex = i;
                break;
            }
        }

        // if the direct next key is an E (start of the range), start 
        // the range at the max value (end of the range to be removed)
        let nextValue = this.allowedRanges.get(sortedRanges[maxIndex]);
        if (nextValue === this.RANGE_POSITION.END) {
            this.allowedRanges.set(max, this.RANGE_POSITION.START);
        }
    }

    /**
     * Prints out the list of ranges in the range list
     */
    print() {
        let sortedRanges = Array.from(this.allowedRanges.keys()).sort(sortAscending);

        let output = new Array();
        for (let i = 0; i < sortedRanges.length; i = i + 2) {
            output.push(`[${sortedRanges[i]}, ${sortedRanges[i + 1]})`)
        }

        if (output.length === 0) {
            console.log("EMPTY_RANGE");
            return;
        }
        console.log(output.join(" "));
    }
    
}

function sortAscending(a, b) {
    return a - b;
}
// Example run
const rl = new RangeList();

rl.add(1, 5);
rl.print();
rl.remove(2, 3);//[[1, 2], [3, 5]]
rl.print();
rl.add(6, 8); //[[1, 2], [3, 5], [6, 8]] 
rl.print();
rl.remove(4, 7); //[[1, 2], [3, 4], [7, 8]] 
rl.print();
rl.add(2, 7); //[[1, 8]]
rl.print();


