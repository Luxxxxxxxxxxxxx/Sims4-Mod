
global function InitAudioMenu

struct
{
	var menu
	table<var,string> buttonDescriptions
	var classicMusicSwitch
} file

void function InitAudioMenu()
{
	var menu = GetMenu( "AudioMenu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenAudioMenu )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCloseAudioMenu )

	SetupButton( Hud_GetChild( menu, "SwchSpeakerConfig" ), "#WINDOWS_AUDIO_CONFIGURATION", "" )
	SetupButton( Hud_GetChild( Hud_GetChild( menu, "SldMasterVolume" ), "BtnDropButton" ), "#MASTER_VOLUME", "#OPTIONS_MENU_MASTER_VOLUME_DESC" )
	SetupButton( Hud_GetChild( Hud_GetChild( menu, "SldDialogueVolume" ), "BtnDropButton" ), "#MENU_DIALOGUE_VOLUME_CLASSIC", "#OPTIONS_MENU_DIALOGUE_VOLUME_DESC" )
	SetupButton( Hud_GetChild( Hud_GetChild( menu, "SldSFXVolume" ), "BtnDropButton" ), "#MENU_SFX_VOLUME_CLASSIC", "#OPTIONS_MENU_SFX_VOLUME_DESC" )
	SetupButton( Hud_GetChild( Hud_GetChild( menu, "SldMusicVolume" ), "BtnDropButton" ), "#MENU_MUSIC_VOLUME_CLASSIC", "#OPTIONS_MENU_MUSIC_VOLUME_DESC" )
	SetupButton( Hud_GetChild( Hud_GetChild( menu, "SldLobbyMusicVolume" ), "BtnDropButton" ), "#MENU_LOBBY_MUSIC_VOLUME", "#OPTIONS_MENU_LOBBY_MUSIC_VOLUME_DESC" )
	SetupButton( Hud_GetChild( Hud_GetChild( menu, "SldVoiceChatVolume" ), "BtnDropButton" ), "#VOICE_CHAT_VOLUME", "#OPTIONS_MENU_VOICE_CHAT_DESC" )
	SetupButton( Hud_GetChild( Hud_GetChild( menu, "SldLoadFadeTime" ), "BtnDropButton" ), "Loading Fade Time", "Seconds of fade time when beginning a level." )
	SetupButton( Hud_GetChild( Hud_GetChild( menu, "SldLoadSilenceTime" ), "BtnDropButton" ), "Load Silence Time", "Seconds of silence before fade time when beginning a level." )
	SetupButton( Hud_GetChild( menu, "SwchSubtitles" ), "#SUBTITLES", "#OPTIONS_MENU_SUBTITLES_DESC" )
	SetupButton( Hud_GetChild( menu, "SwchCalculateOcclusion" ), "#CALCULATE_OCCLUSION", "#OPTIONS_MENU_CALCULATE_OCCLUSION_DESC" )
	SetupButton( Hud_GetChild( menu, "SwchSoundWithoutFocus" ), "#SOUND_WITHOUT_FOCUS", "#OPTIONS_MENU_SOUND_WITHOUT_FOCUS" )

	file.classicMusicSwitch = Hud_GetChild( menu, "SwchSoundClassicMusic" )
	SetupButton( file.classicMusicSwitch, "#SOUND_CLASSIC_MUSIC", "#OPTIONS_MENU_SOUND_CLASSIC_MUSIC" )
	Hud_AddEventHandler( file.classicMusicSwitch, UIE_CHANGE, ClassicMusic_OnChange )

	AddEventHandlerToButtonClass( menu, "RuiFooterButtonClass", UIE_GET_FOCUS, FooterButton_Focused )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function OnOpenAudioMenu()
{
	UI_SetPresentationType( ePresentationType.NO_MODELS )

	bool classicMusicAvailable = IsClassicMusicAvailable()
	if ( classicMusicAvailable )
		file.buttonDescriptions[ file.classicMusicSwitch ] <- "#OPTIONS_MENU_SOUND_CLASSIC_MUSIC"
	else
		file.buttonDescriptions[ file.classicMusicSwitch ] <- "#OPTIONS_MENU_SOUND_CLASSIC_MUSIC_LOCKED"

	Hud_SetLocked( file.classicMusicSwitch, !classicMusicAvailable )
	//Hud_SetEnabled( file.classicMusicSwitch, classicMusicAvailable )
}

void function OnCloseAudioMenu()
{
	SavePlayerSettings()
}

void function SetupButton( var button, string buttonText, string description )
{
	SetButtonRuiText( button, buttonText )
	file.buttonDescriptions[ button ] <- description
	AddButtonEventHandler( button, UIE_GET_FOCUS, Button_Focused )
}

void function Button_Focused( var button )
{
	string description = file.buttonDescriptions[ button ]
	SetElementsTextByClassname( file.menu, "MenuItemDescriptionClass", description )
}

void function FooterButton_Focused( var button )
{
	SetElementsTextByClassname( file.menu, "MenuItemDescriptionClass", "" )
}
