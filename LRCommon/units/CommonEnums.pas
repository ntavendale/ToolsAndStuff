unit CommonEnums;

interface

type
  TComponentType = (UNKNOWN = -1, MEDIATOR = 0, MPE, ARM, AGENT, MSGSOURCE,
                    HARMONYDATAPROVIDER, HARMONYDATARECEIVER, HARMONYSERVER,
                    JOBMANAGER, CONSOLE, LRDEMO, WEBSERVICES,  AIENGINE);

  TComponentServiceRequestType = (INVALID = -1, CONFIG = 0, STOP, START,
                                  RESTART, UPGRADE);

implementation

end.
