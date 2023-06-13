local logout_c = {}

function logout_c.POST(self)
	self.session.user_id = nil
	return {redirect_to = self:url_for("home")}
end

return logout_c
