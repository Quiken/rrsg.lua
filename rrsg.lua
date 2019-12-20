script_name('RRSG') 
script_version('1.5') 
script_author('Norton')
require 'lib.moonloader'
require 'lib.sampfuncs'

local limgui, imgui = pcall(require, 'imgui')
local encoding = require 'encoding'
local key = require "vkeys"
local events = require "lib.samp.events"
local configuration = require "inicfg"
local sf = require 'sampfuncs'
local sp = require 'lib.samp.events'
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local tag = "[Enc. Channel]:"
local mainIni = inicfg.load(nil, directIni)
local directIni = "rrsg\\settings.ini"
--local stateIni = inicfg.save(mainIni, directIni)

local main_window_state = imgui.ImBool(false)
local commandi = imgui.ImBool(false)
local stajer = imgui.ImBool(false)
local pozivnie = imgui.ImBool(false)
local kodi = imgui.ImBool(false)
local protokol = imgui.ImBool(false)
local rpmenu = imgui.ImBool(false)
local reanie = imgui.ImBool(false)
local nastr = imgui.ImBool(false)
function apply_custom_style()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4

	style.WindowRounding = 2.0
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	style.ChildWindowRounding = 2.0
	style.FrameRounding = 2.0
	style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
	style.ScrollbarSize = 13.0
	style.ScrollbarRounding = 0
	style.GrabMinSize = 8.0
	style.GrabRounding = 1.0

	colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
	colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
	colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
	colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
	colors[clr.ComboBg]                = colors[clr.PopupBg]
	colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
	colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.FrameBg]                = ImVec4(0.16, 0.29, 0.48, 0.54)
	colors[clr.FrameBgHovered]         = ImVec4(0.26, 0.59, 0.98, 0.40)
	colors[clr.FrameBgActive]          = ImVec4(0.26, 0.59, 0.98, 0.67)
	colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
	colors[clr.TitleBgActive]          = ImVec4(0.16, 0.29, 0.48, 1.00)
	colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
	colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
	colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
	colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
	colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
	colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
	colors[clr.CheckMark]              = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.SliderGrab]             = ImVec4(0.24, 0.52, 0.88, 1.00)
	colors[clr.SliderGrabActive]       = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.Button]                 = ImVec4(0.26, 0.59, 0.98, 0.40)
	colors[clr.ButtonHovered]          = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.ButtonActive]           = ImVec4(0.06, 0.53, 0.98, 1.00)
	colors[clr.Header]                 = ImVec4(0.26, 0.59, 0.98, 0.31)
	colors[clr.HeaderHovered]          = ImVec4(0.26, 0.59, 0.98, 0.80)
	colors[clr.HeaderActive]           = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.Separator]              = colors[clr.Border]
	colors[clr.SeparatorHovered]       = ImVec4(0.26, 0.59, 0.98, 0.78)
	colors[clr.SeparatorActive]        = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.ResizeGrip]             = ImVec4(0.26, 0.59, 0.98, 0.25)
	colors[clr.ResizeGripHovered]      = ImVec4(0.26, 0.59, 0.98, 0.67)
	colors[clr.ResizeGripActive]       = ImVec4(0.26, 0.59, 0.98, 0.95)
	colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
	colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
	colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
	colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
	colors[clr.TextSelectedBg]         = ImVec4(0.26, 0.59, 0.98, 0.35)
	colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end

function update()
  local fpath = os.getenv('TEMP') .. '\\uuupdate.json'
  downloadUrlToFile('https://raw.githubusercontent.com/Quiken/uupdate.json/master/uupdate.json', fpath, function(id, status, p1, p2)
    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
    local f = io.open(fpath, 'r')
    if f then
      local info = decodeJson(f:read('*a'))
      updatelink = info.updateurl
      if info and info.latest then
        version = tonumber(info.latest)
        if version > tonumber(thisScript().version) then
          lua_thread.create(goupdate
        else
          update = false
          sampAddChatMessage(('[Testing]: У вас и так последняя версия! Обновление отменено'), -1)
        end
      end
    end
  end
end)
end

function goupdate()
sampAddChatMessage(('[Testing]: Обнаружено обновление. AutoReload может конфликтовать. Обновляюсь...'), -1)
sampAddChatMessage(('[Testing]: Текущая версия: '..thisScript().version..". Новая версия: "..version), -1)
wait(300)
downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23) -- качает ваш файлик с latest version
  if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
  sampAddChatMessage(('[Testing]: Обновление завершено!'), -1)
  thisScript():reload()
end
end)
end


function imgui.OnDrawFrame()

