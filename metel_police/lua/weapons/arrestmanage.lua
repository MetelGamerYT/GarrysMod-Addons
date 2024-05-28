AddCSLuaFile()

SWEP.Author = "DerMetelGamerYT"
SWEP.Instructions  = "LMB on a Player to Arrest"

SWEP.Spawnable      = true
SWEP.AdminOnly      = false
SWEP.UseHands      = true
SWEP.Category       = "DarkRP Police"

SWEP.ViewModel = ""
SWEP.WorldModel = ""

SWEP.Primary.ClipSize    = -1
SWEP.Primary.DefaultClip  = -1
SWEP.Primary.Automatic    = false
SWEP.Primary.Ammo      = "none"

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic  = false
SWEP.Secondary.Ammo      = "none"

SWEP.AutoSwitchTo      = false
SWEP.AutoSwitchFrom      = false

SWEP.PrintName        = "Arrest Player"
SWEP.Slot          = 0
SWEP.SlotPos        = 1
SWEP.DrawAmmo        = false

SWEP.window = nil

function SWEP:Deploy()
  if SERVER then return true end
  return true
end

function SWEP:Holster()
  if SERVER then return true end

  return true
end

function SWEP:OnRemove()
   return true
end

local edgeWidth = 2
function DrawEdges(x,y,width,height,edgeSize)
    surface.SetDrawColor(Color(50,50,50,200))
    surface.DrawRect(0,0,width,height)

    surface.SetDrawColor(Color(255,255,255))
    surface.DrawRect(x,y,edgeSize,edgeWidth)
	surface.DrawRect(x,y + edgeWidth,edgeWidth,edgeSize - edgeWidth)

	local XRight = x + width

	surface.DrawRect(XRight - edgeSize,y,edgeSize,edgeWidth)
	surface.DrawRect(XRight - edgeWidth,y + edgeWidth,edgeWidth,edgeSize - edgeWidth)

	local YBottom = y + height

	surface.DrawRect(XRight - edgeSize,YBottom - edgeWidth,edgeSize,edgeWidth)
	surface.DrawRect(XRight - edgeWidth,YBottom - edgeSize,edgeWidth,edgeSize - edgeWidth)

	surface.DrawRect(x,YBottom - edgeWidth,edgeSize,edgeWidth)
	surface.DrawRect(x,YBottom - edgeSize,edgeWidth,edgeSize - edgeWidth)
end

function SWEP:PrimaryAttack()
    local tr = self.Owner:GetEyeTrace().Entity
    if IsValid(tr) and tr:IsPlayer() then
        if self.Owner:GetPos():DistToSqr(tr:GetPos()) <= 6000 then
            local tracedPlayer = tr
            if SERVER then return end
            if IsValid(self.window) then return end
            self.window = vgui.Create("DFrame")
            self.window:SetTitle(MetelPolice_Config.ArrestTitle)
            self.window:SetSize(300, 150)
            self.window:ShowCloseButton(true)
            self.window:Center()
            self.window:MakePopup()
            function self.window:Paint(w,h)
                DrawEdges(0,0,w,h,8)
            end

            -- Reason
            local reasonLabel = vgui.Create("DLabel", self.window)
            reasonLabel:Dock(TOP)
            reasonLabel:SetText("Reason")

            local reasonText = vgui.Create("DTextEntry", self.window)
            reasonText:Dock(TOP)
            reasonText:SetDrawLanguageID(false)
            reasonText:SetPlaceholderText("Killed Horst Baum")

            -- Lenght
            local lenghtLabel = vgui.Create("DLabel", self.window)
            lenghtLabel:Dock(TOP)
            lenghtLabel:SetText("Lenght (In Minutes) - Not higher than "..MetelPolice_Config.MaxArrestTime.." minutes!")

            local lenghtText = vgui.Create("DTextEntry", self.window)
            lenghtText:Dock(TOP)
            lenghtText:SetNumeric(true)
            lenghtText:SetDrawLanguageID(false)
            lenghtText:SetPlaceholderText("15")

            -- Button
            local acceptBTN = vgui.Create("DButton", self.window)
            acceptBTN:SetText("Accept")
            acceptBTN:Dock(BOTTOM)
            function acceptBTN:Paint(w,h)
                DrawEdges(0,0,w,h,8)
                if self:IsHovered() then
                    self:SetTextColor(Color(148, 34, 27))
                else
                    self:SetTextColor(Color(255,255,255))
                end
            end

            acceptBTN.DoClick = function(self)
                net.Start("MetelPolice_ArrestPlayer")
                    net.WriteEntity(tracedPlayer)
                    net.WriteString(reasonText:GetValue())
                    net.WriteString(lenghtText:GetInt())
                net.SendToServer()
            end
        end
    end
end