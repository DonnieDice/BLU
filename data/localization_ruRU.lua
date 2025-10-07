-- =====================================================================================
-- BLU | Better Level-Up! - localization.lua
-- =====================================================================================
-- Localization in Debug Messages and Non-Debug Messages

-- 1. Debug Messages:
-- PrintDebugMessage automatically looks up keys from BLU.L, 
-- so you don't need to prefix with BLU.L.
-- Example:
-- self:PrintDebugMessage("ERROR_SOUND_NOT_FOUND", tostring(event.soundSelectKey))

-- 2. Non-Debug Messages:
-- Direct print() statements require explicit BLU.L references 
-- since there's no automatic lookup.
-- Example:
-- print(BLU_PREFIX .. BLU.L["UNKNOWN_SLASH_COMMAND"])

-- Debug handling is automatic, non-debug messages need explicit localization references.

BLU = BLU or {}  -- Ensure BLU is defined
BLU_L = BLU_L or {}  -- Ensure the localization table exists

local colors = {
    prefix = "|cff05dffa",      -- BLU Prefix Color
    debug = "|cff808080",       -- Debug Prefix Color
    success = "|cff00ff00",     -- Success/Enabled/Positive Color
    error = "|cffff0000",       -- Error/Disabled/Negative Color
    highlight = "|cff8080ff",   -- Highlighted Text Color
    info = "|cffffff00",        -- Information/Warning Color
    test = "|cffc586c0",        -- Test Message Color
    sound = "|cffce9178",       -- Sound File Path Color
    white = "|cffffffff",       -- White Color
    warning = "|cffffcc00"      -- Warning Color
}

BLU_PREFIX = string.format("|Tinterface/addons/blu/images/icon:16:16|t - [%sBLU|r] ", colors.prefix)
DEBUG_PREFIX = string.format("[%sОТЛАДКА|r] ", colors.debug)
-- Translator ZamestoTV
-- =====================================================================================
-- Localization Strings
-- =====================================================================================

