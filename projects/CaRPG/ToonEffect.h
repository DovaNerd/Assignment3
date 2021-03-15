#pragma once

#include "Graphics/Post/PostEffect.h"

class ToonEffect : public PostEffect
{
public:
	void Init(unsigned width, unsigned height) override;

	//apply effect
	void ApplyEffect(PostEffect* buffer) override;

};
