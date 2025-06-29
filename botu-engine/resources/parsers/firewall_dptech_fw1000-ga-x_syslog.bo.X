botu("Firewall/DPtech/FW1000-GA-X/Syslog") {
    if (patternParse(MS_SRC_DATA, "(\\<\\d+\\>)*(?<time>.*)\\s(?<devname>[^\\s]+)\\s%%-*(?<eid>.*)/(?<module>[^:]+)/(?<sev>\\d+)/(?<logType>[^:]+):\\s*(?<detail>.*)")) {
        switch(logType){
            case "SYSLOG(l)":
                pack("event") {
                  START_TIME = format2Time(time, "MMM dd HH:mm:ss");
                  DS_DVC_NAME = devname;
                  DS_PROCESS_NAME = eid;
                  EVT_CATEGORY = logType;
                  EVT_TYPE = module;
                  SEVERITY = sev;
                  N_EVT_CATEGORY = "/Audit";
                  N_SEVERITY = dictMapping("severity",sev);
                  OUTCOME = detail;
                }
            case "OPERLOG(l)":
                inx = detail.lastIndexOf(";");
                props = subString(detail,0,inx);
                splitParse(props, ';', null, null, ":");
                outcome = subString(detail,inx + 1);
                pack("event") {
                  START_TIME = format2Time(time, "MMM dd HH:mm:ss");
                  DS_DVC_NAME = devname;
                  DS_PROCESS_NAME = eid;
                  EVT_CATEGORY = logType;
                  EVT_TYPE = module;
                  SEVERITY = sev;
                  N_EVT_CATEGORY = "/Audit";
                  N_SEVERITY = dictMapping("severity",sev);
                  SBJ_TYPE = "/User";
                  SBJ_NAME = field("user-name(85)");
                  SBJ_IP = field("host-ip(86)");
                  TECHNICAL = field("client-type(84)");
                  BHV_CATEGORY = "/Is";
                  OUTCOME = outcome;
                }
            case "DATALOG(l)":
                splitParse(detail, ';', null, null, ":");
                if(field("log-type(1)") == "attack-protect"){
                    pack("event") {
                        START_TIME = format2Time(time, "MMM dd HH:mm:ss");
                        DS_DVC_NAME = devname;
                        DS_PROCESS_NAME = eid;
                        EVT_CATEGORY = module;
                        EVT_TYPE = field("attack-name(11)");
                        SEVERITY = sev;
                        N_EVT_CATEGORY = "/Threat/Attack";
                        N_SEVERITY = dictMapping("severity",sev);
                        SBJ_TYPE = "/Ip";
                        SBJ_NAME = field("source-ip(24)");
                        SBJ_IP = field("source-ip(24)");
                        SBJ_PORT = field("source-port(25)");
                        SBJ_INTERFACE = field("ifname-inside(29)");
                        BHV_CATEGORY = "/Attack";
                        TECHNICAL = field("attack-name(11)");
                        TRANS_PROTO = dictMapping("trans_protocol",toInt(field("ip-proto-id(18)")));
                        OBJ_TYPE = "/Ip";
                        OBJ_NAME = field("destination-ip(26)");
                        OBJ_IP = field("destination-ip(26)");
                        OBJ_PORT = field("destination-port(27)");
                        PRT_ACTION = field("event(2)");
                    }
                } else if (field("log-type(1)") == "av-protect"){
                    pack("event") {
                        START_TIME = format2Time(time, "MMM dd HH:mm:ss");
                        DS_DVC_NAME = devname;
                        EVT_CATEGORY = module;
                        EVT_TYPE = field("av-name(15)");
                        SEVERITY = sev;
                        N_EVT_CATEGORY = "/Threat/Malware";
                        N_SEVERITY = dictMapping("severity",sev);
                        SBJ_TYPE = "/Ip";
                        SBJ_NAME = field("source-ip(24)");
                        SBJ_IP = field("source-ip(24)");
                        SBJ_PORT = field("source-port(25)");
                        SBJ_INTERFACE = field("ifname-inside(29)");
                        BHV_CATEGORY = "/Attack";
                        TECHNICAL = field("av-name(15)");
                        TRANS_PROTO = dictMapping("trans_protocol",toInt(field("ip-proto-id(18)")));
                        OBJ_TYPE = "/Ip";
                        OBJ_NAME = field("destination-ip(26)");
                        OBJ_IP = field("destination-ip(26)");
                        OBJ_PORT = field("destination-port(27)");
                        PRT_ACTION = event;
                        PRT_STATUS = "/Solved";
                    }
                }
            default:
                pack("event") {
                  START_TIME = format2Time(time, "MMM dd HH:mm:ss");
                  DS_DVC_NAME = devname;
                  DS_PROCESS_NAME = eid;
                  EVT_CATEGORY = logType;
                  EVT_TYPE = module;
                  SEVERITY = sev;
                  N_EVT_CATEGORY = "/Audit";
                  N_SEVERITY = dictMapping("severity",sev);
                  OUTCOME = detail;
                }
        }
    }else if(patternParse(MS_SRC_DATA,"(\\<\\d+\\>)*\\s\\d+ (?<host>[^\\s]+) (?<time>[^:]+:\\d+:\\d+ \\d+)\\s{0,}(?<devname>[^\\s]+)\\s%%-*(?<eid>[^\\s]+)\\s(?<sev>\\d+)\\s(?<logType>[^:]+):(?<action>[^\\s]+)\\s(?<detail>.*)")) {
        segs = strSplit(detail, "\\|");
        pack("event") {
            START_TIME = format2Time(time, "MMM dd HH:mm:ss");
            DS_DVC_NAME = devname;
            DS_PROCESS_NAME = eid;
            EVT_CATEGORY = logType;
            EVT_TYPE = "/Violation";
            SEVERITY = sev;
            N_EVT_CATEGORY = "/Violation";
            N_SEVERITY = dictMapping("severity",sev);
            SBJ_TYPE = "/Ip";
            SBJ_NAME = segs[1];
            SBJ_IP = segs[1];
            SBJ_PORT = segs[2];
            BHV_CATEGORY = "/Access";
            OBJ_TYPE = "/Ip";
            OBJ_NAME = segs[3];
            OBJ_IP = segs[3];
            OBJ_PORT = segs[4];
            PRT_ACTION = action;
        }
    }
}