BLU_L = {
    -- Option Colors (Cycle with Color Alternation)
    optionColor1 = colors.prefix,
    optionColor2 = colors.white,

    -- Option Labels and Descriptions
    OPTIONS_PANEL_TITLE = string.format("|Tinterface/addons/blu/images/icon:16:16|t - %sBLU|r %s|| %sB|r%setter %sL|r%sevel-%sU|r%sp!",
        colors.prefix, colors.white, colors.prefix, colors.white, colors.prefix, colors.white, colors.prefix, colors.white),

    -- Profiles
    PROFILES_TITLE = "Профили",

-- =====================================================================================
-- Localization for initialization.lua
-- =====================================================================================
    
    -- BLU:GetGameVersion()
    ERROR_UNKNOWN_GAME_VERSION = string.format("%sНеизвестная версия игры обнаружена.|r", colors.error),

    -- BLU:OnInitialize()
    WELCOME_MESSAGE = string.format("Добро пожаловать! Используйте %s/blu|r для открытия панели настроек или %s/blu help|r для дополнительных команд.", colors.prefix, colors.prefix),
    VERSION = string.format("%sВерсия:|r", "|cffffff00"),

    -- BLU:InitializeOptions()
    ERROR_OPTIONS_NOT_INITIALIZED = string.format("%sНастройки не инициализированы должным образом.|r", colors.error),
    SKIPPING_GROUP_NOT_COMPATIBLE = string.format("Несовместимая или неназванная группа настроек", colors.error),
    OPTIONS_LIST_MENU_TITLE = string.format("|Tinterface/addons/blu/images/icon:16:16|t - %sB|r%setter %sL|r%sevel-%sU|r%sp!",
        colors.prefix, colors.white, colors.prefix, colors.white, colors.prefix, colors.white),
    OPTIONS_ALREADY_REGISTERED = "Настройки уже зарегистрированы.",

-- =====================================================================================
-- Localization for utils.lua
-- =====================================================================================

    --BLU:ProcessEventQueue()
    ERROR_SOUND_NOT_FOUND = string.format("%sЗвук не найден для ID звука: %%s.|r", colors.error, colors.highlight),
    INVALID_VOLUME_LEVEL = string.format("%sНедопустимый уровень громкости: %%d.|r", colors.error, colors.highlight),
    DEBUG_MESSAGE_MISSING = string.format("%sОтладочное сообщение отсутствует для события.|r", colors.warning, colors.highlight),
    FUNCTIONS_HALTED = string.format("%sФункции остановлены.|r", colors.error, colors.highlight),

    -- BLU:HaltOperations()
    COUNTDOWN_TICK = string.format("%sОбратный отсчет: %s%%d%s секунд осталось.|r", colors.info, colors.highlight, colors.info),

    -- BLU:HandleSlashCommands(input)
    OPTIONS_PANEL_OPENED = string.format("Панель настроек %sоткрыта|r.", colors.success),
    UNKNOWN_SLASH_COMMAND = string.format("Неизвестная слэш-команда: %%s.|r", colors.highlight),

    -- BLU:DisplayBLUHelp()
    HELP_COMMAND = string.format("%sДоступные команды:", "|cffffff00"),
    HELP_DEBUG = " " .. colors.prefix .. "/blu debug|r - Переключить режим отладки.",
    HELP_WELCOME = " " .. colors.prefix .. "/blu welcome|r - Включить/выключить приветственное сообщение.",
    HELP_PANEL = " " .. colors.prefix .. "/blu|r - Открыть панель настроек.",

    -- BLU:ToggleDebugMode()
    DEBUG_MODE_ENABLED = string.format("%sРежим отладки включен|r", colors.success),
    DEBUG_MODE_DISABLED = string.format("%sРежим отладки выключен|r", colors.error),
    DEBUG_MODE_TOGGLED = string.format("Режим отладки переключен: %s%%s|r.", colors.highlight),
   
    -- BLU:ToggleWelcomeMessage()
    WELCOME_MSG_ENABLED = string.format("Приветственное сообщение %sвключено|r.", colors.success),
    WELCOME_MSG_DISABLED = string.format("Приветственное сообщение %sвыключено|r.", colors.error),
    SHOW_WELCOME_MESSAGE_TOGGLED = string.format("Приветственное сообщение переключено: %s%%s|r.", colors.highlight),
    CURRENT_DB_SETTING = string.format("Текущая настройка БД: %%s.|r", colors.info),

    -- BLU:RandomSoundID()
    SELECTING_RANDOM_SOUND = "Выбор случайного SoundID",
    NO_VALID_SOUND_IDS = string.format("Действительные ID звуков не найдены.", colors.error),
    RANDOM_SOUND_ID_SELECTED = "Выбран случайный ID звука: %s.",

    -- BLU:SelectSound()
    SELECTING_SOUND = "Выбор звука с ID: %s.",
    USING_RANDOM_SOUND_ID = "Использование случайного ID звука: %s.",
    USING_SPECIFIED_SOUND_ID = "Использование указанного ID звука: %s.",

    -- PlaySelectedSound()
    PLAYING_SOUND = "Воспроизведение звука с ID: |cff8080ff%s|r и уровнем громкости: |cff8080ff%d|r.",
    VOLUME_LEVEL_ZERO = string.format("%sУровень громкости %s0|r, звук не воспроизведен.|r", colors.error, colors.highlight),
    SOUND_FILE_TO_PLAY = "Звуковой файл для воспроизведения: %s.",

-- =====================================================================================
-- Localization for core.lua
-- =====================================================================================

    -- BLU:HandlePlayerLevelUp()
    PLAYER_LEVEL_UP_TRIGGERED = string.format("%sPLAYER_LEVEL_UP|r %sсработал.|r", colors.info, colors.test),

    -- BLU:HandleQuestAccepted()
    QUEST_ACCEPTED_TRIGGERED = string.format("%sQUEST_ACCEPTED|r %sсработал.|r", colors.info, colors.test),

    -- BLU:HandleQuestTurnedIn()
    QUEST_TURNED_IN_TRIGGERED = string.format("%sQUEST_TURNED_IN|r %sсработал.|r", colors.info, colors.test),

    -- BLU:HandleAchievementEarned()
    ACHIEVEMENT_EARNED_TRIGGERED = string.format("%sACHIEVEMENT_EARNED|r %sсработал.|r", colors.info, colors.test),

    -- BLU:HandleHonorLevelUpdate()
    HONOR_LEVEL_UPDATE_TRIGGERED = string.format("%sHONOR_LEVEL_UPDATE|r %sсработал.|r", colors.info, colors.test),

    -- BLU:HandleRenownLevelChanged()
    MAJOR_FACTION_RENOWN_LEVEL_CHANGED_TRIGGERED = string.format("%sMAJOR_FACTION_RENOWN_LEVEL_CHANGED|r %sсработал.|r", colors.info, colors.test),

    -- BLU:HandlePerksActivityCompleted()
    PERKS_ACTIVITY_COMPLETED_TRIGGERED = string.format("%sPERKS_ACTIVITY_COMPLETED|r %sсработал.|r", colors.info, colors.test),

    -- =====================================================================================

    -- BLU:TestAchievementSound()
    TEST_ACHIEVEMENT_SOUND = string.format("%sTestAchievementSound|r %sсработал.|r", colors.info, colors.test),
    
    -- BLU:TestBattlePetLevelSound()
    TEST_BATTLE_PET_LEVEL_SOUND = string.format("%sTestBattlePetLevelSound|r %sсработал.|r", colors.info, colors.test),
    
    -- BLU:TestDelveLevelUpSound()
    TEST_DELVE_LEVEL_UP_SOUND = string.format("%sTestDelveLevelUpSound|r %sсработал.|r", colors.info, colors.test),
   
    -- BLU:TestHonorSound()
    TEST_HONOR_SOUND = string.format("%sTestHonorSound|r %sсработал.|r", colors.info, colors.test),
    
    -- BLU:TestLevelSound()
    TEST_LEVEL_SOUND = string.format("%sTestLevelSound|r %sсработал.|r", colors.info, colors.test),
    
    -- BLU:TestPostSound()
    TEST_POST_SOUND = string.format("%sTestPostSound|r %sсработал.|r", colors.info, colors.test),
   
    -- BLU:TestQuestAcceptSound()
    TEST_QUEST_ACCEPT_SOUND = string.format("%sTestQuestAcceptSound|r %sсработал.|r", colors.info, colors.test),
  
    -- BLU:TestQuestSound()
    TEST_QUEST_SOUND = string.format("%sTestQuestSound|r %sсработал.|r", colors.info, colors.test),
    
    -- BLU:TestRenownSound()
    TEST_RENOWN_SOUND = string.format("%sTestRenownSound|r %sсработал.|r", colors.info, colors.test),
    
    -- BLU:TestRepSound()
    TEST_REP_SOUND = string.format("%sTestRepSound|r %sсработал.|r", colors.info, colors.test),

    -- =====================================================================================

    -- BLU:ReputationChatFrameHook()
    INCOMING_CHAT_MESSAGE = string.format("%sВходящее сообщение в чате: %%s|r", colors.highlight),
    NO_RANK_FOUND = string.format("%sПовышение репутации не найдено в сообщении чата.|r", colors.error),
    FUNCTIONS_HALTED = string.format("%sФункции остановлены. Событие не обработано.|r", colors.info),

    -- BLU:ReputationRankIncrease()
    REPUTATION_RANK_TRIGGERED = string.format("Сработало повышение ранга репутации для ранга: ", colors.info),

    -- BLU:OnDelveCompantionLevelUp(event, ...)
    DELVE_LEVEL_UP = string.format("%sБранн Бронзобород достиг уровня %%s|r", colors.info),
    NO_BRANN_LEVEL_FOUND = string.format("%sУровень в Подземелье не найден в сообщении чата.|r", colors.error),
    
    -- BLU:TriggerDelveLevelUpSound(level)
    DELVE_LEVEL_UP_SOUND_TRIGGERED = string.format("Звук повышения уровня в Подземелье сработал для уровня ", colors.info),

    -- Метки и описания для настроек громкости
    ACHIEVEMENT_EARNED = "Достижение получено!",
    ACHIEVEMENT_VOLUME_LABEL = "Громкость достижения",
    ACHIEVEMENT_VOLUME_DESC = "Настройте громкость звука для события Достижение получено!",

    BATTLE_PET_LEVEL_UP = "Повышение уровня боевого питомца!",
    BATTLE_PET_VOLUME_LABEL = "Громкость боевого питомца",
    BATTLE_PET_VOLUME_DESC = "Настройте громкость звука для события Повышение уровня боевого питомца!",

    DELVE_COMPANION_LEVEL_UP = "Повышение уровня спутника в Подземелье!",
    DELVE_VOLUME_LABEL = "Громкость Подземелья",
    DELVE_VOLUME_DESC = "Настройте громкость звука для события Повышение уровня в Подземелье!",

    HONOR_RANK_UP = "Повышение ранга чести!",
    HONOR_VOLUME_LABEL = "Громкость чести",
    HONOR_VOLUME_DESC = "Настройте громкость звука для события Повышение ранга чести!",

    LEVEL_UP = "Повышение уровня!",
    LEVEL_VOLUME_LABEL = "Громкость повышения уровня",
    LEVEL_VOLUME_DESC = "Настройте громкость звука для события Повышение уровня!",

    QUEST_ACCEPTED = "Задание принято!",
    QUEST_ACCEPT_VOLUME_LABEL = "Громкость принятия задания",
    QUEST_ACCEPT_VOLUME_DESC = "Настройте громкость звука для события Задание принято!",
    QUEST_COMPLETE = "Задание завершено!",
    QUEST_COMPLETE_VOLUME_LABEL = "Громкость завершения задания",
    QUEST_COMPLETE_VOLUME_DESC = "Настройте громкость звука для события Задание завершено!",

    RENOWN_RANK_UP = "Повышение уровня известности!",
    RENOWN_VOLUME_LABEL = "Громкость известности",
    RENOWN_VOLUME_DESC = "Настройте громкость звука для события Повышение уровня известности!",

    REPUTATION_RANK_UP = "Повышение ранга репутации!",
    REP_VOLUME_LABEL = "Громкость репутации",
    REP_VOLUME_DESC = "Настройте громкость звука для события Повышение ранга репутации!",

    TRADE_POST_ACTIVITY_COMPLETE = "Активность торгового поста завершена!",
    POST_VOLUME_LABEL = "Громкость торгового поста",
    POST_VOLUME_DESC = "Настройте громкость звука для события Активность торгового поста завершена!",
-- =====================================================================================
-- Localization for battlepets.lua
-- =====================================================================================

    -- BLU:HandlePetLevelUp()
    INVALID_PET_LEVEL = string.format("%sНедопустимый petID или текущий уровень. PetID: %%s, Уровень: %%s|r", colors.error),
    UNKNOWN_PET = string.format("%sНеизвестный питомец", colors.error),   

    -- BLU:HandlePetLevelUp()
    PET_LEVEL_UP_TRIGGERED = string.format("%sПовышение уровня питомца сработало для %s%%s%s на уровне %s%%d%s.|r",
        colors.info, colors.highlight, colors.white, colors.highlight, colors.white),

    -- BLU:UpdatePetData()
    NO_PETS_FOUND = string.format("%sПитомцы не найдены, обновление данных питомцев пропущено.|r", colors.info),
    INIT_LOAD_COMPLETE = string.format("%sОтслеживание уровней питомцев инициализировано при входе в игру.|r", colors.info),
}
