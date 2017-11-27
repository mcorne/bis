<?php
class database extends PDO
{
    /**
     *
     * @var string
     */
    public $sql;

    /**
     *
     * @param string $dsn
     * @param string $username
     * @param string $password
     * @param string $options
     */
    public function __construct($dsn, $username = null, $password = null, $options = [])
    {
        $options += [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION];
        parent::__construct("sqlite:$dsn", null, null, $options);
    }

    /**
     *
     * @param array $data
     * @return string
     */
    public function bind_data_set($data)
    {
        $bind     = [];
        $data_set = [];

        foreach ($data as $column => $value) {
            $key        = ":_set_$column";
            $data_set[] = "$column = $key";
            $bind[$key] = $value;
        }

        $data_set = implode(', ', $data_set);

        return [$data_set, $bind];
    }

    /**
     *
     * @param array $data
     * @return array
     */
    public function bind_values($data)
    {
        $bind    = [];
        $columns = [];
        $values  = [];

        foreach ($data as $column => $value) {
            $columns[] = $column;

            $key        = ":_insert_$column";
            $values[]   = $key;
            $bind[$key] = $value;
        }

        $columns = implode(', ', $columns);
        $values  = implode(', ', $values);

        return [$columns, $values, $bind];
    }

    /**
     *
     * @param array $data
     * @param string $separator
     * @return array
     */
    public function bind_where($data = [], $separator)
    {
        $bind      = [];
        $condition = [];

        foreach ($data as $column => $value) {
            list($column, $operator) = $this->parse_column_and_value($column, $value);

            if ($operator) {
                $key         = ":_where_$column";
                $condition[] = "$column $operator $key";
                $bind[$key]  = $value;
            } else {
                $condition[] = $column;
            }
        }

        $condition = implode(" $separator ", $condition);

        return [$condition, $bind];
    }

    /**
     *
     * @param string $table
     * @param array $where
     * @param string $separator
     */
    public function delete($table, $where, $separator = 'AND') {
        list($condition, $bind) = $this->bind_where($where, $separator);

        $sql = "DELETE FROM $table WHERE $condition";
        $this->prepare($sql)->execute($bind);
    }

    /**
     *
     * @param string $sql
     * @param array $bind
     * @return array
     */
    public function fetch($sql, $bind = [])
    {
        /* @var $statement PDOStatement */
        if (! $statement = $this->prepare($sql) or ! $statement->execute($bind)) {
            throw new Exception('unexpected query error');
        }

        $row = $statement->fetch(PDO::FETCH_ASSOC);

        return $row;
    }

    /**
     *
     * @param string $sql
     * @param array $bind
     * @return array
     */
    public function fetch_all($sql, $bind = [])
    {
        /* @var $statement PDOStatement */
        if (! $statement = $this->prepare($sql) or ! $statement->execute($bind)) {
            throw new Exception('unexpected query error');
        }

        $rows = $statement->fetchAll(PDO::FETCH_ASSOC);

        return $rows;
    }

    /**
     *
     * @param string $table
     * @param array $where
     * @param array $columns
     * @param string $separator
     * @return array
     */
    public function get_row($table, $where, $columns = '*', $separator = 'AND')
    {
        if (is_array($columns)) {
            $columns = implode(', ', $columns);
        }

        $sql = "SELECT $columns FROM $table";

        if ($where) {
            list($condition, $bind) = $this->bind_where($where, $separator);
            $sql .= " WHERE $condition";
            $row  = $this->fetch($sql, $bind);
        } else {
            $row = $this->fetch($sql);
        }

        return $row;
    }

    /**
     *
     * @param string $table
     * @param array $where
     * @param array $columns
     * @param string $separator
     * @return array
     */
    public function get_rows($table, $where, $columns = '*', $separator = 'AND')
    {
        if (is_array($columns)) {
            $columns = implode(', ', $columns);
        }

        $sql = "SELECT $columns FROM $table";

        if ($where) {
            list($condition, $bind) = $this->bind_where($where, $separator);
            $sql .= " WHERE $condition";
            $row  = $this->fetch_all($sql, $bind);
        } else {
            $row = $this->fetch_all($sql);
        }

        return $row;
    }

    /**
     *
     * @param string $table
     * @param array $data
     * @return int
     */
    public function insert($table, $data)
    {
        list($columns, $values, $bind) = $this->bind_values($data);

        $sql = "INSERT INTO $table ($columns) VALUES ($values)";
        $this->prepare($sql)->execute($bind);

        $id = $this->lastInsertId();

        return $id;
    }

    /**
     *
     * @param string $column
     * @return array
     */
    public function parse_column($column)
    {
        if (preg_match('~^\w+$~', $column)) {
            // this is a column name without an operator, defaults to the equal operator
            $operator = '=';
        } elseif (preg_match('~^(\w+) *(!=|<=|>=|<|>|=|LIKE|UNLIKE)$~', $column, $match)) {
            // this is a column name followed by an operator, ex. "quantity !=" or "lastname LIKE"
            list(, $column, $operator) = $match;
        } else {
            // this is an expression
            $operator = null;
        }

        return [$column, $operator];
    }

    /**
     *
     * @param string $column
     * @param mixed $value
     * @return array
     */
    public function parse_column_and_value($column, $value)
    {
        list($column, $operator) = $this->parse_column($column);

        if (is_null($value)) {
            if ($operator == '=') {
                $column  .= " IS NULL";
                $operator = null;
            } elseif ($operator == '!=') {
                $column  .= " IS NOT NULL";
                $operator = null;
            }
        }

        return [$column, $operator];
    }

    /**
     *
     * @param string $statement
     * @param array $driver_options
     * @return PDOStatement
     */
    public function prepare($statement, $driver_options = [])
    {
        $this->sql = $statement;
        return parent::prepare($statement, $driver_options);
    }

    /**
     *
     * @param string $table
     * @param array $data
     * @param array $where
     * @param string $separator
     */
    public function update($table, $data, $where, $separator = 'AND')
    {
        list($data_set, $data_bind)   = $this->bind_data_set($data);
        list($condition, $where_bind) = $this->bind_where($where, $separator);

        $sql = "UPDATE $table SET $data_set WHERE $condition";
        $this->prepare($sql)->execute($data_bind + $where_bind);
    }
}
