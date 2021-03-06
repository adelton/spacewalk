<%@ taglib uri="http://rhn.redhat.com/rhn" prefix="rhn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
<%@ taglib uri="http://rhn.redhat.com/tags/list" prefix="rl" %>


<html>

<body>

<%@ include file="/WEB-INF/pages/common/fragments/systems/system-header.jspf" %>
    <h2>
      <rhn:icon type="header-package" />
      <bean:message key="${requestScope.header}" />
    </h2>
    <rhn:systemtimemessage server="${requestScope.system}" />

<c:set var="pageList" value="${requestScope.pageList}" />

<rl:listset name="packageListSet">
    <rhn:csrf />
    <rhn:submitted />
	<rl:list dataset="pageList"
         width="100%"
         name="packageList"
         styleclass="list"
         emptykey="packagelist.jsp.nopackages">
 			<rl:decorator name="PageSizeDecorator"/>

		  <rl:column headerkey="packagelist.jsp.packagename" bound="false"
		  	sortattr="nvre"
		  	sortable="true" filterattr="nvre">
		      <a href="/rhn/software/packages/Details.do?sid=${param.sid}&amp;id_combo=${current.idCombo}">
		        ${current.nvre}</a>
		  </rl:column>
	</rl:list>

<c:if test="${not empty requestScope.pageList}">
    <div class="form-horizontal">
        <div class="form-group">
            <label class="col-lg-3 control-label">
                <bean:message key="schedule.jsp.at"/>
            </label>
            <div class="col-lg-6">
              <jsp:include page="/WEB-INF/pages/common/fragments/date-picker.jsp">
                <jsp:param name="widget" value="date"/>
              </jsp:include>
            </div>
        </div>
        <div class="form-group">
            <div class="col-lg-offset-3 col-lg-6">
                <c:if test="${not empty requestScope.enableRemoteCommand}">
                    <rhn:require mixins="com.redhat.rhn.common.security.acl.SystemAclHandler"
                                 acl="system_feature(ftr_remote_command); client_capable(script.run)">
                        <c:choose>
                            <c:when test="${requestScope.mode == 'remove'}">
                                <input type="submit" name ="dispatch"
                                       value='<bean:message key="removeconfirm.jsp.runremotecommand"/>'/>
                            </c:when>
                            <c:when test="${requestScope.mode == 'install'}">
                                <input type="submit" name ="dispatch"
                                       value='<bean:message key="installconfirm.jsp.runremotecommand"/>'/>
                            </c:when>
                            <c:otherwise>
                                <input type="submit" name ="dispatch"
                                       value='<bean:message key="upgradeconfirm.jsp.runremotecommand"/>'/>
                            </c:otherwise>
                        </c:choose>
                    </rhn:require>
                </c:if>
                <input type="submit" name ="dispatch"
                       value='<bean:message key="installconfirm.jsp.confirm"/>'/>
                <input type="hidden" name="sid" value="${param.sid}" />
            </div>
        </div>
    </div>
    <input type="hidden" name="use_date" value="true" />
</c:if>

</rl:listset>
</body>
</html>
