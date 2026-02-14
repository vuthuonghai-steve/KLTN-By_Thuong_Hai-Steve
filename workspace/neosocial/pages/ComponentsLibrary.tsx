import React from 'react';
import { NeoButton, NeoCard, NeoInput, NeoTextarea, NeoAvatar } from '../components/UI';

export const ComponentsLibrary: React.FC = () => {
  return (
    <div className="p-8 max-w-5xl mx-auto space-y-12">
      <header>
        <h1 className="text-4xl font-black mb-2">UI Component Library // Neo-Brutalism Style</h1>
        <p className="font-mono">A collection of main UI components for the social network.</p>
      </header>

      <section>
        <h2 className="text-2xl font-bold mb-4 font-mono">&lt;Buttons&gt;</h2>
        <div className="flex flex-wrap gap-6 items-center border-2 border-black p-6 bg-neo-pastelYellow shadow-hard">
          <NeoButton>Primary Action</NeoButton>
          <NeoButton variant="secondary">Secondary Action</NeoButton>
          <NeoButton disabled className="opacity-50 cursor-not-allowed bg-gray-300">Disabled</NeoButton>
          <NeoButton variant="ghost">Ghost Action</NeoButton>
        </div>
      </section>

      <section>
        <h2 className="text-2xl font-bold mb-4 font-mono">// Cards</h2>
        <div className="grid md:grid-cols-2 gap-8">
          <NeoCard>
            <div className="flex gap-4 items-center mb-4">
              <NeoAvatar src="https://picsum.photos/seed/card1/100" alt="Avatar" />
              <div>
                <h3 className="font-bold">@username</h3>
                <p className="font-mono text-xs">Joined: Jan 1, 2024</p>
              </div>
            </div>
            <p className="font-mono text-sm">Short user description in monospace font to see how it looks.</p>
          </NeoCard>

          <NeoCard>
             <div className="w-full h-32 bg-neo-pastelBlue border-2 border-black mb-4 flex items-center justify-center font-black text-2xl text-white/50">IMG</div>
             <h3 className="font-bold text-lg mb-2">This is a Bold Title</h3>
             <p className="font-mono text-sm mb-4">Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
             <div className="flex gap-4 text-sm font-bold">
                <span>♡ Like</span>
                <span>💬 Comment</span>
             </div>
          </NeoCard>
        </div>
      </section>

      <section>
        <h2 className="text-2xl font-bold mb-4 font-mono">[Input Fields]</h2>
        <NeoCard className="space-y-6">
            <NeoInput label="Username" placeholder="Enter your username..." />
            <NeoInput label="Password" type="password" placeholder="password" />
            <NeoTextarea label="Bio" placeholder="Write something about yourself..." />
        </NeoCard>
      </section>

       <section>
        <h2 className="text-2xl font-bold mb-4 font-mono">// Boxes & Image Display</h2>
        <div className="grid md:grid-cols-2 gap-8 items-start">
             <div className="space-y-4">
                 <div className="h-24 bg-neo-pastelGreen border-2 border-black shadow-hard flex items-center justify-center font-mono">Large Box</div>
                 <div className="h-16 w-3/4 bg-neo-pastelGreen border-2 border-black shadow-hard flex items-center justify-center font-mono">Medium Box</div>
                 <div className="h-12 w-1/2 bg-neo-pastelGreen border-2 border-black shadow-hard flex items-center justify-center font-mono">Small Box</div>
             </div>
             
             <NeoCard className="flex items-center justify-center p-8">
                 <div className="bg-white p-3 border-2 border-black shadow-hard transform rotate-2">
                     <div className="w-48 h-48 bg-gray-200 border-2 border-black mb-2"></div>
                     <div className="h-4 w-full bg-gray-100"></div>
                 </div>
             </NeoCard>
        </div>
      </section>

    </div>
  );
};
