/**
 * Copyright (c) 2013 Red Hat, Inc.
 *
 * This software is licensed to you under the GNU General Public License,
 * version 2 (GPLv2). There is NO WARRANTY for this software, express or
 * implied, including the implied warranties of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. You should have received a copy of GPLv2
 * along with this software; if not, see
 * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
 *
 * Red Hat trademarks are not licensed under GPLv2. No permission is
 * granted to use or replicate Red Hat trademarks that are incorporated
 * in this software or its documentation.
 */
package com.redhat.rhn.domain.common;

import com.redhat.rhn.common.hibernate.HibernateFactory;

import org.apache.log4j.Logger;

import java.util.HashMap;
import java.util.Map;


/**
 * LoggingFactory - contains methods for fetching and storing objects from the DB
 * related to Auditing Database Operations
 * @version $Rev$
 */
public class LoggingFactory extends HibernateFactory {

    private static LoggingFactory singleton = new LoggingFactory();
    private static Logger log = Logger.getLogger(LoggingFactory.class);

    @Override
    protected Logger getLogger() {
        return log;
    }

    /**
     * Clears the log_id record
     */
    public static void clearLogId() {
        executeCallableMode("Logging_queries", "clear_log_id", new HashMap());
    }

    /**
     * Sets the log_id record
     * @param userId user id
     */
    public static void setLogAuth(Long userId) {
        Map params = new HashMap();
        params.put("user_id", userId.intValue());
        executeCallableMode("Logging_queries", "set_log_auth", params);
    }
}
