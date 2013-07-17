<?php

// This doc comment block generated by idl/sysdoc.php
/**
 * ( excerpt from http://php.net/manual/en/class.traversable.php )
 *
 * Interface to detect if a class is traversable using foreach.
 *
 * Abstract base interface that cannot be implemented alone. Instead it
 * must be implemented by either IteratorAggregate or Iterator.
 *
 * Internal (built-in) classes that implement this interface can be used
 * in a foreach construct and do not need to implement IteratorAggregate or
 * Iterator.
 *
 * This is an internal engine interface which cannot be implemented in PHP
 * scripts. Either IteratorAggregate or Iterator must be used instead. When
 * implementing an interface which extends Traversable, make sure to list
 * IteratorAggregate or Iterator before its name in the implements clause.
 *
 */
interface Traversable {
}

interface KeyedTraversable extends Traversable {
}
