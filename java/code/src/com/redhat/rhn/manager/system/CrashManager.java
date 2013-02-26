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

package com.redhat.rhn.manager.system;

import com.redhat.rhn.common.conf.Config;
import com.redhat.rhn.common.hibernate.LookupException;
import com.redhat.rhn.domain.server.Crash;
import com.redhat.rhn.domain.server.CrashFactory;
import com.redhat.rhn.domain.server.CrashFile;
import com.redhat.rhn.domain.server.Server;
import com.redhat.rhn.domain.user.User;
import com.redhat.rhn.frontend.xmlrpc.NoSuchCrashException;
import com.redhat.rhn.frontend.xmlrpc.NoSuchSystemException;
import com.redhat.rhn.manager.BaseManager;

import java.io.File;

import org.apache.log4j.Logger;

/**
 * CrashManager
 * @version $Rev$
 */
public class CrashManager extends BaseManager {

    private static Logger log = Logger.getLogger(CrashManager.class);

    /**
     * Lookup Crash by its ID and User.
     * @param user User to check the permissions for.
     * @param crashId ID of the crash to search for.
     * @return The crash for given ID.
     */
    public static Crash lookupCrashByUserAndId(User user, Long crashId) {
        Crash crash = CrashFactory.lookupById(crashId);
        if (crash == null) {
            throw new NoSuchCrashException();
        }

        Long serverId = crash.getServer().getId();

        Server server = null;
        try {
            server = SystemManager.lookupByIdAndUser(new Long(serverId.longValue()), user);
        }
        catch (LookupException e) {
            throw new NoSuchSystemException();
        }

        return crash;
    }

    /**
     * Delete a crash from database and filer.
     * @param user User to check the permissions for.
     * @param crashId The id of the crash to delete.
     */
    public static void deleteCrash(User user, Long crashId) {
        Crash crash = lookupCrashByUserAndId(user, crashId);

        // FIXME: async deletion via taskomatic?
        File storageDir = new File(Config.get().getString("web.mount_point"),
                                   crash.getStoragePath());

        for (CrashFile cf : crash.getCrashFiles()) {
            File crashFile = new File(storageDir, cf.getFilename());
            if (crashFile.exists() && crashFile.isFile()) {
                crashFile.delete();
            }
        }
        storageDir.delete();

        CrashFactory.delete(crash);
    }
}