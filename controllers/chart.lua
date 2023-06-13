local chart_c = {}

function chart_c.DELETE(self)
	local ctx = self.ctx
	ctx.chart:delete()
	return {status = 204}
end

return chart_c
