let PLUGIN_INFO =
<VimperatorPlugin>
<name>fms_switcher</name>
<description>This script allows you to switch FireMobileSimulator status with Vimp CLI.</description>
<version>1.0.1</version>
<author>zentooo</author>
<license>Creative Commons</license>
<detail><![CDATA[
    == Subject ==
    This script allows you to switch FireMobileSimulator status from Vimperator CLI.

    == Commands ==
    :fms off:
        turn off FireMobileSimulator's mobile emulation.
    :fms [deviceName] [uid(optional)]:
        turn on FireMobileSimulator's mobile emulation with given deviceName.
        If uid given, change the uid configuration of that carrier.
]]></detail>
</VimperatorPlugin>;


liberator.modules.commands.addUserCommand(
  ["fms"],
  "Switch FireMobileSimulator status",
  function(args) {
    var deviceName = args[0];
    var uid = args[1];

    if (deviceName == "off") {
      firemobilesimulator.core.resetDevice();
      liberator.execute("reload");
      liberator.echo("FireMobileSimulator disabled");
      return;
    }

    var deviceList = firemobilesimulator.common.pref.getListPref("msim.devicelist", ["label", "carrier"]);
    var deviceIndex = deviceList.map(function(item) { return item.label } ).indexOf(deviceName);
    var carrier = deviceList[deviceIndex].carrier;

    var resultString = "Switched device to " + deviceName;

    if ( deviceIndex != -1 ) {
      firemobilesimulator.core.setDevice(deviceIndex + 1);

      if ( typeof uid !== "undefined" ) {
        firemobilesimulator.common.pref.setUnicharPref("msim.config." + carrier + ".uid", uid);

        if ( carrier === "DC" ) {
          firemobilesimulator.common.pref.setUnicharPref("msim.config." + carrier + ".guid", uid);
        }

        resultString += ", uid = " + uid;
      }
    }
    else {
      liberator.echoerr('Unsupported fms command: ' + deviceName);
    }

    liberator.execute("reload");
    liberator.echo(resultString);
  },
  {
    completer: function(context, arg) {
      context.title = ["Option", "User Agent"];

      var suggestions = firemobilesimulator.common.pref.getListPref("msim.devicelist", ["label", "useragent"]).map(function(item) { return [item.label, item.useragent]; });

      suggestions.push(["off", "disable FireMobileSimulator"]);

      context.completions = suggestions;
    }
  }
);
