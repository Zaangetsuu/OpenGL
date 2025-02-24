#pragma once

class IndexBuffer
{
private:
	unsigned int m_IndexBufferID{};
	unsigned int m_Count;

public:
	IndexBuffer(const unsigned int* data, unsigned int count);
	~IndexBuffer();

	void Bind() const;
	void Unbind() const;

	unsigned int GetCount() const;
};

