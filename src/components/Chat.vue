<template>
    <div class="chat-container">
        <div v-if="isOpen" class="chat-window">
            <div class="chat-header">
                <h3>AI Assistant</h3>
                <button class="close-button" @click="toggleChat">×</button>
            </div>
            <div class="chat-messages" ref="messagesContainer">
                <div
                    v-for="(message, index) in messages"
                    :key="index"
                    :class="['message', message.type]"
                >
                    {{ message.text }}
                </div>
            </div>
            <div class="chat-input">
                <input
                    v-model="userInput"
                    @keyup.enter="sendMessage"
                    placeholder="Type your message..."
                    type="text"
                />
                <button @click="sendMessage" :disabled="isLoading">
                    <span v-if="isLoading">...</span>
                    <span v-else>Send</span>
                </button>
            </div>
        </div>
        <button v-else class="chat-button" @click="toggleChat">
            <svg
                xmlns="http://www.w3.org/2000/svg"
                width="24"
                height="24"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"
            >
                <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
            </svg>
        </button>
    </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue';

const isOpen = ref(false);
const userInput = ref('');
const messages = ref<Array<{ text: string; type: 'user' | 'ai' }>>([]);
const isLoading = ref(false);
const messagesContainer = ref<HTMLElement | null>(null);

const token = '';
const endpoint = 'https://models.github.ai/inference/chat/completions';
const model = 'deepseek/DeepSeek-V3-0324';

function toggleChat() {
    isOpen.value = !isOpen.value;
}

async function sendMessage() {
    if (!userInput.value.trim() || isLoading.value) return;

    const userMessage = userInput.value;
    messages.value.push({ text: userMessage, type: 'user' });
    userInput.value = '';
    isLoading.value = true;

    try {
        console.log('Sending request to:', endpoint);
        const response = await fetch(endpoint, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                Authorization: `Bearer ${token}`,
                Accept: 'application/json',
            },
            body: JSON.stringify({
                messages: [
                    {
                        role: 'system',
                        content:
                            'You are a helpful job search assistant. Provide very short, concise answers in plain text without any markdown formatting, special characters, or emojis. Keep responses under 2-3 sentences.',
                    },
                    {
                        role: 'user',
                        content: userMessage,
                    },
                ],
                temperature: 0.7,
                top_p: 0.1,
                max_tokens: 150,
                model: model,
            }),
        });

        console.log('Response status:', response.status);
        const data = await response.json();
        console.log('Response data:', data);

        if (!response.ok) {
            throw new Error(data.error?.message || `HTTP error! status: ${response.status}`);
        }

        const aiResponse = data.choices[0].message.content;
        messages.value.push({ text: aiResponse, type: 'ai' });
    } catch (error) {
        console.error('Detailed error:', error);
        messages.value.push({
            text: `Error: ${error instanceof Error ? error.message : 'Unknown error occurred'}`,
            type: 'ai',
        });
    } finally {
        isLoading.value = false;
    }
}

watch(messages, () => {
    if (messagesContainer.value) {
        setTimeout(() => {
            messagesContainer.value!.scrollTop = messagesContainer.value!.scrollHeight;
        }, 100);
    }
});
</script>

<style scoped>
.chat-container {
    position: fixed;
    bottom: 2rem;
    right: 2rem;
    z-index: 1000;
}

.chat-button {
    width: 3.5rem;
    height: 3.5rem;
    border-radius: 50%;
    background-color: var(--color-primary);
    color: white;
    border: none;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.15);
    transition: transform 0.2s;
}

.chat-button:hover {
    transform: scale(1.05);
}

.chat-window {
    position: fixed;
    bottom: 2rem;
    right: 2rem;
    width: 350px;
    height: 500px;
    background-color: white;
    border-radius: 12px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
    display: flex;
    flex-direction: column;
}

.chat-header {
    padding: 1rem;
    background-color: var(--color-primary);
    color: white;
    border-radius: 12px 12px 0 0;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.chat-header h3 {
    margin: 0;
    font-size: 1.1rem;
}

.close-button {
    background: none;
    border: none;
    color: white;
    font-size: 1.5rem;
    cursor: pointer;
    padding: 0;
    line-height: 1;
}

.chat-messages {
    flex: 1;
    padding: 1rem;
    overflow-y: auto;
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
}

.message {
    max-width: 80%;
    padding: 0.75rem 1rem;
    border-radius: 12px;
    line-height: 1.4;
}

.message.user {
    background-color: var(--color-primary);
    color: white;
    align-self: flex-end;
    border-bottom-right-radius: 4px;
}

.message.ai {
    background-color: #f0f0f0;
    color: #333;
    align-self: flex-start;
    border-bottom-left-radius: 4px;
}

.chat-input {
    padding: 1rem;
    border-top: 1px solid #eee;
    display: flex;
    gap: 0.5rem;
}

.chat-input input {
    flex: 1;
    padding: 0.75rem;
    border: 1px solid #ddd;
    border-radius: 8px;
    outline: none;
}

.chat-input button {
    padding: 0.75rem 1.5rem;
    background-color: var(--color-primary);
    color: white;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    transition: background-color 0.2s;
}

.chat-input button:hover {
    background-color: var(--color-primary-dark);
}

.chat-input button:disabled {
    background-color: #ccc;
    cursor: not-allowed;
}

@media (max-width: 640px) {
    .chat-window {
        width: calc(100% - 2rem);
        height: calc(100% - 4rem);
        bottom: 1rem;
        right: 1rem;
    }
}
</style>
