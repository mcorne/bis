<?php
class AdminerEditForeignEnhanced {
	var $_limit;

	function __construct($limit = 0) {
		$this->_limit = $limit;
	}

	function editInput($table, $field, $attrs, $value) {
		static $foreignTables = array();
		static $values = array();
		$foreignKeys = &$foreignTables[$table];
		if ($foreignKeys === null) {
			$foreignKeys = column_foreign_keys($table);
		}
		foreach ((array) $foreignKeys[$field["field"]] as $foreignKey) {
			if (count($foreignKey["source"]) == 1) {
				$target = $foreignKey["table"];
				$id = $foreignKey["target"][0];
				$options = &$values[$target][$id];
				if (!$options) {
					$column = idf_escape($id);
					if (preg_match('~binary~', $field["type"])) {
						$column = "HEX($column)";
					}

                                        // (CUSTOMIZATION) only adds the empty option if the null value is allowed
                                        $options = $field["null"] ? array("" => "") : array();
                                        $options += get_vals("SELECT $column FROM " . table($target) . " ORDER BY 1" . ($this->_limit ? " LIMIT " . ($this->_limit + 1) : ""));

                                        if ($this->_limit && count($options) - 1 > $this->_limit) {
						return;
					}
				}
				return "<select$attrs>" . optionlist($options, $value) . "</select>";
			}
		}
	}

}