if rpmenu.v then
    imgui.ShowCursor = true
    local x, y = getScreenResolution()
    local btn_size = imgui.ImVec2(-0.1, 0)  
    imgui.SetNextWindowPos(imgui.ImVec2(x/2, y/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(400, 300), imgui.Cond.FirstUseEver) 
    imgui.Begin(u8('RRSG LSPD | Отыгровки'), rpmenu, imgui.WindowFlags.NoResize)
    if imgui.Button(u8'Перекур (52 секунды)', btn_size) then rpmenu.v = false
	lua_thread.create(function()
		sampAddChatMessage(' [RRSG LSPD]{ffffff} Старт отыгровки. Для отмены нажмите CTRL + R.', 0xae433d)
		wait(100)
		sampSendChat("/me сунул руку в карман подсумка, затем достал пачку сигарет RedWood и спички")
        wait(7000)
        sampSendChat("/me достал зубами сигарету из пачки, затем подкурил ее спичками")
        wait(5000)
        sampSendChat("/do Держит сигарету в правой руке.")
		wait(7000)
        sampSendChat("/me сделал глубокий затяг сигареты, после чего стряхнул пепел")
		wait(1200)
		sampSendChat("/anim 1")
		wait(10000)
		sampSendChat("/me снова сделал глубокий затяг сигареты, после чего стряхнул пепел")
		wait(1200)
		sampSendChat("/anim 1")
		wait(10000)
		sampSendChat("/me продолжает затягиваться сигаретой, пуская дым в воздух")
		wait(1200)
		sampSendChat("/anim 1")
		wait(5000)
        sampSendChat("/do Недалеко стоит небольшая урна.")
		wait(5000)
		sampSendChat("/try сделав последний затяг, ловким движением двух пальцев попал бычком в урну")
		wait(100)
		sampAddChatMessage(' [RRSG LSPD]{ffffff} Конец отыгровки.', 0xae433d)
		end)
		end
		if imgui.Button(u8'Проверить снаряжение. (36 секунды)', btn_size) then rpmenu.v = false
		lua_thread.create(function()
		sampAddChatMessage(' [RRSG LSPD]{ffffff} Старт отыгровки. Для отмены нажмите CTRL + R.', 0xae433d)
		wait(100)	
		sampSendChat("/do На груди висит четыре подсумка.")
        wait(5000)
        sampSendChat("/me начал проверять свое снаряжение, проверяя каждый подсумок")
        wait(6000)
        sampSendChat("/me проверил первый подсумок")
		wait(3000)
        sampSendChat("/do В первом подсумке лежит аптечка АИ-2 и перевязочный пакет ИПП-1.")
		wait(8000)
		sampSendChat("/me проверил второй и третий подсумок")
		wait(3000)
		sampSendChat("/do Во втором и третьем подсумке лежит 5 магазинов для М4, 6 магазинов для Deagle, 5 обойм для Rifle.")
		wait(8000)
		sampSendChat("/me проверил четвертый подсумок")
		wait(3000)
		sampSendChat("/do В четвертом подсумке лежат 2 небольших фильтра для противогаза, ключи, сигареты, наручники.")
		wait(100)
		sampAddChatMessage(' [RRSG LSPD]{ffffff} Конец отыгровки.', 0xae433d)
		end)
	    end
		if imgui.Button(u8'Полная маскировка себя. (7 секунд)', btn_size) then rpmenu.v = false
		lua_thread.create(function()
		sampAddChatMessage(' [RRSG LSPD]{ffffff} Старт отыгровки. Для отмены нажмите CTRL + R.', 0xae433d)
		wait(100)
		sampSendChat("/do Неизвестный одет в военную форму из номекса темно серого цвета.")
        wait(3500)
        sampSendChat("/do На бронежилете нашивка POLICE, другие распознавательные знаки отсутствуют.")
        wait(3500)
        sampSendChat("/do Лицо скрыто балаклавой, личность не распознать.")
		wait(100)
		sampAddChatMessage(' [RRSG LSPD]{ffffff} Конец отыгровки.', 0xae433d)
		end)
		end
		if imgui.Button(u8'Полная маскировка всех стоящих рядом. (7 секунд)', btn_size) then rpmenu.v = false
		lua_thread.create(function()
		sampAddChatMessage(' [RRSG LSPD]{ffffff} Старт отыгровки. Для отмены нажмите CTRL + R.', 0xae433d)
		wait(100)
		sampSendChat("/do Неизвестные одеты в военную форму из номекса темно серого цвета.")
        wait(3500)
        sampSendChat("/do Распознавательные знаки на форме отсутствуют.")
        wait(3500)
        sampSendChat("/do Лица скрыты балаклавами, личности не распознать.")
		wait(100)
		sampAddChatMessage(' [RRSG LSPD]{ffffff} Конец отыгровки.', 0xae433d)
		end)
		end
		if imgui.Button(u8'Маскировка автомобиля и сидящих в нем. (7 секунд)', btn_size) then rpmenu.v = false
		lua_thread.create(function()
		sampAddChatMessage(' [RRSG LSPD]{ffffff} Старт отыгровки. Для отмены нажмите CTRL + R.', 0xae433d)
		wait(100)	
		sampSendChat("/do Водитель и пассажиры находятся в автомобиле без опозновательных знаков.")
        wait(3500)
        sampSendChat("/do Автомобиль полностью бронирован, номерные знаки отсутствуют, шины пулестойкие.")
        wait(3500)
        sampSendChat("/do Стекла автомобиля затонированы, личность водителя и пассажиров не распознать.")
		wait(100)
		sampAddChatMessage(' [RRSG LSPD]{ffffff} Конец отыгровки.', 0xae433d)
		end)
		end
		if imgui.Button(u8'Надеть противогаз. (18 секунд)', btn_size) then rpmenu.v = false
		lua_thread.create(function()
		sampAddChatMessage(' [RRSG LSPD]{ffffff} Старт отыгровки. Для отмены нажмите CTRL + R.', 0xae433d)
		wait(100)	
		sampSendChat("/do На бедре левой ноги висит подсумок с противогазом ГП-21.")
        wait(4000)
        sampSendChat("/me задержав дыхание, достал противогаз и ловким движением надел его")
        wait(1200)
        sampSendChat("/anim 1")
		wait(7000)
        sampSendChat("/me повернул крышку фильтра, затем сделал глубокий вдох")
		wait(3000)
        sampSendChat("/time")
		wait(1200)
        sampSendChat("/me засек время работы фильтра противогаза")
		wait(100)
		sampAddChatMessage(' [RRSG LSPD]{ffffff} Конец отыгровки.', 0xae433d)
		end)
		end
		if imgui.Button(u8'ПМП при ранении. (35 секунд)', btn_size) then rpmenu.v = false
		lua_thread.create(function()
		sampAddChatMessage(' [RRSG LSPD]{ffffff} Старт отыгровки. Для отмены нажмите CTRL + R.', 0xae433d)
		wait(100)	
		sampSendChat("/me достал из подсумка разгрузки перевязочный пакет ИПП-1 и аптечку АИ-2")
        wait(5000)
        sampSendChat("/anim 16")
        wait(2000)
        sampSendChat("/me осматривает рану")
		wait(7000)
        sampSendChat("/me достал из аптечки АИ-2 белый шприц-тюбик содержащий промедол")
		wait(7000)
        sampSendChat("/me вколол белый шприц-тюбик рядом с местом ранения")
		wait(7000)
        sampSendChat("/me открыл перевязочный пакет и крепко перевязал рану")
		wait(7000)
        sampSendChat("/me сложил медицинский инвентарь, после чего убрал его в подсумок разгрузки")
		wait(100)
		sampAddChatMessage(' [RRSG LSPD]{ffffff} Конец отыгровки.', 0xae433d)
		end)
		end
		if imgui.Button(u8'Объяснения и права к ООП в машине. (33 секунды)', btn_size) then rpmenu.v = false
		lua_thread.create(function()
		sampAddChatMessage(' [RRSG LSPD]{ffffff} Старт отыгровки. Для отмены нажмите CTRL + R.', 0xae433d)
		wait(100)	
		sampSendChat("/todo Итак..*держа в руках ориентировку на имя задержанного")
        wait(5000)
        sampSendChat("Вы находитесь в федеральном розыске и были пойманы по наводке диспетчера.")
        wait(7000)
        sampSendChat("Вы нарушили много статей УК штата и должны ответить за свои поступки перед законом.")
		wait(7000)
        sampSendChat("Просим вас молчать и не поддаваться эмоциям, неадекватное поведение только ухудшит вашу ситуацию.")
		wait(7000)
        sampSendChat("За хорошее поведение ваши обвинения не будут отягчающими и мы пойдем вам на встречу.")
		wait(7000)
        sampSendChat("/me легким движением руки убрал ориентировку в бардачок автомобиля")
		wait(100)
		sampAddChatMessage(' [RRSG LSPD]{ffffff} Конец отыгровки.', 0xae433d)
		end)
		end
		if imgui.Button(u8'Подготовка к взлету на вертолете. (11 секунд)', btn_size) then rpmenu.v = false
		lua_thread.create(function()
		sampAddChatMessage(' [RRSG LSPD]{ffffff} Старт отыгровки. Для отмены нажмите CTRL + R.', 0xae433d)
		wait(100)	
		sampSendChat("/todo Диспетчер, борт MAV-497 готов к вылету..*одев наушники пилота")
        wait(7000)
        sampSendChat("/me быстрым движением руки включает необходимые приборы для взлета")
        wait(4000)
        sampSendChat("/do В кабине вертолета раздается характерный звук щелчков. Лопасти начинают раскручиваться.")
		wait(100)
		sampAddChatMessage(' [RRSG LSPD]{ffffff} Конец отыгровки.', 0xae433d)
		end)
		end
		if imgui.Button(u8'Замена пластин бронежилета из багажника. (16 секунд)', btn_size) then rpmenu.v = false
		lua_thread.create(function()
		sampAddChatMessage(' [RRSG LSPD]{ffffff} Старт отыгровки. Для отмены нажмите CTRL + R.', 0xae433d)
		wait(100)	
		sampSendChat("/me проверил целостность железных пластин в бронежилете")
        wait(4000)
        sampSendChat("/do В бронежилете повреждено несколько железных пластин от выстрелов.")
        wait(5000)
        sampSendChat("/me вытащил из бронежилета поврежденные пластины, затем бросил их в багажник авто")
		wait(1200)
		sampSendChat("/anim 12")
		wait(6000)
        sampSendChat("/me достал из багажника новые платистины, затем вставил их в бронежилет")
		wait(1200)
		sampSendChat("/anim 12")
		wait(100)
		sampAddChatMessage(' [RRSG LSPD]{ffffff} Конец отыгровки. Чтобы снять стан после анимки, сделайте блок(ПКМ + Shift) или удар кулаком.', 0xae433d)
		end)
		end
		imgui.End()
		end
				




  if main_window_state.v then
    imgui.ShowCursor = true
    local x, y = getScreenResolution()
    local btn_size = imgui.ImVec2(-0.1, 0)  
    imgui.SetNextWindowPos(imgui.ImVec2(x/2, y/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(300, 300), imgui.Cond.FirstUseEver) 
    imgui.Begin(u8('RRSG LSPD | Главное меню'), main_window_state, imgui.WindowFlags.NoResize)
    if imgui.Button(u8'Команды и функции скрипта', btn_size) then
	commandi.v = not commandi.v
    end
	if imgui.Button(u8'Информация для стажёров', btn_size) then 
      stajer.v = not stajer.v
    end
	if imgui.Button(u8'Позывные', btn_size) then 
      pozivnie.v = not pozivnie.v
    end
	if imgui.Button(u8'Тен-коды', btn_size) then 
      kodi.v = not kodi.v
    end
	if imgui.Button(u8'Протокол "Призрак"', btn_size) then 
      protokol.v = not protokol.v
	  end
	if imgui.Button(u8'Настройки', btn_size) then
	 nastr.v = not nastr.v
	 end
	 if imgui.CollapsingHeader(u8 'Действия со скриптом', btn_size) then
	 if imgui.Button(u8'Перезагрузить скрипт', btn_size) then
    thisScript():reload()
    end
    if imgui.Button(u8 'Отключить скрипт', btn_size) then
    thisScript():unload()
    end
	 if imgui.Button(u8'Обновление', btn_size) then
      update()
    end
	end
	end
	imgui.End()
  
  
  
  if nastr.v then
  mainIni = inicfg.load(nil, directIni)
  local tag = imgui.ImBuffer(u8(mainIni.config.tag), 256)
  imgui.ShowCursor = true
    local x, y = getScreenResolution()
    local btn_size = imgui.ImVec2(-0.1, 0)  
    imgui.SetNextWindowPos(imgui.ImVec2(x/2, y/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(700, 400), imgui.Cond.FirstUseEver) 
    imgui.Begin(u8('RRSG LSPD | Настройки'), nastr, imgui.WindowFlags.NoResize)
    if imgui.InputText(u8('Выберите ваш тэг'), tag) then
	mainIni.config.tag = u8:decode(tag.v)
	inicfg.save(mainIni, directIni)
	end
imgui.End()
	end


  
  if commandi.v then
imgui.ShowCursor = true
    local x, y = getScreenResolution()
    local btn_size = imgui.ImVec2(-0.1, 0)  
    imgui.SetNextWindowPos(imgui.ImVec2(x/2, y/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(500, 400), imgui.Cond.FirstUseEver) 
    imgui.Begin(u8('RRSG LSPD | Команды и функции скрипта'), commandi, imgui.WindowFlags.NoResize)
	imgui.Text(u8'Прицел и Numpad 3 - Оглушение')
	imgui.Text(u8'/re - Шифр.Канал')
	imgui.Text(u8'Прицел и Numpad 5 - Снять маску с человека')
	imgui.Text(u8'Прицел и Numpad 6 - Обыск на прослушку')
	imgui.Text(u8'Numpad 7 - Смена клиста [/clist 32 <-> /clist 33] and [/clist ~ <-> /clist 32]')
	imgui.Text(u8'Numpad 8 - Натянуть маску на лицо / Снять с маску с лица')
	imgui.Text(u8'Прицел и Numpad 9 - Прием')
	imgui.Text(u8'4 - Кричалка')
	imgui.Text(u8'5 - Кричалка /m')
	imgui.Text(u8'P (англ) - Патруль (/patrul)')
	imgui.Text(u8'Numpad + - Посмотреть на часы')
	imgui.Text(u8'L - Открыть транспорт')
	imgui.Text(u8'J - открыть меню скрипта')
	imgui.Text(u8'K - открыть меню РП отыгровок')
	imgui.End()
	end
	
	if stajer.v then
    local iScreenWidth, iScreenHeight = getScreenResolution()
    imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(1261, 436), imgui.Cond.FirstUseEver)
    imgui.Begin(u8('Информация для стажеров'), stajer, imgui.WindowFlags.NoResize)
	imgui.BeginChild('##set', imgui.ImVec2(210, 400), true)
	if imgui.Selectable(u8'Информация по рации', show == 1) then show = 1 end
	if imgui.Selectable(u8'Общие положения', show == 2) then show = 2 end
	if imgui.Selectable(u8'Правила докладов в шифр (/re)', show == 3) then show = 3 end
	if imgui.Selectable(u8'Первостепенные задачи R.R.S.G', show == 4) then show = 4 end
	if imgui.Selectable(u8'Сотрудникам R.R.S.G разрешено', show == 5) then show = 5 end
	imgui.EndChild()
	imgui.SameLine()
	imgui.BeginChild('##set1', imgui.ImVec2(1100, 400), true)
	if show == 1 then
	imgui.Text(u8'• При взаимодействии или общении в рацию с бойцами RRSG нужно использовать рацию зашифрованной волны (( /r [Enc. Channel] ))')
	imgui.Text(u8'Пример: Abraham_Norton: [Enc. Channel]: code 10 1-3.')
	imgui.Text(u8'• В шифр. идут доклады о работе с напарниками из СО или ФБР. Если работаете с другими отделами - доклады на обычную волну.')
	imgui.Text(u8'• В общении с основным составом ЛСПД обычный тэг и рацию (( /r [Academy R.R.S.G] [Operative R.R.S.G] ))')
	imgui.Text(u8'• Никаких позывных писать не нужно. Позывными общаемся только в шифр канал. Чтобы другие не понимали, к кому мы обращаемся.')
	imgui.Text(u8'• Кодировку тоже не палите, не путайте волны. Если вас спросили в шифр, отвечаете в шифр. За нарушение кодировки будете сторого наказаны.')
	end
	if show == 2 then
	imgui.Text(u8'• С первых же минут нахождения в нашем отряде, вам запрещено проявление любого рода неадекватного поведения, как со своими бойцами,')
	imgui.Text(u8'так и с другими сотрудниками других отделений. Запрещены оскорбления и мат. Вы должны вести себя достойно, ведь теперь вы часть элитного подразделения.')
	imgui.Text(u8'• При построении / собраниях поднимаем подшлемник, открывая лицо. Приступая к работе, опускаем подшлемник на лицо.')
	imgui.Text(u8'• Вы обязаны выучить все Тен-Коды и позывные нашего отряда.')
	imgui.Text(u8'• Вы обязанны участвовать во всех мероприятиях нашего отряда.')
	imgui.Text(u8'• Запомните, разглашение любой информации о нашем отряде, которой нет на форуме, карается исключением и занесением в ЧС без права на выход.')
	imgui.Text(u8'• Вы обязаны выполнять все приказы нашего руководства без каких-либо вопросов и сомнений.')
	imgui.Text(u8'• Вы обязаны всегда быть чем-то заняты, если у вас нет напарника, то вы едете в порт или едете проверять АММО и МО, но не стоять в гараже без дела.')
	imgui.Text(u8'• Вы обязаны всегда реагировать на code 01, code 03, code 06, а так же другие коды нашего отряда.')
	imgui.Text(u8'• Вы обязаны завершить стажировку в нашем отряде, в противном случае вы попадете в ЧС.')
	imgui.Text(u8'• Вы обязаны ответственно подходить к каждому экзамену вашей стажировки.')
	imgui.Text(u8'• Вы обязаны безупречно знать ФП и никогда не нарушать статьи, находящиеся в ФП.')
	imgui.Text(u8'• Если вы не знаете, как поступить в том или ином вопросе, вы обязаны поинтересоваться в правильности его решения с основным составом или командирами.')
	end
	if show == 3 then
	imgui.Text(u8'• При работе с нашими коллегами по отряду, вы обязаны к докладывать в шифр о том, чем вы заняты. Основные формы докладов строятся из Тен-Кодов,')
	imgui.Text(u8'которые есть в разделе Тен-Кодов данного скрипта.')
	imgui.Text(u8'• Если это патруль, то форма доклада строиться следующим образом: Код патруля, Позывной напарника или напарников.')
	imgui.Text(u8'Пример: 12-1-2 Воин (Код и позывной зависит от ситуации)')
	end
	if show == 4 then
	imgui.Text(u8'• Сотрудники отдела обязаны всегда быть в балаклавах [/clist 32] или масках [/mask]')
	imgui.Text(u8'• Быть всегда на готове в составе группы не менее двух человек')
	imgui.Text(u8'• Оказывать первую помощь гражданским лицам')
	imgui.Text(u8'• Участвовать во всех контртеррористических операциях')
	imgui.Text(u8'• Мгновенно реагировать на все поступающие вызовы от коллег, граждан и на волну департамента о помощи')
	end
	if show == 5 then
	imgui.Text(u8'• Во время ареста сразу надевать наручники на преступника')
	imgui.Text(u8'• Открывать огонь без предупреждения по особо опасным преступникам (ООП)')
	imgui.Text(u8'• Во время допроса использовать силу (в разумных целях)')
	imgui.Text(u8'• Не предъявлять документы, удостоверяющие Вашу личность')
	end
	imgui.EndChild()
	imgui.End()
	end
	
	if pozivnie.v then
	imgui.ShowCursor = true
    local x, y = getScreenResolution()
    local btn_size = imgui.ImVec2(-0.1, 0)  
    imgui.SetNextWindowPos(imgui.ImVec2(x/2, y/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(400, 500), imgui.Cond.FirstUseEver)
    imgui.Begin(u8('Позывные'), pozivnie, imgui.WindowFlags.NoResize)
	imgui.Text(u8'Старший состав LSPD:')
	imgui.Text(u8'Martin Milson - Ферзь')
	imgui.Text(u8'Anthony Embrerro - Старк')
	imgui.Text(u8'Ray Offset - Старший')
	imgui.Text(u8'Steve Bdonski - Бидон')
	imgui.Text(u8'Raymond Raylonds - Альфа')
	imgui.Text(u8'Emily Raylonds - Банши')
	imgui.Text(u8'Matthew Wainwright - Люцифер')
	imgui.Text(u8'Yuri Fallen - Соль')
	imgui.Text(u8'')
	imgui.Text(u8'Основа R.R.S.G:')
	imgui.Text(u8'Hugo Rogers - Орёл')
	imgui.Text(u8'Valentine Kairis - Малой')
	imgui.Text(u8'Robert Wainwright - Батя')
	imgui.Text(u8'Takeshi Fukuda - Аид')
	imgui.Text(u8'Olesya Yablokova - Ведьма')
	imgui.Text(u8'Egor Bortnik - Хантер')
	imgui.Text(u8'Evgeny Blansky - Либератор')
	imgui.Text(u8'Daniel Molotkov - Кайман')
	imgui.Text(u8' ')
	imgui.Text(u8'Стажеры R.R.S.G:')
	imgui.End()
end

    if kodi.v then
    local iScreenWidth, iScreenHeight = getScreenResolution()
    imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(731, 436), imgui.Cond.FirstUseEver)
	imgui.Begin(u8('Тен-коды'), kodi, imgui.WindowFlags.NoResize)
	imgui.BeginChild('##kodi', imgui.ImVec2(210, 400), true)
	if imgui.Selectable(u8'Response (Ответы/Доклады)', show == 1) then show = 1 end
	if imgui.Selectable(u8'Сode (Коды мест и обозначений)', show == 2) then show = 2 end
	if imgui.Selectable(u8'Сode (Коды руководства)', show == 3) then show = 3 end
	if imgui.Selectable(u8'Коды FBI', show == 4) then show = 4 end
	if imgui.Selectable(u8'Тен-коды (Статусы)', show == 5) then show = 5 end
	if imgui.Selectable(u8'Примеры докладов', show == 6) then show = 6 end
	imgui.EndChild()
	imgui.SameLine()
	imgui.BeginChild('##kodi1', imgui.ImVec2(500, 400), true)
	if show == 1 then
	imgui.Text(u8'22-5 - Принято')
	imgui.Text(u8'19-1 - Патруль города')
	imgui.Text(u8'19-0 - Патруль с агентом')
	imgui.Text(u8'19-2 - Нахожусь в порту ЛС')
	imgui.Text(u8'19-3 - Выехал на проверку АММО, МО, Порта ЛС')
	imgui.Text(u8'19-4 - Воздушный патруль и проверка АММО, МО, Порта ЛС')
	imgui.Text(u8'19-5 - Сопровождение фур LVA')
	imgui.Text(u8'16-1 - На связи(Если вас вызывают в шифр, вы отвечаете кодом)')
	imgui.Text(u8'16-3 - Отойду на время')
	imgui.Text(u8'16-5 - Ищу напарника')
	imgui.Text(u8'16-6 - Принял, ожидай меня')
	imgui.Text(u8'16-7 - Выехал на сборы от FBI')
	imgui.Text(u8'16-8 - Провожу допрос')
	imgui.Text(u8'16-9 причина - Занят, ожидайте меня')
end
    if show == 2 then
	imgui.Text(u8'2-1 - Нахожусь/жду в Холле ЛСПД')
	imgui.Text(u8'2-2 - Нахожусь/жду на втором этаже ЛСПД')
	imgui.Text(u8'2-3 - Нахожусь/жду в гараже ЛСПД')
	imgui.Text(u8'2-4 - Нахожусь/жду на ВП ЛСПД')
	imgui.Text(u8'2-5 - Нахожусь/жду у главного входа в ЛСПД')
	imgui.Text(u8'3-1 - Нахожусь/жду на Мэрии')
	imgui.Text(u8'3-2 - Нахожусь/жду у АММО ЛС')
	imgui.Text(u8'3-3 - Нахожусь/жду у МО ЛС')
	imgui.Text(u8'5-1 (Квадрат) - Нахожусь/жду в зоне квадрата')
	end
	if show == 3 then
	imgui.Text(u8'code 10 - Строй в гараже')
	imgui.Text(u8'code 15 - Доложить чем заняты')
	imgui.Text(u8'code 20 - Доложить где находитесь')
	imgui.Text(u8'code 25 - Вызов на второй')
	imgui.Text(u8'code 30 - Вызов в штаб. квартиру')
	end
	if show == 4 then
	imgui.Text(u8'Code 01 - Перекличка на пдж агента')
	imgui.Text(u8'Code 03 - Cпец.операция')
	imgui.Text(u8'Code 06 - Похищение, терракт')
	end
	if show == 5 then
	imgui.Text(u8'Status 1 - Все спокойно, продолжаем работу')
	imgui.Text(u8'Status 2 - везем нарушителя в участок')
	imgui.Text(u8'Status 3 - ЧС')
	end
	if show == 6 then
	imgui.Text(u8'Если вы находитесь в наземной патруле с напарником')
	imgui.Text(u8'19-1(Патруль)-1(Статус) Позывной(Позывные напарников). Пример: 19-1-1 Кабан')
	imgui.Text(u8'')
	imgui.Text(u8'В ходе работы вы поймали ООП и везете его на допрос')
	imgui.Text(u8'19-1(Патруль)-2(Статус) Позывной(Позывные напарников). Пример: 12-1-2 Воин')
	imgui.Text(u8'')
	imgui.Text(u8'Если вы ничем не заняты или в патруле с напарником слышите 15-5')
	imgui.Text(u8'16-6(Принял запрос о поиске напарника) 1-3(Жду в гараже). Пример: 16-6 2-3')
	imgui.Text(u8'')
	imgui.Text(u8'Вы занимаетесь сопровождением фур LVA, на вас напали бандиты')
	imgui.Text(u8'19-5(Сопровождение)-3(Статус) М-15(Квадрат ЧС). Пример: 19-5-3 М-15')
	end
	imgui.EndChild()
	imgui.End()
end

if protokol.v then
    local iScreenWidth, iScreenHeight = getScreenResolution()
    imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(1251, 436), imgui.Cond.FirstUseEver)
	imgui.Begin(u8('Протокол "Призрак"'), protokol, imgui.WindowFlags.NoResize)
	imgui.BeginChild('##kodi', imgui.ImVec2(230, 400), true)
	if imgui.Selectable(u8'Общие положения', show == 1) then show = 1 end
	if imgui.Selectable(u8'Действия, как нарушение протокола', show == 2) then show = 2 end
		imgui.EndChild()
	imgui.SameLine()
	imgui.BeginChild('##kodi1', imgui.ImVec2(1000, 400), true)
	if show == 1 then
	imgui.Text(u8'1.1. Командир и его заместители всегда правы')
	imgui.Text(u8'1.2. Если командир и его заместители не правы, то смотрите пункт 1.1')
	imgui.Text(u8'1.3. Все равны перед протоколом, как от Стажера, так и до Командира')
	imgui.Text(u8'1.4. За нарушение протокола предусмотрены наказания: устное предупреждение, наряд, выговор внутри отдела, отстранение')
	imgui.Text(u8'1.5. Меру наказания за нарушение протокола выбирает командир и его заместители')
	imgui.Text(u8'1.6. Вы обязаны соблюдать все законы штата и ФП, согласно протоколу')
	imgui.Text(u8'1.7. Незнание не освобождает вас от ответственности перед протоколом')
end
    if show == 2 then
	imgui.Text(u8'2.1. Если вы оспариваете решение командира или его заместителей, вы нарушили протокол')
	imgui.Text(u8'2.2. Если вы публично обсуждаете действия командира или его заместителей, вы нарушили протокол')
	imgui.Text(u8'2.3. Если вы игнорируете требования командира или его заместителей, вы нарушили протокол')
	imgui.Text(u8'2.4. Если вы проявляете любого рода неадекватное поведение, вы нарушили протокол')
	imgui.Text(u8'2.5. Если вы провоцируете кого-либо, вы нарушили протокол')
	imgui.Text(u8'2.6. Если вы поддались на провокацию от кого-либо, вы нарушили протокол')
	imgui.Text(u8'2.7. Если вы спите в неположенном месте больше минуты, вы нарушили протокол')
	imgui.Text(u8'2.8. Если вы находитесь на работе, но ничем не занимаетесь, вы нарушили протокол')
	imgui.Text(u8'2.9. Если вы игнорируете шифр, вы нарушили протокол')
	imgui.Text(u8'2.10. Если вы не докладываете о своей работе в шифр, вы нарушили протокол')
	imgui.Text(u8'2.11. Если вы перепутали шифр с общим каналом и наоборот и назвали код или позывной в общий канал, вы нарушили протокол')
	imgui.Text(u8'2.12. Если вы работаете с Агентом, в то время как ваш боец ищет напарника, вы нарушили протокол')
	imgui.Text(u8'2.13. Если вы нарушаете ФП, вы нарушили протокол')
	imgui.Text(u8'2.14. Если вы были наказаны за нарушение ФП Агентами или старшим руководством, то будете наказаны еще внутри отдела за нарушение протокола')
	imgui.Text(u8'2.15. Если вы нарушаете правила строя(разговоры, телефон и тд.), вы нарушили протокол')
	imgui.Text(u8'2.16. Если вы находитесь в строю в маске [/mask] и не подняли балаклаву [clist 33], вы нарушили протокол')
	imgui.Text(u8'2.17. Если вы сливаете любого рода информацию о отряде, которой нет на форуме или в таблице, вы нарушили протокол')
	imgui.Text(u8'2.18. Если вы игнорируете приказы командира и его заместителя, вы нарушили протокол')
end
	imgui.EndChild()
	imgui.End()
	end
	end
	
	
function main()
  while not isSampAvailable() do wait(0) end
      sampAddChatMessage("{1E90FF}RRSG LSPD {ffffff}| Автор: Abraham Norton. Доработка: Anthony Embrerro, Daniel Molotkov.", -1)
      sampAddChatMessage("{1E90FF}RRSG LSPD {ffffff}| Скрипт успешно загружен!", -1)
      sampAddChatMessage("{1E90FF}RRSG LSPD {ffffff}| Нажмите на {1E90FF}J{ffffff} чтобы открыть меню скрипта.", -1)
	  sampAddChatMessage("{1E90FF}RRSG LSPD {ffffff}| Нажмите на {1E90FF}K{ffffff} чтобы открыть меню RP отыгровок.", -1)
	  sampAddChatMessage("{1E90FF}RRSG LSPD {ffffff}| Нажмите на {1E90FF}6{ffffff} чтобы принять вызов.", -1)
	  sampRegisterChatCommand("re", re)
	  mainIni = inicfg.load(nil, directIni)
	  if mainIni == nil then
	  mainIni = {
	  config = {
	  tag = 'Academy R.R.S.«Ghost»'
	  }
	  }
	  inicfg.save(mainIni, directIni)
	  end
  while true do
    wait(0)		
	
	if testCheat("J") then main_window_state.v = true
	end
	if testCheat("K") then rpmenu.v = true
	end
	if testCheat("6") then
	mainIni = inicfg.load(nil, directIni)
	sampSendChat("/r ["..mainIni.config.tag.."] Принято, работаем!")
	end
			     if testCheat("4") then
        sampSendChat("/s Всем лежать, руки за голову, работает спец.отряд R.R.S.Ghost! Без глупостей и резких движений!")
			end
		if testCheat("5") then
        sampSendChat("/m Водитель, немедленно снизьте скорость и прижмитесь к обочине! Не вынуждайте открывать огонь!")
			end	
      if isKeyJustPressed(VK_NUMPAD3) then
        local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
        if valid then
            result, targetid = sampGetPlayerIdByCharHandle(ped)
            if result then
              local name = sampGetPlayerNickname(targetid)
        sampSendChat("/me резким движением руки вырубил " ..name.. " прикладом оружия")
        wait(2400)
        sampSendChat("/do " ..name.. " потерял сознание от удара прикладом.")
        end
      end
      end
      if isKeyJustPressed(VK_ADD) then sampSendChat("/time")
      end
      if testCheat("L") then sampSendChat("/lock")
      end
			if testCheat("P") then sampSendChat("/patrul")
			end
			if isKeyJustPressed(VK_NUMPAD8) then
				sampSendChat("/mask")
			end
			if isKeyJustPressed(VK_NUMPAD5) then
				local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
        if valid then
            result, targetid = sampGetPlayerIdByCharHandle(ped)
            if result then
              local name = sampGetPlayerNickname(targetid)
				sampSendChat("/offmask " ..targetid.. "")
			end
		end
			end
      if isKeyJustPressed(VK_NUMPAD9) then
        local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
        if valid then
            result, targetid = sampGetPlayerIdByCharHandle(ped)
            if result then
              local name = sampGetPlayerNickname(targetid)
        sampSendChat("/me резко развернулся, заломав руки " ..name.. " и выбив с них оружие")
        end
      end
      end
      if isKeyJustPressed(VK_NUMPAD6) then
        local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
        if valid then
            result, targetid = sampGetPlayerIdByCharHandle(ped)
            if result then
              local name = sampGetPlayerNickname(targetid)
        sampSendChat("/me обыскал " ..name.. " на наличие средств связи")
        wait(5000)
        sampSendChat("/me забрал у " ..name.. " найденные средства связи")
        wait(3000)
        sampSendChat("/do У " ..name.. " изъята рация и телефон.")
        end
      end
      end
      if isKeyJustPressed(VK_NUMPAD7) then
      local color = ("%06X"):format(bit.band(sampGetPlayerColor(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))), 0xFFFFFF))
		if color == "333333" then
				sampSendChat("/clist 33")
				wait(1200)
				sampSendChat("/me поднял подшлемник, открыв лицо")
			end
		if color ==  "FFFFFF" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
			end
		if color == "089401" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "56FB4E" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "49E789" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "2A9170" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "9ED201" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "279B1E" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "003366" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "FF0606" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "FF6600" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "F45000" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "BE8A01" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "B30000" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "954F4F" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "E7961D" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "E6284E" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "FF9DB6" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "110CE7" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "0CD7E7" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "139BEC" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "2C9197" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "114D71" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "8813E7" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "B313E7" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "758C9D" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "FFDE24" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "FFEE8A" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "DDB201" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "DDA701" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "B0B000" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "868484" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "B8B6B6" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		if color == "FAFAFA" then
				sampSendChat("/clist 32")
				wait(1200)
				sampSendChat("/me опустил подшлемник, закрыв лицо")
		end
		end
    imgui.Process = main_window_state.v or commandi.v or stajer.v or pozivnie.v or kodi.v or protokol.v or rpmenu.v or reanie.v or nastr.v
	apply_custom_style()
	end
end

function re(text)
  if text ~= '' then
		if tag == nil then
			sampSendChat('/r '..text)
		else
			sampSendChat('/r '..tag..' '..text)
		end
end
end
