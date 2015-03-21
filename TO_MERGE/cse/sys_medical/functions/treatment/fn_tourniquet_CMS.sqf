/**
 * fn_tourniquet_CMS.sqf
 * @Descr: N/A
 * @Author: Glowbal
 *
 * @Arguments: []
 * @Return:
 * @PublicAPI: false
 */


private ["_caller","_unit","_part","_selectionName","_removeItem", "_tourniquets", "_continue"];
_unit = _this select 0;
_caller = _this select 1;
_selectionName = _this select 2;
_removeItem = _this select 3;
[_caller,"You attempt to apply a tourniquet"] call cse_fnc_sendHintTo;

if (call cse_fnc_isSetTreatmentMutex_CMS) exitwith {};
[_caller,"set"] call cse_fnc_treatmentMutex_CMS;
if (!([_caller, _unit, _removeItem] call cse_fnc_hasEquipment_CMS)) exitwith { [_caller,"release"] call cse_fnc_treatmentMutex_CMS; };

_part =	[_selectionName] call cse_fnc_getBodyPartNumber_CMS;
if (_part == 0 || _part == 1) exitwith {
	[_caller,"release"] call cse_fnc_treatmentMutex_CMS;
	[_caller,"You cannot apply a CAT on this body part!"] call cse_fnc_sendHintTo;
};

_tourniquets = [_unit,"cse_tourniquets"] call cse_fnc_getVariable;
if ((_tourniquets select _part) >0) exitwith {
	[_caller,"release"] call cse_fnc_treatmentMutex_CMS;
	[_caller,"There is already a tourniquet on this body part!"] call cse_fnc_sendHintTo;
};

if (vehicle _caller == _caller && (vehicle _unit == _unit) && !(stance _caller == "PRONE")) then {
	[_caller,"AinvPknlMstpSlayWrflDnon_medic"] call cse_fnc_localAnim;
};
CSE_ORIGINAL_POSITION_PLAYER_CMS = getPos _caller;
if !([5,{((vehicle player != player) ||((getPos player) distance CSE_ORIGINAL_POSITION_PLAYER_CMS) < 1)}, {},{hint "Action aborted. You moved away";}] call cse_fnc_gui_loadingBar) exitwith {
	[_caller,"release"] call cse_fnc_treatmentMutex_CMS;
};
["Now uses the magazine"] call cse_fnc_debug;
[_caller, _unit,_removeItem] call cse_fnc_useEquipment_CMS;

[_this, "cse_fnc_tourniquetLocal_CMS", _unit, false] spawn BIS_fnc_MP;
[_caller,"release"] call cse_fnc_treatmentMutex_CMS;
true