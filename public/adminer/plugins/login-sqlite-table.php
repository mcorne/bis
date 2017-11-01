<?php
class AdminerLoginSqliteTable
{
    /**
     *
     * @param string $login
     * @param string $password
     * @return type
     * @see AdminerLoginSqlite in plugins/login-sqlite.php
     * @see AdminerLoginTable  in plugins/login-table.php
     */
    public function login($login, $password) {
        if (preg_match('~(^[/\\\\]|:)~', DB)) {
            $filename = DB;
        } else{
            $filename = dirname($_SERVER["SCRIPT_FILENAME"]) . '/' . DB;
        }

        $filename = q($filename);
        connection()->result("ATTACH $filename AS a");

        $login    = q($login);
        $password = q(sha1($password));

        $sql = "
            SELECT COUNT(*)
            FROM user
            JOIN role ON role.id = user.role_id
            JOIN domain_right_role AS drd ON drd.role_id = role.id AND drd.domain_id = 'database' AND drd.right_id = 'update'
            WHERE user.name = $login
            AND   user.password = $password";

        $result = (bool) connection()->result($sql);

        connection()->result('DETACH a');

        return $result;
    }

    public function loginForm() {
    ?>
    <script type="text/javascript">
    addEventListener('load', function () {
            var driver = document.getElementsByName('auth[driver]')[0];
            if (isTag(driver, 'select')) {
                    driver.onchange = function () {
                            var trs = parentTag(driver, 'table').rows;
                            var disabled = /sqlite/.test(driver.value);
                            alterClass(trs[1], 'hidden', disabled);
                            trs[1].getElementsByTagName('input')[0].disabled = disabled;
                    };
            }
            driver.onchange();
    });
    </script>
    <?php
    }

}
